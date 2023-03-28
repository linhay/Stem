//
//  File.swift
//  
//
//  Created by linhey on 2023/3/17.
//

#if canImport(UIKit)
import UIKit

public struct STKeyCommandKey: RawRepresentable, ExpressibleByStringLiteral, Equatable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
    
}

public extension STKeyCommandKey {
    static let inputUpArrow    = STKeyCommandKey(rawValue: UIKeyCommand.inputUpArrow)
    static let inputDownArrow  = STKeyCommandKey(rawValue: UIKeyCommand.inputDownArrow)
    static let inputLeftArrow  = STKeyCommandKey(rawValue: UIKeyCommand.inputLeftArrow)
    static let inputRightArrow = STKeyCommandKey(rawValue: UIKeyCommand.inputRightArrow)
    static let inputEscape     = STKeyCommandKey(rawValue: UIKeyCommand.inputEscape)
    static let inputPageUp     = STKeyCommandKey(rawValue: UIKeyCommand.inputPageUp)
    static let inputPageDown   = STKeyCommandKey(rawValue: UIKeyCommand.inputPageDown)
    static let inputHome       = STKeyCommandKey(rawValue: "UIKeyInputHome")
    static let inputEnd        = STKeyCommandKey(rawValue: "UIKeyInputEnd")
    static let inputDelete     = STKeyCommandKey(rawValue: "\u{08}")
    static let enter           = STKeyCommandKey(rawValue: "\r")
    static let f1  = STKeyCommandKey(rawValue: "UIKeyInputF1")
    static let f2  = STKeyCommandKey(rawValue: "UIKeyInputF2")
    static let f3  = STKeyCommandKey(rawValue: "UIKeyInputF3")
    static let f4  = STKeyCommandKey(rawValue: "UIKeyInputF4")
    static let f5  = STKeyCommandKey(rawValue: "UIKeyInputF5")
    static let f6  = STKeyCommandKey(rawValue: "UIKeyInputF6")
    static let f7  = STKeyCommandKey(rawValue: "UIKeyInputF7")
    static let f8  = STKeyCommandKey(rawValue: "UIKeyInputF8")
    static let f9  = STKeyCommandKey(rawValue: "UIKeyInputF9")
    static let f10 = STKeyCommandKey(rawValue: "UIKeyInputF10")
    static let f11 = STKeyCommandKey(rawValue: "UIKeyInputF11")
    static let f12 = STKeyCommandKey(rawValue: "UIKeyInputF12")
    static let c = STKeyCommandKey(rawValue: "c")
    static let v = STKeyCommandKey(rawValue: "v")
}

public extension Stem where Base: UIKeyCommand {
    
    @MainActor
    static func command(title: String = "",
                        image: UIImage? = nil,
                        action: Selector,
                        input: STKeyCommandKey,
                        modifierFlags: UIKeyModifierFlags = [],
                        propertyList: Any? = nil,
                        alternates: [UICommandAlternate] = [],
                        discoverabilityTitle: String? = nil,
                        attributes: UIMenuElement.Attributes = [],
                        state: UIMenuElement.State = .off) -> UIKeyCommand {
        
        let command = UIKeyCommand(title: title,
                                   image: image,
                                   action: action,
                                   input: input.rawValue,
                                   modifierFlags: modifierFlags,
                                   propertyList: propertyList,
                                   alternates: alternates,
                                   discoverabilityTitle: discoverabilityTitle,
                                   attributes: attributes,
                                   state: state)
        
        if #available(iOS 15.0, *) {
            command.wantsPriorityOverSystemBehavior = true
        } else if #available(macCatalyst 15.0, *) {
            if #available(iOS 15.0, *) {
                command.wantsPriorityOverSystemBehavior = true
            }
        } else {
            // Fallback on earlier versions
        }
        return command
    }
    
    
}

#endif
