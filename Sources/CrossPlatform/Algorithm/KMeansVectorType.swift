//
//  File.swift
//  
//
//  Created by linhey on 2021/11/18.
//

import Foundation

// Represents a type that can be clustered using the k-means clustering
// algorithm.
public protocol KMeansVectorType {
    // Used to compute average values to determine the cluster centroids.
    static func +(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Int) -> Self
    
    // Identity value such that x + identity = x. Typically the 0 vector.
    static var identity: Self { get }
}

extension SIMD3: KMeansVectorType where Scalar == Double {
    
    public static func / (lhs: SIMD3<Scalar>, rhs: Int) -> SIMD3<Scalar> {
        return lhs / Double(rhs)
    }
    
    public static var identity: SIMD3<Scalar> {
        .zero
    }
    
}
