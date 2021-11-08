import Foundation
import Stem

class SFSymbolsExport {
    
    struct Availability {
        let iOS: String
        let macOS: String
        let tvOS: String
        let watchOS: String
        
        init(dict: [String: String]) {
            self.iOS = dict["iOS"]!
            self.macOS = dict["macOS"]!
            self.tvOS = dict["tvOS"]!
            self.watchOS = dict["watchOS"]!
        }
        
        var code: String { "@available(iOS \(iOS), macOS \(macOS), tvOS \(tvOS), watchOS \(watchOS), *)" }
        
    }
    
    struct SFSymbols {
        let name: String
        let varName: String
        let value: String
        let aliases: String?
        let categories: [String]
        let availability: Availability
        let hierarchical_availability: Availability?
        let multicolor_availability: Availability?
    }
    
    static func run() throws {
        let layerset_availability  = try layerset_availability(filename: "layerset_availability.plist")
        let name_availability      = try availability(filename: "name_availability.plist")
        
        let legacy_aliases_strings = try aliases_strings(filename: "legacy_aliases_strings.txt")
        let name_aliases_strings   = try aliases_strings(filename: "name_aliases_strings.txt")
        
        var categories = [String: [String]]()
        if let url = Bundle.module.url(forResource: "symbol_categories", withExtension: "plist"),
           let dict = NSDictionary(contentsOfFile: url.path) as? [String: [String]] {
            categories = dict
        }
        
        let symbols = name_availability.map { (name, availability) in
            SFSymbols(name: legacy_aliases_strings[name] ?? name,
                      varName: varName(name: name),
                      value: "",
                      aliases: name_aliases_strings[name],
                      categories: categories[name] ?? [],
                      availability: availability,
                      hierarchical_availability: layerset_availability[name]?["hierarchical"],
                      multicolor_availability: layerset_availability[name]?["multicolor"])
        }.dictionary(key: \.name, value: \.self)
        
        
        let cases = symbols.values.sorted(by: { $0.name < $1.name }).map { symbol in
            """
            \(symbol.availability.code)
            case \(symbol.varName) = "\(symbol.name)"
            """
        }.joined(separator: "\n")
        
        
        print(cases)
    }
    
}


private extension SFSymbolsExport {
    
    /// 驼峰
    static func camelCased(_ strs: [String]) -> String {
        return strs
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }
    
    static func varName(name: String) -> String {
        let camelCased = camelCased(name.split(separator: ".").map(\.description))
        if camelCased.first!.isNumber {
            return "_" + camelCased
        } else {
            return camelCased
        }
    }
    
    static func aliases_strings(filename: String) throws -> [String: String] {
        guard let url = Bundle.module.url(forResource: filename, withExtension: nil) else {
            return [:]
        }
        
        return try String(contentsOfFile: url.path)
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: ";", with: "")
            .replacingOccurrences(of: " ", with: "")
            .split(separator: "\n")
            .map { string in
                string
                    .split(separator: "=")
                    .map(String.init)
            }.dictionary { item in
                item.first
            } value: { item in
                item.last
            }
    }
    
    static func availability(filename: String) throws -> [String: Availability] {
        guard let url = Bundle.module.url(forResource: filename, withExtension: nil),
              let dict = NSDictionary(contentsOfFile: url.path) as? [String: Any],
              let symbolsMap = dict["symbols"] as? [String: String],
              let year_to_release = dict["year_to_release"] as? [String: [String: String]] else {
                  return [:]
              }
        
        let releases = year_to_release.mapValues(Availability.init(dict:))
        
        return symbolsMap.mapValues { key in
            return releases[key]!
        }
    }
    
    static func layerset_availability(filename: String) throws -> [String: [String: Availability]] {
        guard let url = Bundle.module.url(forResource: filename, withExtension: nil),
              let dict = NSDictionary(contentsOfFile: url.path) as? [String: Any],
              let symbolsMap = dict["symbols"] as? [String: [String: String]],
              let year_to_release = dict["year_to_release"] as? [String: [String: String]] else {
                  return [:]
              }
        
        let releases = year_to_release.mapValues(Availability.init(dict:))
        
        return symbolsMap.mapValues { item in
            return item.mapValues { key in
                return releases[key]!
            }
        }
    }
    
}
