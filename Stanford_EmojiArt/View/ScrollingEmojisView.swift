//
//  ScrollingEmojisView.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 04/09/2021.
//

import SwiftUI

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag({ NSItemProvider(object: emoji as NSString) })
                }
            }
        }
    }
}

struct ScrollingEmojisView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingEmojisView(emojis: EmojiArtDocumentView.testEmojis)
    }
}
