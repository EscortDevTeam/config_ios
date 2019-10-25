//
//  DeviceUsbController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceUsbController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }

    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()

    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "sensor-usb.png")!)
        img.frame = CGRect(x: screenWidth-130, y: 100, width: 121, height: 386)
        return img
    }()

    private func textLineCreate(title: String, text: String, x: Int, y: Int) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))

        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Light", size: 18.0)

        let lblText = UILabel(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2), height: 20))
        lblText.text = text
        lblText.textColor = UIColor(rgb: 0xE9E9E9)
        lblText.font = UIFont(name:"FuturaPT-Medium", size: 18.0)

        v.addSubview(lblTitle)
        v.addSubview(lblText)

        return v
    }

    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "TD 500", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }

        view.addSubview(bgImage)
        view.addSubview(sensorImage)
        
        var y = 100
        let x = 30, deltaY = 40

        let deviceName = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 60))
        deviceName.text = "№ 22356\nFW: 1.9.1"
        deviceName.textColor = UIColor(rgb: 0xE9E9E9)
        deviceName.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        deviceName.numberOfLines = 0
        
        view.addSubview(deviceName)

        let degree = UIView(frame: CGRect(x: 130, y: y + 12, width: 100, height: 31))
        let degreeIcon = UIImageView(image: UIImage(named: "degree.png")!)
        degreeIcon.frame = CGRect(x: 0, y: 0, width: 18, height: 31)
        degree.addSubview(degreeIcon)
        let degreeName = UILabel(frame: CGRect(x: 24, y: 3, width: 40, height: 31))
        degreeName.text = "27°"
        degreeName.textColor = UIColor(rgb: 0xDADADA)
        degreeName.font = UIFont(name:"FuturaPT-Light", size: 16.0)
        degree.addSubview(degreeName)

        view.addSubview(degree)

        y = y + deltaY * 2 + deltaY / 2

        view.addSubview(textLineCreate(title: "Сет.адрес", text: "255", x: x, y: y))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Режим", text: "RS-485", x: x, y: y))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Фильтрация", text: "да", x: x, y: y))
        y = y + deltaY

        let separator = UIView(frame: CGRect(x: 0, y: y, width: Int(screenWidth-140), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        
        view.addSubview(separator)

        y = y + deltaY

        view.addSubview(textLineCreate(title: "Уровень", text: "1", x: x, y: y))
        y = y + deltaY
        view.addSubview(textLineCreate(title: "Напряжение", text: "0", x: x, y: y))
        y = y + deltaY + deltaY / 2
 
        let statusName = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 60))
        if Bool.random() {
            statusName.text = "Connected"
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected"
            statusName.textColor = UIColor(rgb: 0xCF2121)
        }
        statusName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        view.addSubview(statusName)

        // tabs

        let footer = UIView(frame: CGRect(x: 0, y: screenHeight - 80, width: screenWidth, height: 80))
        footer.backgroundColor = UIColor(rgb: 0xEAEAEB)

        let footerCellWidth = Int(screenWidth/3), footerCellHeight = 90

        let cellSetting = UIView(frame: CGRect(x: 0, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingIcon = UIImageView(image: UIImage(named: "settings.png")!)
        cellSettingIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingIcon.center = CGPoint(x: cellSetting.frame.size.width / 2, y: cellSetting.frame.size.height / 2 - 15)
        cellSetting.addSubview(cellSettingIcon)

        let cellSettingName = UILabel(frame: CGRect(x: 0, y: 55, width: footerCellWidth, height: 20))
        cellSettingName.text = "настройки"
        cellSettingName.textColor = UIColor(rgb: 0x000000)
        cellSettingName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingName.textAlignment = .center
        cellSetting.addSubview(cellSettingName)

        cellSetting.addTapGesture {
            self.navigationController?.pushViewController(DeviceUsbSettingsController(), animated: true)
        }

        let cellSettingAdd = UIView(frame: CGRect(x: footerCellWidth, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingAddIcon = UIImageView(image: UIImage(named: "settings-add.png")!)
        cellSettingAddIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingAddIcon.center = CGPoint(x: cellSettingAdd.frame.size.width / 2, y: cellSettingAdd.frame.size.height / 2 - 15)
        cellSettingAdd.addSubview(cellSettingAddIcon)

        let cellSettingAddName = UILabel(frame: CGRect(x: 0, y: 55, width: footerCellWidth, height: 20))
        cellSettingAddName.text = "доп.возможности"
        cellSettingAddName.textColor = UIColor(rgb: 0x000000)
        cellSettingAddName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingAddName.textAlignment = .center
        cellSettingAdd.addSubview(cellSettingAddName)

        cellSettingAdd.addTapGesture {
            self.navigationController?.pushViewController(DeviceUsbSettingsAddController(), animated: true)
        }

        let cellHelp = UIView(frame: CGRect(x: footerCellWidth*2, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellHelpIcon = UIImageView(image: UIImage(named: "help.png")!)
        cellHelpIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellHelpIcon.center = CGPoint(x: cellHelp.frame.size.width / 2, y: cellHelp.frame.size.height / 2 - 15)
        cellHelp.addSubview(cellHelpIcon)

        let cellHelpName = UILabel(frame: CGRect(x: 0, y: 55, width: footerCellWidth, height: 20))
        cellHelpName.text = "справка"
        cellHelpName.textColor = UIColor(rgb: 0x000000)
        cellHelpName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellHelpName.textAlignment = .center
        cellHelp.addSubview(cellHelpName)

        cellHelp.addTapGesture {
            self.navigationController?.pushViewController(DeviceUsbHelpController(), animated: true)
        }

        footer.addSubview(cellSetting)
        footer.addSubview(cellSettingAdd)
        footer.addSubview(cellHelp)

        view.addSubview(footer)
    }
}
