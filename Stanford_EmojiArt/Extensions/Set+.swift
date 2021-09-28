//
//  Set.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 14/09/2021.
//

import Foundation

extension Set where Element: Identifiable {
    /// 
    mutating func toggleInclusion(of element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        } else {
            insert(element)
        }
    }
}
