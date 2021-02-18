//
//  ProtocolTHTL.swift
//  Escort
//
//  Created by Володя Зверев on 08.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import Foundation

protocol PasswordDelegate {
    func buttonReloadDevice()
    func actionSetPassword()
    func actionDeletePassword()
    func pushSaveData()
}
protocol PasswordSetDelegate {
    func setPassword(bool : Bool)
}
protocol UpdateButtomDelegate {
    func updateDevice()
    func sinfDevice()
}

protocol BlackBoxTHDelegate {
    func blackBoxTap()
    func passwordAlert()
    func newPasswordAlert()
}
