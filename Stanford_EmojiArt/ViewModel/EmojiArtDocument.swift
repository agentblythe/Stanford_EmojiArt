//
//  EmojiArtDocument.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 02/09/2021.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private var emojiArt: EmojiArt {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        /// Check that the background that is returned is equal to the one that the model holds, otherwise we'll just ignore it as the user does not want this background image anymore, perhaps the first one took ages to load so they chose another one for example
                        self?.backgroundImageFetchStatus = .idle
                        if self?.emojiArt.background == EmojiArt.Background.url(url) {
                            self?.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
            
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        
        case .blank:
            break
        }
    }
    
    init() {
        emojiArt = EmojiArt()
    }
    
    ///
    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }
    
    ///
    var background: EmojiArt.Background {
        emojiArt.background
    }
    
    ///
    @Published var backgroundImage: UIImage?
    
    ///
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    // MARK: Intents
    
    ///
    func setBackground(_ background: EmojiArt.Background) {
        emojiArt.setBackground(background)
    }
    
    ///
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    ///
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        let width = Int(offset.width)
        let height = Int(offset.height)
        emojiArt.moveEmoji(emoji, by: (width, height))
    }
    
    ///
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            //print(emojiArt.emojis[index].size)
            
            let scaledSize = CGFloat(emojiArt.emojis[index].size) * scale
            let roundedScaledSize = scaledSize.rounded(.toNearestOrAwayFromZero)
            let newSize = Int(roundedScaledSize)
            emojiArt.emojis[index].size = newSize
            
//            emojiArt.emojis[index].size =
//                Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            //print(emojiArt.emojis[index].size)
        }
    }
    
    ///
    func deleteEmoji(_ emoji: EmojiArt.Emoji) {
        emojiArt.deleteEmoji(emoji)
    }
}
