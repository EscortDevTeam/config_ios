//
//  ModelBox.swift
//  Escort
//
//  Created by Володя Зверев on 12.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.

import RealmSwift

class ModelBox: Object {
    
    @objc dynamic var id: Int = 0

    @objc dynamic var nameDevice: String?
    @objc dynamic var time: String?

    @objc dynamic var temp: String?
    @objc dynamic var pressere: String?
    @objc dynamic var lux: String?
    @objc dynamic var humidity: String?
    @objc dynamic var hallSensor: String?
}
