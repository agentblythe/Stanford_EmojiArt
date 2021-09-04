//
//  Background.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 02/09/2021.
//

import Foundation

extension EmojiArt {
    
    enum Background {
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
    }
}
