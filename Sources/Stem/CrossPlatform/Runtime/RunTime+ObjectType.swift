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

public extension RunTime {
    
//    Type encoding characters
//    #define _C_ID          '@'
//    #define _C_CLASS       '#'
//    #define _C_SEL         ':'
//    #define _C_CHR         'c'
//    #define _C_UCHR        'C'
//    #define _C_SHT         's'
//    #define _C_USHT        'S'
//    #define _C_INT         'i'
//    #define _C_UINT        'I'
//    #define _C_LNG         'l'
//    #define _C_ULNG        'L'
//    #define _C_LNG_LNG     'q'
//    #define _C_ULNG_LNG    'Q'
//    #define _C_INT128      't'
//    #define _C_UINT128     'T'
//    #define _C_FLT         'f'
//    #define _C_DBL         'd'
//    #define _C_LNG_DBL     'D'
//    #define _C_BFLD        'b'
//    #define _C_BOOL        'B'
//    #define _C_VOID        'v'
//    #define _C_UNDEF       '?'
//    #define _C_PTR         '^'
//    #define _C_CHARPTR     '*'
//    #define _C_ATOM        '%'
//    #define _C_ARY_B       '['
//    #define _C_ARY_E       ']'
//    #define _C_UNION_B     '('
//    #define _C_UNION_E     ')'
//    #define _C_STRUCT_B    '{'
//    #define _C_STRUCT_E    '}'
//    #define _C_VECTOR      '!'
//
//    // Modifiers
//    #define _C_COMPLEX     'j'
//    #define _C_ATOMIC      'A'
//    #define _C_CONST       'r'
//    #define _C_IN          'n'
//    #define _C_INOUT       'N'
//    #define _C_OUT         'o'
//    #define _C_BYCOPY      'O'
//    #define _C_BYREF       'R'
//    #define _C_ONEWAY      'V'
//    #define _C_GNUREGISTER '+'
    
    enum ObjectType: CustomStringConvertible {
        case `protocol`
        //char      c
        case char
        //short     s
        case short
        //long      l
        case long
        //float     f
        case float
        //class     #
        case `class`
        //unsigned char    C
        case unsignedChar
        //unsigned int     I
        case unsignedInt
        //unsigned short   S
        case unsignedShort
        //unsigned long    L
        case unsignedLong
        //unsigned short   Q
        case unsignedLongLong
        
        // void类型   v
        case void
        //selector  :
        case selector
        //对象类型   "@"
        case object(String)
        case block
        //double类型 d
        case double
        //int类型    i
        case int
        //C++中的bool或者C99中的_Bool B
        case bool
        //long long类型 q
        case longlong
        //  ^
        case point
        case unknown

        //  case char*    = "*" //char*     *
        //  case array    =     //[array type]
        //  case `struct` =     //{name=type…}
        //  case union    =     //(name=type…)
        //  case bnum     =     //A bit field of num bits
        
        init(char: UnsafePointer<CChar>?) {
            guard let char = char, let str = String(utf8String: char) else {
                self = .unknown
                return
            }            
            switch str {
            case "Q": self = .unsignedLongLong
            case "L": self = .unsignedLong
            case "S": self = .unsignedShort
            case "I": self = .unsignedInt
            case "C": self = .unsignedChar
            case "#": self = .`class`
            case "f": self = .float
            case "l": self = .long
            case "s": self = .short
            case "c": self = .char
            case "^": self = .point
            case "q": self = .longlong
            case "B": self = .bool
            case "i": self = .int
            case "d": self = .double
            case "@?": self = .block
            case ":": self = .selector
            case "v": self = .void
            default:
                if str.hasPrefix("{?=") {
                    self = .protocol
                } else if str.hasPrefix("@") {
                    self = .object(str.replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "\"", with: ""))
                } else {
                    self = .unknown
                }
            }
        }
        
        public var description: String {
            switch self {
            case .protocol:
                return "protocol"
            case .void:
                return "Void"
            case .selector:
                return "Selector"
            case .object(let value):
                return value
            case .block:
                return "Block"
            case .double:
                return "Bouble"
            case .int:
                return "Int"
            case .bool:
                return "Bool"
            case .longlong:
                return "longlong"
            case .point:
                return "point"
            case .unknown:
                return "unknown"
            case .char:
                return "char"
            case .short:
                return "short"
            case .long:
                return "long"
            case .float:
                return "float"
            case .class:
                return "class"
            case .unsignedChar:
                return "unsignedChar"
            case .unsignedInt:
                return "unsignedInt"
            case .unsignedShort:
                return "unsignedShort"
            case .unsignedLong:
                return "unsignedLong"
            case .unsignedLongLong:
                return "unsignedLongLong"
            }
        }
    }
    
}
