//
//  ContentView.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 01/09/2021.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State var longTappedEmoji: EmojiArt.Emoji? = nil
    
    @State var alertToShow: IdentifiableAlert?
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser(emojiFontSize: FontConstants.defaultEmojiFontSize)
        }
    }
    
    /// A Set containing the emojis that have been selected on the document
    @State private var selectedEmojis: Set<EmojiArt.Emoji> = []
    
    @ViewBuilder
    var background: some View {
        OptionalImage(uiImage: document.backgroundImage)
    }

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.overlay(
                    background
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0, 0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size).exclusively(before: singleTap(in: geometry.size)))
                
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView()
                        .scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .animatableFont(size: fontSize(for: emoji))
                            .marked(isSelected: selectedEmojis.contains(matching: emoji))
                            .gesture(dragEmojiGesture(for: emoji))
                            .position(position(for: emoji, in: geometry))
                            .onTapGesture {
                                selectedEmojis.toggleInclusion(of: emoji)
                            }
                            .gesture(deleteEmojiGesture(on: emoji))

                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil, perform: { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            })
            .gesture(panGesture().simultaneously(with: zoomGesture()))
            .alert(item: $alertToShow) { alertToShow in
                alertToShow.alert()
            }
            .onChange(of: document.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    showBackgroundImageFetchAlert(url)
                default:
                    break
                }
            }
        }
    }
    
    private func showConfirmEmojiDeletionAlert() {
        alertToShow = nil
        alertToShow = IdentifiableAlert(id: "Confirm Deletion of Emoji", alert: {
            Alert(title: Text("Delete Emoji?"),
                  message: Text("Are you sure you want to delete this emoji \(longTappedEmoji?.text ?? "")?"),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text("Delete")) {
                if let emoji = longTappedEmoji {
                    document.deleteEmoji(emoji)
                }
            })
        })
    }
    
    private func showBackgroundImageFetchAlert(_ url: URL) {
        alertToShow = IdentifiableAlert(id: "Fetch Failed: " + url.absoluteString, alert: {
            Alert(title: Text("Background Image Fetch"), message: Text("Coudln't load image from \(url)"), dismissButton: .default(Text("OK")))
        })
    }
    
    ///
    private func handleTap(on emoji: EmojiArt.Emoji) {
        selectedEmojis.toggleInclusion(of: emoji)
    }
    
    ///
    /// Gestures
    ///
    
    /// Gesture for handling single tapping on the background
    ///
    private func singleTap(in size: CGSize) -> some Gesture {
        return TapGesture(count: 1)
            .onEnded {
                selectedEmojis.removeAll()
            }
    }
    
    /// Gesture for handling deletion of an emoji
    ///
    private func deleteEmojiGesture(on emoji: EmojiArt.Emoji) -> some Gesture {
        return LongPressGesture()
            .onEnded {_ in
                longTappedEmoji = emoji
                showConfirmEmojiDeletionAlert()
            }
    }
    
    /// Gestures for handling zooming
    ///
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    @GestureState private var gestureEmojiZoomScale: CGFloat = 1
    
    @State var steadyStateZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        return steadyStateZoomScale * gestureZoomScale
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        return TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomGesture() -> some Gesture {
        if !selectedEmojis.isEmpty {
            return MagnificationGesture()
                .updating($gestureEmojiZoomScale) { latestGestureScale, gestureEmojiZoomScale, _ in
                    gestureEmojiZoomScale = latestGestureScale
                    selectedEmojis.forEach { emoji in
                        document.scaleEmoji(emoji, by: gestureEmojiZoomScale)
                    }
                }
                .onEnded { gestureScaleAtEnd in
                    selectedEmojis.forEach { emoji in
                        document.scaleEmoji(emoji, by: gestureScaleAtEnd)
                    }
                }
        }
        
        return MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image,
               image.size.width > 0,
               image.size.height > 0,
               size.width > 0,
               size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    /// Gesture for handling dragging or panning on the background
    ///
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    @State var steadyStatePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        return DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    /// Gesture for selecting an emoji in the document
    ///
    private func selectEmojiGesture(_ emoji: EmojiArt.Emoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                selectedEmojis.toggleInclusion(of: emoji)
            }
    }
    
    /// Gesture for handling dragging of emojis on the document
    ///
    @GestureState private var gestureDragOffset: CGSize = CGSize.zero
    
    private func dragEmojiGesture(for tappedEmoji: EmojiArt.Emoji) -> some Gesture {
        
        let isSelected = selectedEmojis.contains(matching: tappedEmoji)
        
        return DragGesture()
            .updating($gestureDragOffset) { latestDragGestureValue, gestureDragOffset, _ in
                
                gestureDragOffset = latestDragGestureValue.translation / zoomScale
                
                if isSelected {
                    for emoji in selectedEmojis {
                        document.moveEmoji(emoji, by: gestureDragOffset)
                    }
                } else {
                    document.moveEmoji(tappedEmoji, by: gestureDragOffset)
                }
    
            }
            .onEnded { finalDragGestureValue in
                print(selectedEmojis.count)
                let draggedOffset = finalDragGestureValue.translation / zoomScale

                if isSelected {
                    for emoji in selectedEmojis {
                        document.moveEmoji(emoji, by: gestureDragOffset)
                    }
                } else {
                    document.moveEmoji(tappedEmoji, by: draggedOffset)
                }
            }
    }
    
    /// Function to handle the dropping of images (data), urls (of images) or strings (emojis) onto the background
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        
        /// URL
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        
        /// Data
        if !found {
            found = providers.loadObjects(ofType: UIImage.self, using: { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            })
        }
        
        /// String
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(String(emoji), at: convertToEmojiCoordinates(location, in: geometry), size: FontConstants.defaultEmojiFontSize / steadyStateZoomScale)
                }
            }
        }
        
        return found
    }
    
    ///
    private func fontSize(for emoji: EmojiArt.Emoji) -> CGFloat {
        let originalSize = CGFloat(emoji.size) * zoomScale
        if selectedEmojis.contains(emoji) {
            return originalSize * gestureZoomScale
        }
        return originalSize
    }
    
    ///
    private func position(for emoji: EmojiArt.Emoji, in geometry: GeometryProxy) -> CGPoint {
        return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    /// Emoji objects have their locations saved as x's and y's which represent offset from the centre, e.g. an emoji with location (100,100) means it will be positioned at (centre x + 100, centre y + 100).  This is the value we are retrieving here
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).centre
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    /// This function takes a location in the parent view and returns the location tuple of emoji
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).centre
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        
        return (Int(location.x), Int(location.y))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
