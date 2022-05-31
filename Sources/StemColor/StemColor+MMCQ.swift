
public extension Array where Element == StemColor.RGBSpace.Unpack<UInt8> {

    func mmcq(maxCount: Int, quality: Int) -> [StemColor.RGBSpace.Unpack<UInt8>] {
        let list = stride(from: 0, to: count, by: quality).map({ self[$0] })
        return StemColorMMCQ.quantize(list, maxColors: maxCount)?.vboxes.map({ $0.average() }) ?? []
    }
    
}

import Foundation
/// MMCQ (modified median cut quantization) algorithm from
/// the Leptonica library (http://www.leptonica.com/).
struct StemColorMMCQ {

    // Use only upper 5 bits of 8 bits
    private static let signalBits = 5
    private static let rightShift = 8 - signalBits
    private static let multiplier = 1 << rightShift
    private static let histogramSize = 1 << (3 * signalBits)
    private static let vboxLength = 1 << signalBits
    private static let fractionByPopulation = 0.75
    private static let maxIterations = 1000

    /// Get reduced-space color index for a pixel.
    ///
    /// - Parameters:
    ///   - red: the red value
    ///   - green: the green value
    ///   - blue: the blue value
    /// - Returns: the color index
    static func makeColorIndex(of unpack: StemColor.RGBSpace.Unpack<Int>) -> Int {
        return (unpack.red << (2 * signalBits)) + (unpack.green << signalBits) + unpack.blue
    }

    /// 3D color space box.
    class VBox {

        var minUnpack: StemColor.RGBSpace.Unpack<UInt8>
        var maxUnpack: StemColor.RGBSpace.Unpack<UInt8>

        private let histogram: [Int]

        private var average: StemColor.RGBSpace.Unpack<UInt8>?
        private var volume: Int?
        private var count: Int?

        init(min: StemColor.RGBSpace.Unpack<UInt8>, max: StemColor.RGBSpace.Unpack<UInt8>, histogram: [Int]) {
            self.minUnpack = min
            self.maxUnpack = max
            self.histogram = histogram
        }

        init(vbox: VBox) {
            self.maxUnpack = vbox.maxUnpack
            self.minUnpack = vbox.minUnpack
            self.histogram = vbox.histogram
        }

        var range: StemColor.RGBSpace.Unpack<CountableRange<Int>> { minUnpack.with(maxUnpack) { min, max in
            if min <= max {
                return Int(min) ..< Int(max + 1)
            } else {
                return Int(max) ..< Int(max)
            }
        } }

        /// Get 3 dimensional volume of the color space
        ///
        /// - Parameter force: force recalculate
        /// - Returns: the volume
        func volume(forceRecalculate force: Bool = false) -> Int {
            if let volume = volume, !force {
                return volume
            } else {
                let volume = maxUnpack.with(minUnpack, { (Int($0) - Int($1) + 1) }).multiplier()
                defer { self.volume = volume }
                return volume
            }
        }

        /// Get total count of histogram samples
        ///
        /// - Parameter force: force recalculate
        /// - Returns: the volume
        func count(forceRecalculate force: Bool = false) -> Int {
            if let count = count, !force {
                return count
            } else {
                var count = 0
                defer { self.count = count }
                for i in range.red {
                    for j in range.green {
                        for k in range.blue {
                            let index = StemColorMMCQ.makeColorIndex(of: .init(red: i, green: j, blue: k))
                            count += histogram[index]
                        }
                    }
                }
                return count
            }
        }

        func average(forceRecalculate force: Bool = false) -> StemColor.RGBSpace.Unpack<UInt8> {
            if let average = average, !force {
                return average
            } else {
                var ntot = 0
                var sum = StemColor.RGBSpace.Unpack<Int>(red: 0, green: 0, blue: 0)
                for i in range.red {
                    for j in range.green {
                        for k in range.blue {
                            let index = StemColorMMCQ.makeColorIndex(of: .init(red: i, green: j, blue: k))
                            let hval = histogram[index]
                            ntot += hval
                            let item = StemColor.RGBSpace.Unpack<Int>(red: i, green: j, blue: k)
                            sum = sum.with(item, { $0 + Int(Double(hval) * (Double($1) + 0.5) * Double(StemColorMMCQ.multiplier)) })
                        }
                    }
                }

                let average: StemColor.RGBSpace.Unpack<UInt8>
                defer { self.average = average }
                
                if ntot > 0 {
                    average = sum.map({ UInt8($0 / ntot) })
                } else {
                   let unpack = minUnpack.with(maxUnpack, { UInt8(min(StemColorMMCQ.multiplier * (Int($0) + Int($1) + 1) / 2, 255)) })
                    average = unpack
                }
                return average
            }
        }

