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
    
    let duParametrs = ["signal", "№123456", "redLine", "Angle", "Mode", "Event notific.", "Connected", "Set 0"]

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
    func detectDuModeString(intMode: Int, intModeS: Int) -> [String] {
        switch intMode {
        case 0:
            return ["Transportation".localized(code), "Accelerometer is off".localized(code)]
        case 4:
            switch intModeS {
            case 0:
                return ["Vertical rotation control".localized(code), "Inactive".localized(code)]
            case 1:
                return ["Vertical rotation control".localized(code), "To the left".localized(code)]
            case 2:
                return ["Vertical rotation control".localized(code), "To the right".localized(code)]
            default:
                return ["",""]
            }
        case 5:
            switch intModeS {
            case 0:
                return ["Horizontal rotation control".localized(code), "Inactive".localized(code)]
            case 1:
                return ["Horizontal rotation control".localized(code), "To the left".localized(code)]
            case 2:
                return ["Horizontal rotation control".localized(code), "To the right".localized(code)]
            default:
                return ["",""]
            }
        case 6:
            switch intModeS {
            case 0:
                return ["Angle control".localized(code), "Inactive".localized(code)]
            case 1:
                return ["Angle control".localized(code), "Active".localized(code)]
            default:
                return ["",""]
            }
        case 9:
            switch intModeS {
            case 0:
                return ["Bucket".localized(code), "Inactive".localized(code)]
            case 1:
                return ["Bucket".localized(code), "Active".localized(code)]
            default:
                return ["",""]
            }
        case 10:
            switch intModeS {
            case 0:
                return ["Plow".localized(code), "Inactive".localized(code)]
            case 1:
                return ["Plow".localized(code), "Active".localized(code)]
            default:
                return ["",""]
            }
        default:
            return ["",""]
        }
    }
    func detectDuModeInt(intMode: String) -> Int {
        switch intMode {
        case "Transportation".localized(code):
            return 0
        case "Vertical rotation control".localized(code):
            return 2
        case "Horizontal rotation control".localized(code):
            return 1
        case "Angle control".localized(code):
            return 3
        case "Bucket".localized(code):
            return 4
        case "Plow".localized(code):
            return 5
        default:
            return 0
        }
    }
}
