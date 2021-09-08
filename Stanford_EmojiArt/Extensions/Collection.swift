//
//  Collection+IndexMatching.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 03/09/2021.
//

import Foundation

extension Collection where Element: Identifiable {
    /// In a Collection of Identifiables we often might want to find the element that has the same id as an Identifiable we already have in hand we name this index(matching:) instead of firstIndex(matching:) because we assume that someone creating a Collection of Identifiable is usually going to have only one of each Identifiable thing in there (though there's nothing to restrict them from doing so; it's just a naming choice)
    func index(matching element: Element) -> Self.Index? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}
