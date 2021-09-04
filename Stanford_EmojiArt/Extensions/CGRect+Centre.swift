//
//  CGRect+Centre.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 04/09/2021.
//

import SwiftUI

extension CGRect {
    var centre: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
