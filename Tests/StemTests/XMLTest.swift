//
//  File.swift
//  
//
//  Created by linhey on 2022/10/8.
//

import Foundation
import Stem
import XCTest

class XMLTest: XCTestCase {
    
    struct Podcast {
        
        struct Enclosure {
            let url: URL?
            let type: String
            let length: Int
            
            init(ximalaya xml: StemXML.Item) {
                url = (xml.attributes["url"] ?? "").flatMap(URL.init(string:))
                type = xml.attributes["type"] ?? ""
                length = Int(xml.attributes["length"] ?? "") ?? 0
            }
        }
        
        struct Itunes {
            let title: String
            let image: URL?
            let duration: Int
            let episode: Int
            let explicit: Bool
            let season: Int
            let episodeType: String
            
            init(ximalaya xml: StemXML.Item) {
                self.title = xml["title"].stringValue
                self.image = xml["image"].attributes["href"].flatMap(URL.init(string:))
                self.duration = xml["duration"].intValue
                self.episode = xml["episode"].intValue
                self.explicit = xml["explicit"].boolValue
                self.season = xml["season"].intValue
                self.episodeType = xml["episodeType"].stringValue
            }
            
        }
        
        let title: String
        let description: String
        let link: String
        let guid: String
        let pubDate: Date
        let itunes: Itunes
        let enclosure: Enclosure

       private static let pubDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            return formatter
        }()
        
        init(ximalaya xml: StemXML.Item) {
            self.title = xml["title"].stringValue
            self.description = xml["description"].stringValue
            self.link = xml["link"].stringValue
            self.guid = xml["guid"].stringValue
            self.pubDate = Self.pubDateFormatter.date(from: xml["pubDate"].stringValue) ?? .distantPast
            self.itunes = .init(ximalaya: xml.collection(prefix: "itunes"))
            self.enclosure = .init(ximalaya: xml["enclosure"])
        }
    }
    
    func test() {
        guard let xml = StemXML(contentsOf: "https://www.ximalaya.com/album/3558668.xml")?.parse() else {
            return
        }
        let itunes = xml["channel"].collection(prefix: "itunes")
        xml["channel"].collection(by: "item").forEach { item in
            let podcast = Podcast(ximalaya: item)
            print(podcast)
        }
    }
    
}
