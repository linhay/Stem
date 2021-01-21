//
//  RunTime+Print.swift
//  Stem
//
//  Created by 林翰 on 2021/1/21.
//

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
        title = title + [String](repeating: " ", count: count - title.count).joined()
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
            return [String(cString: ivar)]
        })
        log(title: "ivars", list: list)
    }
    
}
#endif

