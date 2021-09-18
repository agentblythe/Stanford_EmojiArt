//
//  EmojiArt.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 01/09/2021.
//

import Foundation

struct EmojiArt {
    private(set) var background = Background.blank
    private(set) var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable { //}, Equatable {
        let text: String
        var x: Int // Offset from centre
        var y: Int // Offset from centre
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
//
//        static func ==(lhs: Emoji, rhs: Emoji) -> Bool {
//            return lhs.id == rhs.id
//        }
    }
    
    init() { }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
    
    mutating func setBackground(_ background: Background) {
        self.background = background
    }
    
    mutating func moveEmoji(_ emoji: Emoji, by offset: (width: Int, height: Int)) {
        if let index = emojis.index(matching: emoji) {
            emojis[index].x += offset.width
            emojis[index].y += offset.height
        }
    }
    
    mutating func deleteEmoji(_ emoji: Emoji) {
        if let index = emojis.index(matching: emoji) {
            emojis.remove(at: index)
        }
    }
    
    mutating func scaleEmoji(_ emoji: Emoji, by scale: Int) {
        if let index = emojis.index(matching: emoji) {
            emojis[index].size *= scale
        }
    }
}
