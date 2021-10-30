//
//  RangeReplaceableCollection+.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 25/10/2021.
//

import Foundation

extension RangeReplaceableCollection where Element: Hashable {
    var removingDuplicateCharacters: Self {
        var set = Set<Element>()
        return filter{ set.insert($0).inserted }
    }
}
