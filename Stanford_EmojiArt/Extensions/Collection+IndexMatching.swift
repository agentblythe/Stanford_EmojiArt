//
//  Collection+IndexMatching.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 03/09/2021.
//

import Foundation

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}
