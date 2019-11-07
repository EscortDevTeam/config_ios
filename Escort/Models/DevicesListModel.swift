//
//  DevicesListModel.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 10.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

struct Device {
    let name: String
}

struct Menu {
    let name: String
}
let menuSide: [Menu] = [
    Menu(name: "Bluetooth"),
    Menu(name: "USB"),
    Menu(name: "Language".localized(code))
]

let devices: [Device] = [
    Device(name: "Device 1"),
    Device(name: "Device 2"),
    Device(name: "Device 3"),
    Device(name: "Device 4"),
    Device(name: "Device 5"),
    Device(name: "Device 6"),
    Device(name: "Device 7"),
    Device(name: "Device 8"),
    Device(name: "Device 9"),
    Device(name: "Device 10"),
    Device(name: "Device 11"),
    Device(name: "Device 12"),
    Device(name: "Device 13"),
    Device(name: "Device 14"),
    Device(name: "Device 15"),
    Device(name: "Device 16"),
    Device(name: "Device 17"),
    Device(name: "Device 18"),
    Device(name: "Device 19"),
    Device(name: "Device 20")
]
