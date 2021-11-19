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

public class KMeans<T: KMeansVectorType> {
    
    public struct Result {
        public let center: T
        public let size: Int
    }
    
    let points: [T]
    
    public init(_ points: [T]) {
        self.points = points
    }
    
    public func train(k: Int, distance: ((T, T) -> Double), threshold: Double = 0.0001) -> [Result] {
        
        var centroids = centerSeeds(points: points, k: k)
        var memberships  = [Int](repeating: -1, count: points.count)
        var clusterSizes = [Int](repeating: 0, count: k)
        
        var error: Double = 0
        var previousError: Double = 0
        
        repeat {
            error = 0
            var newCentroids = [T](repeating: T.identity, count: k)
            var newClusterSizes = [Int](repeating: 0, count: k)
            
            for i in 0..<memberships.count {
                let point = points[i]
                let clusterIndex = nearest(point: point, centers: centroids, distance: distance)
                if memberships[i] != clusterIndex {
                    error += 1
                    memberships[i] = clusterIndex
                }
                newClusterSizes[clusterIndex] += 1
                newCentroids[clusterIndex] = newCentroids[clusterIndex] + point
            }
            for i in 0..<k {
                let size = newClusterSizes[i]
                if size > 0 {
                    centroids[i] = newCentroids[i] / size
                }
            }
            
            clusterSizes = newClusterSizes
            previousError = error
        } while abs(error - previousError) > threshold
        
        return zip(centroids, clusterSizes).map { Result(center: $0, size: $1) }
    }
    
    private func nearest(point: T, centers: [T], distance: (T, T) -> Double) -> Int {
        var minDistance = Double.infinity
        var clusterIndex = 0
        
        for item in centers.enumerated() {
            let distance = distance(point, item.element)
            if distance < minDistance {
                minDistance = distance
                clusterIndex = item.offset
            }
        }
        return clusterIndex
    }
    
    private func centerSeeds(points: [T], k: Int) -> [T] {
        return (1...k).compactMap({ _ in points.randomElement() })
    }
    
}
