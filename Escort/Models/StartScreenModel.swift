//
//  Model.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 30.06.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

struct StartScreen {
    let image: String
    let x: Int
    let y: Int
    let width: Int
    let height: Int
    let color: UIColor?
}

let imgWidth: Int = 640 / 4, imgHeight: Int = 240 / 4
let delatX = 20, delatY = 60
let startY = 60, startX = 20

let startScreens: [StartScreen] = [
    StartScreen(image: "1", x: Int(screenWidth) - imgWidth - delatX, y: startY, width: imgWidth, height: imgHeight, color: .black),
    StartScreen(image: "2", x: Int(screenWidth) - imgWidth - delatX, y: startY, width: imgWidth, height: imgHeight, color: .black),
    StartScreen(image: "3", x: startX, y: Int(screenHeight) - imgHeight - delatY, width: imgWidth, height: imgHeight, color: .white),
    StartScreen(image: "r_4xxxhdpi", x: startX, y: Int(screenHeight) - imgHeight - delatY, width: imgWidth, height: imgHeight, color: .white),
    StartScreen(image: "r_5xhdpi", x: startX, y: Int(screenHeight) - imgHeight - delatY, width: imgWidth, height: imgHeight, color: .white),
    StartScreen(image: "r_61", x: Int(screenWidth) - imgWidth - delatX, y: startY, width: imgWidth, height: imgHeight, color: .black),
    StartScreen(image: "r_71", x: startX, y: Int(screenHeight) - imgHeight - delatY, width: imgWidth, height: imgHeight, color: .white),
    StartScreen(image: "4", x: Int(screenWidth) - imgWidth - delatX, y: startY-40, width: imgWidth, height: imgHeight, color: .black),
    StartScreen(image: "5", x: startX, y: startY-40, width: imgWidth, height: imgHeight, color: .black)

]

let mainScreen = StartScreen(image: "main.png", x: 0, y: 0, width: 0, height: 0, color: nil)
