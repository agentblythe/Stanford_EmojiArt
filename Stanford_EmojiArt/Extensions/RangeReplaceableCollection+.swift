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

extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}
