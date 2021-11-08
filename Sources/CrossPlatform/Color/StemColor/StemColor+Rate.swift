// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public extension Array where Element == StemColor {
    
    struct Result {
        public let color: StemColor
        public let rate: Double
    }
    
    /// k-均值算法
    /// - Parameters:
    ///   - count: 中心点数量
    ///   - convergeDistance: 收敛距离
    /// - Returns: 聚类颜色与比例
    func kmeansClusterAnalysis(count: Int, convergeDistance: Double = 1) -> [Result] {
        let datas = self.map(\.labSpace.compressionValues).map { item in
            item.map({ $0.st.roundedDecimal(scale: 4) })
        }
        let vectors = datas.map { data in
            Vector(data) { lhs, rhs in
                StemColor.differenceCIEDE2000(.init(lhs.data), .init(rhs.data))
            }
        }
        
        let kmeans = KMeans<Int>(labels: (0...count-1).map({ $0 }))
        kmeans.trainCenters(vectors, convergeDistance: convergeDistance)
        
        var counts = [Int: Int]()
        for label in kmeans.fit(vectors) {
            if counts[label] == nil {
                counts[label] = 1
            } else {
                counts[label] = counts[label]! + 1
            }
        }
        
        var models = [Result]()
        for (label, centroid) in zip(kmeans.labels, kmeans.centroids) {
            let space = StemColor.CIELABSpace(StemColor.CIELABSpace.resetValues(centroid.data))
            print(space.list)
            let color = StemColor(lab: space)
            let rate  = Double(counts[label] ?? 0) / Double(vectors.count)
            models.append(.init(color: color, rate: rate))
        }
        
        return models.sorted(by: { $0.rate > $1.rate })
    }
    
}
