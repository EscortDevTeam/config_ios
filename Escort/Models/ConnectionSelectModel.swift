//
//  ConnectionSelectModel.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

struct Connection {
    let name: String
    let code: String
    let image: String
}

let connections: [Connection] = [
    Connection(name: "BLUETOOTH".localized, code:"bt", image: "bluetooth.png"),
    Connection(name: "USB", code:"usb", image: "usb.png")
]
