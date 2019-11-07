//
//  LanguageSelectModel.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

struct Language: Decodable {
    let name: String
    let code: String
    let image: String
}

let languages: [Language] = [
    Language(name: "РУССКИЙ", code:"ru", image: "russia.png"),
    Language(name: "ENGLISH", code:"en", image: "english.png"),
    Language(name: "PORTUGUÊS", code:"pt-PT", image: "portugal.png"),
    Language(name: "ESPAÑOl", code:"es", image: "spain.png")
]