        func widestChannel() -> StemColor.RGBSpace.Channel {
            let width = maxUnpack.with(minUnpack, { $0 - $1 })
            switch width.max() {
            case width.red:   return .red
            case width.green: return .green
            default: return .blue
            }
        }

    }

    /// Color map.
    open class ColorMap {

        var vboxes = [VBox]()

        func push(_ vbox: VBox) {
            vboxes.append(vbox)
        }

        open func palette() -> [StemColor.RGBSpace.Unpack<UInt8>] {
            return vboxes.map { $0.average() }
        }

        open func nearest(to color: StemColor.RGBSpace.Unpack<UInt8>) -> StemColor.RGBSpace.Unpack<UInt8> {
            var nearestDistance = Int.max
            var nearestColor = StemColor.RGBSpace.Unpack<UInt8>.init(red: 0, green: 0, blue: 0)

            for vbox in vboxes {
                let vbColor = vbox.average()
                let distance = color.with(vbColor, { abs(Int($0) - Int($1)) }).sum()
                if distance < nearestDistance {
                    nearestDistance = distance
                    nearestColor = vbColor
                }
            }

            return nearestColor
        }
    }

    /// Histo (1-d array, giving the number of pixels in each quantized region of color space), or null on error.
    private static func makeHistogramAndVBox(from pixels: [StemColor.RGBSpace.Unpack<UInt8>]) -> ([Int], VBox) {
        var histogram = [Int](repeating: 0, count: histogramSize)
        var minUnpack = StemColor.RGBSpace.Unpack<UInt8>(red: .max, green: .max, blue: .max)
        var maxUnpack = StemColor.RGBSpace.Unpack<UInt8>(red: .min, green: .min, blue: .min)

        for pixel in pixels {
            let shifted = pixel.map({ $0 >> UInt8(rightShift) })
                
            minUnpack = shifted.with(minUnpack, min)
            maxUnpack = shifted.with(maxUnpack, max)
            // increment histgram
            let index = StemColorMMCQ.makeColorIndex(of: shifted.map({ Int($0) }))
            histogram[index] += 1
        }

        let vbox = VBox(min: minUnpack, max: maxUnpack, histogram: histogram)
        return (histogram, vbox)
    }

