//
//  Set.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 14/09/2021.
//

import Foundation

extension Set where Element: Identifiable {
    mutating func toggle(matching element: Element) {
        if self.contains(element) {
            self.remove(element)
        } else {
            self.insert(element)
        }
    }
}
