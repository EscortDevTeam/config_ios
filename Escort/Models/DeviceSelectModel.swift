//
//  DeviceSelectModel.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

struct DeviceType {
    let name: String
    let code: String
    let image: String
    let isHide: Bool
}

let usbDevices: [DeviceType] = [
    DeviceType(name: "TD 500", code:"du-180", image: "td-500.png", isHide: false),
    DeviceType(name: "DU 180", code:"du-180", image: "du-180-hide.png", isHide: true),
    DeviceType(name: "Escort NET", code:"escort-net", image: "escort-net-hide.png", isHide: true),
    DeviceType(name: "DB 2", code:"db-2", image: "db-2-hide.png", isHide: true),
    DeviceType(name: "DGV 200", code:"dgv-200", image: "dgv-200-hide.png", isHide: true)
]

let bleDevices: [DeviceType] = [
    DeviceType(name: "TD BLE", code:"tb-ble", image: "td-ble", isHide: false),
    DeviceType(name: "TL BLE", code:"tl-ble", image: "tl-ble", isHide: false),
    DeviceType(name: "QR-CODE", code:"qrcode", image: "qrcode", isHide: false),
    DeviceType(name: "", code:"qrcode", image: "Path", isHide: true)

//    DeviceType(name: "DU 180", code:"du-180", image: "du-180-hide.png", isHide: true)
]
