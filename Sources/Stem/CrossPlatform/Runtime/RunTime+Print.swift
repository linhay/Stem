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

#if DEBUG
import Foundation

public extension RunTime {
    
    struct Print { }
    
    static let print = Print()
    
}

public extension RunTime.Print {
    
    func log(title: String, list: [[String]]) {
        var reList = [[String]](repeating: [String](repeating: "", count: list.count), count: list.first?.count ?? 0)
        for x in 0..<list.count {
            for y in 0..<list[x].count {
                reList[y][x] = list[x][y]
            }
        }
        
        let maxs = reList.map({ $0.map({ $0.count }) }).map({ $0.max()! })
        
        let strs = list.map { (line) -> String in
            return "|  " + line.enumerated().map({ (element) -> String in
                return element.element + [String](repeating: " ", count: max(maxs[element.offset] - element.element.count, 0)).joined()
            }).joined(separator: "|") + "  |"
        }
        
        let count = (strs.first?.count ?? 10) - 2
        debugPrint("+\([String](repeating: "-", count: count).joined())+")
        var title = [String](repeating: " ", count: (count - title.count) / 2).joined() + title
        title = title + [String](repeating: " ", count: max(count - title.count, 0)).joined()
        debugPrint("|\(title)|")
        debugPrint("+\([String](repeating: "-", count: count).joined())+")
        
        strs.forEach { (str) in
            debugPrint(str)
        }
        debugPrint("+\([String](repeating: "-", count: count).joined())+")
    }
    
    func methods(from classType: AnyClass) {
        let list = RunTime.methods(from: classType).map({ [method_getName($0).description] })
        log(title: "methods", list: list)
    }
    
    func properties(from classType: AnyClass) {
        let list = RunTime.properties(from: classType).compactMap({ [String(cString: property_getName($0))] })
        log(title: "properties", list: list)
    }
    
    func protocols(from classType: AnyClass) {
        let list = RunTime.protocols(from: classType).map({ [String(cString: protocol_getName($0))] })
        log(title: "protocols", list: list)
    }
    
    func ivars(from classType: AnyClass) {
        let list = RunTime.ivars(from: classType).compactMap({ (item) -> [String]? in
            guard let ivar = ivar_getName(item) else { return nil }
            return [String(cString: ivar), RunTime.ObjectType(char: ivar_getTypeEncoding(item)).description]
        })
        log(title: "ivars", list: list)
    }
    
}
#endif

