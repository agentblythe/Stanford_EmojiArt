//
//  ContentView.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 01/09/2021.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: fontSize(for: emoji)))
                        .position(position(for: emoji, in: geometry))
                }
            }
            .onDrop(of: [.plainText], isTargeted: nil, perform: { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            })
        }
    }
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) { string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(String(emoji), at: convertToEmojiCoordinates(location, in: geometry), size: defaultEmojiFontSize)
            }
        }
    }
    
    private func fontSize(for emoji: EmojiArt.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in geometry: GeometryProxy) -> CGPoint {
        return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    /// Emoji objects have their locations saved as x's and y's which represent offset from the centre, e.g. an emoji with location (100,100) means it will be positioned at (centre x + 100, centre y + 100).  This is the value we are retrieving here
    private func convertFromEmojiCoordinates(_ emojiLocation: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let centre = geometry.frame(in: .local).centre
        return CGPoint(x: centre.x + CGFloat(emojiLocation.x), y: centre.y + CGFloat(emojiLocation.y))
    }
    
    /// This function takes a location in the parent view and returns the location tuple of emoji
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let centre = geometry.frame(in: .local).centre
        let location = CGPoint(
            x: location.x - centre.x,
            y: location.y - centre.y
        )
        return (Int(location.x), Int(location.y))
    }
    
    let testEmojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐵🐔🐒🦆🦅🦉🦇🐝🪱🐛🦋🐌🐞🐜🪰🐢🐙🕷"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
