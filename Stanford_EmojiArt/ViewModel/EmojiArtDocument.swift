//
//  EmojiArtDocument.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 02/09/2021.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private var emojiArt: EmojiArt
    
    init() {
        emojiArt = EmojiArt()
    }
    
    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }
    
    var background: EmojiArt.Background {
        emojiArt.background
    }
    
    // MARK: Intents
    
    func setBackground(_ background: EmojiArt.Background) {
        emojiArt.setBackground(background)
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        let newX = emoji.x + Int(offset.width)
        let newY = emoji.y + Int(offset.height)
        emojiArt.moveEmoji(emoji, to: (newX, newY))
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        emojiArt.scaleEmoji(emoji, by: Int(scale.rounded(.toNearestOrAwayFromZero)))
    }
}
