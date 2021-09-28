//
//  Array+LoadObjects.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 04/09/2021.
//

import SwiftUI

extension Array where Element == NSItemProvider {
    /// Convenience functions for [NSItemProvider] (i.e. array of NSItemProvider) makes the code for  loading objects from the providers a bit simpler NSItemProvider is a holdover from the Objective-C (i.e. pre-Swift) world you can tell by its very name (starts with NS) so unfortunately, dealing with this API is a little bit crufty thus I recommend you just accept that these loadObjects functions will work and move on it's a rare case where trying to dive in and understand what's going on here would probably not be a very efficient use of your time (though I'm certainly not going to say you shouldn't!) (just trying to help you optimize your valuable time this quarter)
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            provider.loadObject(ofClass: theType) { object, error in
                if let value = object as? T {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            let _ = provider.loadObject(ofClass: theType) { object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }

    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
    
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
}
