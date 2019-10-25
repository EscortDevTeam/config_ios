//
//  DeviceUsbSettingsAddController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceUsbSettingsAddController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    private func textLineCreate(title: String, text: String, x: Int, y: Int, prefix: String) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let input = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input.text = text
        input.placeholder = "Введите значение"
        input.textColor = UIColor(rgb: 0xE9E9E9)
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always

        if !prefix.isEmpty {
            let lblPrefix = UILabel(frame: CGRect(x: screenWidth-80, y: 10, width: 100, height: 20))
            lblPrefix.text = prefix
            lblPrefix.textColor = UIColor(rgb: 0xE9E9E9)
            lblPrefix.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
            v.addSubview(lblPrefix)
        }

        v.addSubview(lblTitle)
        v.addSubview(input)
        
        return v
    }
    
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "Доп. возможности", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        
        var y = 100
        let x = 30, deltaY = 65, deltaYLite = 20

        let lblPassword = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 22))
        lblPassword.text = "Пароль на изменение настроек"
        lblPassword.textColor = UIColor(rgb: 0xE9E9E9)
        lblPassword.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        
        view.addSubview(lblPassword)

        y = y + deltaY

        view.addSubview(textLineCreate(title: "Пароль", text: "", x: x, y: y, prefix: ""))
        y = y + deltaY
        
        let btn1 = UIView(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn1.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1.layer.cornerRadius = 22
        
        let btn1Text = UILabel(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn1Text.text = "Ввести"
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        view.addSubview(btn1)
        view.addSubview(btn1Text)
        
        let btn2 = UIView(frame: CGRect(x: x + 140, y: y, width: 120, height: 44))
        btn2.backgroundColor = UIColor(rgb: 0xCF2121)
        btn2.layer.cornerRadius = 22
        
        let btn2Text = UILabel(frame: CGRect(x: x + 140, y: y, width: 120, height: 44))
        btn2Text.text = "Удалить"
        btn2Text.textColor = .white
        btn2Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn2Text.textAlignment = .center
        
        view.addSubview(btn2)
        view.addSubview(btn2Text)

        y = y + deltaY + deltaYLite
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        
        view.addSubview(separator)
        
        y = y + deltaYLite
        
        let lblSettings = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 22))
        lblSettings.text = "Ручной ввод конфигурации"
        lblSettings.textColor = UIColor(rgb: 0xE9E9E9)
        lblSettings.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        
        view.addSubview(lblSettings)
        
        y = y + deltaY
        
        view.addSubview(textLineCreate(title: "Полный", text: "", x: x, y: y, prefix: "15"))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Пустой", text: "", x: x, y: y, prefix: "45"))
        y = y + deltaY

        let btn3 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        btn3.layer.cornerRadius = 22
        
        let btn3Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3Text.text = "Установить"
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        
        view.addSubview(btn3)
        view.addSubview(btn3Text)

        y = y + deltaY
        
        let btn4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4.backgroundColor = UIColor(rgb: 0xCF2121)
        btn4.layer.cornerRadius = 22
        
        let btn4Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4Text.text = "Перегрузить TD-500"
        btn4Text.textColor = .white
        btn4Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn4Text.textAlignment = .center
        
        view.addSubview(btn4)
        view.addSubview(btn4Text)
    }
}
