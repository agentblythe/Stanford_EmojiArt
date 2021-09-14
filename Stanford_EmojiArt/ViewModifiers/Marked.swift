//
//  Marked.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 14/09/2021.
//

import SwiftUI

struct Marked: ViewModifier {
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        if isSelected {
            content.padding(2).border(Color.red)
        } else {
            content
        }
    }
}

extension View {
    public func marked(isSelected: Bool) -> some View {
        self.modifier(Marked(isSelected: isSelected))
    }
}
