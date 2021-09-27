//
//  AnimatableSystemFontModifier.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 27/09/2021.
//

import SwiftUI

struct AnimatableSystemFontModifier: AnimatableModifier {
    var size: CGFloat = 0
    
    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    func animatableFont(size: CGFloat) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size))
    }
}

