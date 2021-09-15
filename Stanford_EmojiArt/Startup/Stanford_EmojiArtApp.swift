//
//  Stanford_EmojiArtApp.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 01/09/2021.
//

import SwiftUI

@main
struct Stanford_EmojiArtApp: App {
    /// Initialise the View Model which will be passed by Constructor Injection into the View
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
