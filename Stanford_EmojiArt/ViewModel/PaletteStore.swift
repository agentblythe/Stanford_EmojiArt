//
//  PaletteStore.swift
//  Stanford_EmojiArt
//
//  Created by Steve Blythe on 06/10/2021.
//

import SwiftUI

struct Palette: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id: Int
    
    fileprivate init(name: String, emojis: String, id: Int) {
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PaletteStore: ObservableObject {
    let name: String
    
    @Published var palettes = [Palette]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        return "PaletteStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: data) {
            palettes = decodedPalettes
        }
    }
    
    init(named name: String) {
        self.name = name
        
        restoreFromUserDefaults()
        
        if palettes.isEmpty {
            insertPalette(named: "Vehicles", emojis: "πππππππππππ»ππππ¦Όπ΄π²π΅ππΊπππππ‘π πππππππππππππβοΈπ«π¬π©π°ππΈππΆβ΅οΈπ€π₯π³β΄π’")
            insertPalette(named: "Sports", emojis: "β½οΈππβΎοΈπ₯πΎπππ₯π±πͺππΈπππ₯ππͺπ₯β³οΈπͺπΉπ£π₯π₯π½πΉπΌπ·π₯βΈπΏβ·ππͺποΈπ€Όπ€ΈβΉοΈπ€Ίπ€ΎποΈππ§πππ€½π£π§π΅π΄ππ₯π₯π₯πππ΅")
            insertPalette(named: "Music", emojis: "π€π§πΌπΉπ₯πͺπ·πΊπͺπΈπͺπ»")
            insertPalette(named: "Animals", emojis: "πππ§π¦π€π£π₯π¦π¦π¦π¦πΊππ΄π¦ππͺ±ππ¦ππππͺ°πͺ²πͺ³π¦π¦π·π¦π’ππ¦π¦π¦ππ¦π¦π¦π¦π‘π π¬ππ³ππ¦­π¦ππππ¦π¦π¦§π¦£ππ¦π¦πͺπ«π¦π¦π¦¬ππππππππ¦ππ¦ππ©π¦?πβπ¦Ίππββ¬ππ¦π¦€π¦π¦π¦’π¦©πππ¦π¦¨π¦‘π¦«π¦¦π¦₯πππΏπ¦π")
            insertPalette(named: "Animal Faces", emojis: "πΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨π―π¦π?π·πΈπ΅ππππ²")
            insertPalette(named: "Weather", emojis:
                "πͺπβοΈπ€βοΈπ₯βοΈπ¦π§βπ©π¨βοΈπ¬βοΈ")
        }
    }
    
    // MARK: - Intents
    func palette(at index: Int) -> Palette {
        let safeIndex = min(max(0, index), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1,
           palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(0, index), palettes.count)
        palettes.insert(palette, at: safeIndex)
    }
    
    
}
