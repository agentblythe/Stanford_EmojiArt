//
//  Background.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 02/09/2021.
//

import Foundation

extension EmojiArt {
    
    enum Background: Equatable, Codable {
        case blank
        case url(URL)
        case imageData(Data)
        
        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }
        
        var imageData: Data? {
            switch self {
            case.imageData(let data): return data
            default: return nil
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let url = try? container.decode(URL.self, forKey: .url) {
                self = .url(url)
            } else if let imageData = try? container.decode(Data.self, forKey: .imageData) {
                self = .imageData(imageData)
            } else {
                self = .blank
            } 
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .url(let url):
                try container.encode(url, forKey: .url)
            case .imageData(let data):
                try container.encode(data, forKey: .imageData)
            case.blank:
                break
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case url = "theURL"
            case imageData
        }
    }
}
