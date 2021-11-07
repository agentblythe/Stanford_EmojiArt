//
//  IdentifiableAlert.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 06/11/2021.
//

import SwiftUI

struct IdentifiableAlert : Identifiable {
    var id: String
    var alert: () -> Alert
}
