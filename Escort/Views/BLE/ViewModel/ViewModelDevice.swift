//
//  ViewModelDevice.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

struct ModelDevice {
    let name: String
    let nameNext: String
    let image: UIImage
}
class ViewModelDevice {
    let devicesName: [ModelDevice] = [
        ModelDevice(name: "Fuel level sensor", nameNext: "TD-BLE", image: UIImage(named: "TD-W")!),
        ModelDevice(name: "Tilt angle sensor", nameNext: "DU-BLE", image: UIImage(named: "DU-W")!),
        ModelDevice(name: "Temperature and luminosity sensor", nameNext: "TL-BLE", image: UIImage(named: "TL-W")!),
        ModelDevice(name: "Temperature, humidity and magnetic field sensor", nameNext: "TH-BLE", image: UIImage(named: "TH-W")!),
//        ModelDevice(name: "Найти датчик по QR-code", image: UIImage(named: "QRCODE-W")!),
    ]
    let tlParametrs = ["signal", "№123456", "redLine", "Temperature", "Level", "Connected"]
    
    let thParametrs = ["signal", "№123456", "redLine", "Temperature", "Humidity", "Luminosity", "Magnetic field", "Connected"]

    let colorConnected = [UIColor(rgb: 0xCF2121), UIColor(rgb: 0x00A778)]
    
    let signal = [UIImage(named: "signal0"),
                  UIImage(named: "signal1"),
                  UIImage(named: "signal2"),
                  UIImage(named: "signal3"),
                  UIImage(named: "signal4"),
    ]
    let battery = [UIImage(named: "bat1"),
                  UIImage(named: "bat2"),
                  UIImage(named: "bat3"),
                  UIImage(named: "bat4"),
    ]
    
    let copyImage = [UIImage(named: "copy-Id-W"),
                     UIImage(named: "copy-Id")
    ]
    func copyImage(isNight: Bool) -> UIImage? {
        if isNight {
            guard let image = UIImage(named: "copy-Id-W") else {return nil}
            return image
        } else {
            guard let image = UIImage(named: "copy-Id") else {return nil}
            return image
        }
    }
    var passwordFirst = true
    var isTL = true
    
    let blackBoxTHParametrs = ["Temperature","Luminosity","Humidity","Hall sensor triggering"]
    
    func unixTimeStringtoStringFull(unixTime: String) -> String {
        guard let unixtimeReal = Int(unixTime) else {return "error"}
        let date = Date(timeIntervalSince1970: TimeInterval(unixtimeReal))
        let dateFormatter = DateFormatter()
    //    dateFormatter.timeStyle = DateFormatter.Style.short
    //    dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
