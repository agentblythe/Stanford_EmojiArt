//
//  Character+IsEmoji.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 04/09/2021.
//

import Foundation

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
