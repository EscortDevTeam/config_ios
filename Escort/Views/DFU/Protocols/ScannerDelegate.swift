//
//  ScannerDelegate.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc protocol ScannerDelegate {
    func centralManagerDidSelectPeripheral(withManager aManager: CBCentralManager, andPeripheral aPeripheral: CBPeripheral)
}
