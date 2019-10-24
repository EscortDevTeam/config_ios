//
//  DeviceUsbSettingsController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceUsbSettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    private func textLineCreate(title: String, text: String, x: Int, y: Int, isCheck: Bool) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)

        let check = UIImageView(image: UIImage(named: isCheck ? "check-green.png" : "check-red.png")!)
        check.frame = CGRect(x: 120, y: 4, width: 22, height: 26)

        let input = UITextField(frame: CGRect(x: 160, y: 0, width: Int(screenWidth/2-30), height: 40))
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

        v.addSubview(lblTitle)
        v.addSubview(check)
        v.addSubview(input)
        
        return v
    }
    
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "Настройки TD 500", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
       
        var y = 100
        let x = 30, deltaY = 65, deltaYLite = 20
        
        view.addSubview(textLineCreate(title: "Сет.адрес", text: "", x: x, y: y, isCheck: true))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Мин.уровень", text: "1", x: x, y: y, isCheck: false))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Макс.уровень", text: "1024", x: x, y: y, isCheck: false))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Фильтрация", text: "Да", x: x, y: y, isCheck: false))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Режим", text: "RS-485", x: x, y: y, isCheck: false))
        y = y + deltaY
        
        let btn1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1.layer.cornerRadius = 22
        
        let btn1Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1Text.text = "Запросить параметры устройства"
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        y = y + deltaY
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        
        view.addSubview(btn1)
        view.addSubview(btn1Text)
        view.addSubview(separator)
        
        y = y + deltaYLite
        
        let lbl1 = UILabel(frame: CGRect(x: x, y: y, width: 100, height: 20))
        lbl1.text = "25"
        lbl1.textColor = UIColor(rgb: 0xE9E9E9)
        lbl1.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let lbl2 = UILabel(frame: CGRect(x: Int(screenWidth-140), y: y, width: 100, height: 20))
        lbl2.text = "45"
        lbl2.textColor = UIColor(rgb: 0xE9E9E9)
        lbl2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        
        y = y + deltaYLite + deltaYLite/2
        
        let btn2 = UIView(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn2.backgroundColor = UIColor(rgb: 0xCF2121)
        btn2.layer.cornerRadius = 22
        
        let btn2Text = UILabel(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn2Text.text = "Пустой"
        btn2Text.textColor = .white
        btn2Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn2Text.textAlignment = .center
        
        view.addSubview(btn2)
        view.addSubview(btn2Text)
        
        let btn3 = UIView(frame: CGRect(x: Int(screenWidth-150), y: y, width: 120, height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        btn3.layer.cornerRadius = 22
        
        let btn3Text = UILabel(frame: CGRect(x: Int(screenWidth-150), y: y, width: 120, height: 44))
        btn3Text.text = "Полный"
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        
        view.addSubview(btn3)
        view.addSubview(btn3Text)
        
        y = y + deltaY
        
        let lbl3 = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 20))
        lbl3.text = "CNT          20497"
        lbl3.textColor = UIColor(rgb: 0xE9E9E9)
        lbl3.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let lbl4 = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth)-70, height: 20))
        if Bool.random() {
            lbl4.text = "Стабилен"
            lbl4.textColor = UIColor(rgb: 0x00A778)
        } else {
            lbl4.text = "Не стабилен"
            lbl4.textColor = UIColor(rgb: 0xCF2121)
        }
        lbl4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        lbl4.textAlignment = .right
        
        view.addSubview(lbl3)
        view.addSubview(lbl4)
    }
}
