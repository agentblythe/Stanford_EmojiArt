//
//  OptionalImage.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 05/09/2021.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}

struct OptionalImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage(uiImage: nil)
    }
}
