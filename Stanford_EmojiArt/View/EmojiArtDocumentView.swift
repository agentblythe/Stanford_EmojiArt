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
    
    ///
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.overlay(
                    // Replace with AsyncImage
                    // in Xcode 13
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0, 0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size))
                
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView()
                        .scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil, perform: { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            })
            .gesture(zoomGesture())
        }
    }
    
    ///
    var palette: some View {
        ScrollingEmojisView(emojis: Self.testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    ///
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        return TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    @State var steadyStateZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        return steadyStateZoomScale * gestureZoomScale
    }
    
    ///
    private func zoomGesture() -> some Gesture {
        return MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    ///
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        
        // URL
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        
        // Data
        if !found {
            found = providers.loadObjects(ofType: UIImage.self, using: { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            })
        }
        
        // String
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(String(emoji), at: convertToEmojiCoordinates(location, in: geometry), size: defaultEmojiFontSize / steadyStateZoomScale)
                }
            }
        }
        
        return found
    }
    
    ///
    private func fontSize(for emoji: EmojiArt.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    ///
    private func position(for emoji: EmojiArt.Emoji, in geometry: GeometryProxy) -> CGPoint {
        return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    /// Emoji objects have their locations saved as x's and y's which represent offset from the centre, e.g. an emoji with location (100,100) means it will be positioned at (centre x + 100, centre y + 100).  This is the value we are retrieving here
    private func convertFromEmojiCoordinates(_ emojiLocation: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let centre = geometry.frame(in: .local).centre
        return CGPoint(x: centre.x + CGFloat(emojiLocation.x) * zoomScale, y: centre.y + CGFloat(emojiLocation.y) * zoomScale)
    }
    
    /// This function takes a location in the parent view and returns the location tuple of emoji
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let centre = geometry.frame(in: .local).centre
        let location = CGPoint(
            x: (location.x - centre.x) / zoomScale,
            y: (location.y - centre.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    ///
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image,
               image.size.width > 0,
               image.size.height > 0,
               size.width > 0,
               size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    static let testEmojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐵🐔🐒🦆🦅🦉🦇🐝🪱🐛🦋🐌🐞🐜🪰🐢🐙🕷"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
