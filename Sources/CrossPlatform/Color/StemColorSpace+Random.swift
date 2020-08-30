//
//  StemColorSpace+Range.swift
//  Stem
//
//  Created by 林翰 on 2020/8/30.
//

import Foundation

public protocol StemColorSpaceRandom {
    
    static var random: Self { get }
    
}

public extension StemColor {
    
    static var random: StemColor { .init(rgb: .random, alpha: 1) }
    
}

extension StemColor.RGBSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.HSBSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.HSLSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.XYZSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.LABSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.CMYSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

extension StemColor.CMYKSpace {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}