    private static func applyMedianCut(with histogram: [Int], vbox: VBox) -> [VBox] {
        guard vbox.count() != 0 else {
            return []
        }

        // only one pixel, no split
        guard vbox.count() != 1 else {
            return [vbox]
        }

        // Find the partial sum arrays along the selected axis.
        var total = 0
        var partialSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0

        let axis = vbox.widestChannel()
        switch axis {
        case .red:
            for i in vbox.range.red {
                var sum = 0
                for j in vbox.range.green {
                    for k in vbox.range.blue {
                        let index = StemColorMMCQ.makeColorIndex(of: .init(red: i, green: j, blue: k))
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[i] = total
            }
        case .green:
            for i in vbox.range.green {
                var sum = 0
                for j in vbox.range.red {
                    for k in vbox.range.blue {
                        let index = StemColorMMCQ.makeColorIndex(of: .init(red: j, green: i, blue: k))
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[i] = total
            }
        case .blue:
            for i in vbox.range.blue {
                var sum = 0
                for j in vbox.range.red {
                    for k in vbox.range.green {
                        let index = StemColorMMCQ.makeColorIndex(of: .init(red: j, green: k, blue: i))
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[i] = total
            }
        }

        var lookAheadSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0
        for (i, sum) in partialSum.enumerated() where sum != -1 {
            lookAheadSum[i] = total - sum
        }

        return cut(by: axis, vbox: vbox, partialSum: partialSum, lookAheadSum: lookAheadSum, total: total)
    }

    private static func cut(by channel: StemColor.RGBSpace.Channel,
                            vbox: VBox,
                            partialSum: [Int],
                            lookAheadSum: [Int],
                            total: Int) -> [VBox] {
        let vboxMin: Int
        let vboxMax: Int

        switch channel {
        case .red:
            vboxMin = Int(vbox.minUnpack.red)
            vboxMax = Int(vbox.maxUnpack.red)
        case .green:
            vboxMin = Int(vbox.minUnpack.green)
            vboxMax = Int(vbox.maxUnpack.green)
        case .blue:
            vboxMin = Int(vbox.minUnpack.blue)
            vboxMax = Int(vbox.maxUnpack.blue)
        }

        for i in vboxMin ... vboxMax where partialSum[i] > total / 2 {
            let vbox1 = VBox(vbox: vbox)
            let vbox2 = VBox(vbox: vbox)

            let left = i - vboxMin
            let right = vboxMax - i

            var d2: Int
            if left <= right {
                d2 = min(vboxMax - 1, i + right / 2)
            } else {
                // 2.0 and cast to int is necessary to have the same
                // behaviour as in JavaScript
                d2 = max(vboxMin, Int(Double(i - 1) - Double(left) / 2.0))
            }

            // avoid 0-count
            while d2 < 0 || partialSum[d2] <= 0 {
                d2 += 1
            }
            var count2 = lookAheadSum[d2]
            while count2 == 0 && d2 > 0 && partialSum[d2 - 1] > 0 {
                d2 -= 1
                count2 = lookAheadSum[d2]
            }

            // set dimensions
            switch channel {
            case .red:
                vbox1.maxUnpack.red = UInt8(d2)
                vbox2.minUnpack.red = UInt8(d2 + 1)
            case .green:
                vbox1.maxUnpack.green = UInt8(d2)
                vbox2.minUnpack.green = UInt8(d2 + 1)
            case .blue:
                vbox1.maxUnpack.blue = UInt8(d2)
                vbox2.minUnpack.blue = UInt8(d2 + 1)
            }

            return [vbox1, vbox2]
        }

        fatalError("VBox can't be cut")
    }

    static func quantize(_ pixels: [StemColor.RGBSpace.Unpack<UInt8>], maxColors: Int) -> ColorMap? {
        // short-circuit
        guard !pixels.isEmpty, maxColors > 1, maxColors <= 256 else {
            return nil
        }

        // get the histogram and the beginning vbox from the colors
        let (histogram, vbox) = makeHistogramAndVBox(from: pixels)

        // priority queue
        var pq = [vbox]

        // Round up to have the same behaviour as in JavaScript
        let target = Int(ceil(fractionByPopulation * Double(maxColors)))

        // first set of colors, sorted by population
        iterate(over: &pq, comparator: compareByCount, target: target, histogram: histogram)

        // Re-sort by the product of pixel occupancy times the size in color space.
        pq.sort(by: compareByProduct)

        // next set - generate the median cuts using the (npix * vol) sorting.
        iterate(over: &pq, comparator: compareByProduct, target: maxColors - pq.count, histogram: histogram)

        // Reverse to put the highest elements first into the color map
        pq = pq.reversed()

        // calculate the actual colors
        let colorMap = ColorMap()
        pq.forEach { colorMap.push($0) }
        return colorMap
    }

    // Inner function to do the iteration.
    private static func iterate(over queue: inout [VBox], comparator: (VBox, VBox) -> Bool, target: Int, histogram: [Int]) {
        var color = 1

        for _ in 0 ..< maxIterations {
            guard let vbox = queue.last else {
                return
            }

            if vbox.count() == 0 {
                queue.sort(by: comparator)
                continue
            }
            queue.removeLast()

            // do the cut
            let vboxes = applyMedianCut(with: histogram, vbox: vbox)
            queue.append(vboxes[0])
            if vboxes.count == 2 {
                queue.append(vboxes[1])
                color += 1
            }
            queue.sort(by: comparator)

            if color >= target {
                return
            }
        }
    }

    private static func compareByCount(_ a: VBox, _ b: VBox) -> Bool {
        return a.count() < b.count()
    }

    private static func compareByProduct(_ a: VBox, _ b: VBox) -> Bool {
        let aCount = a.count()
        let bCount = b.count()
        let aVolume = a.volume()
        let bVolume = b.volume()

        if aCount == bCount {
            // If count is 0 for both (or the same), sort by volume
            return aVolume < bVolume
        } else {
            // Otherwise sort by products
            let aProduct = Int64(aCount) * Int64(aVolume)
            let bProduct = Int64(bCount) * Int64(bVolume)
            return aProduct < bProduct
        }
    }

}
