//
//  CustomAlertProtocols.swift
//  Escort
//
//  Created by Володя Зверев on 11.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import Foundation

protocol AlertDelegate: class {
    func buttonTapped2()
    func forgotTapped2()
    func buttonClose2()
}

protocol AlertNewDelegate: class {
    func buttonTapped()
    func forgotTapped()
    func buttonClose()
}
