//
//  SetupMapObject.swift
//  Escort
//
//  Created by Володя Зверев on 26.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class SetupMap: UIViewController {
    func setupTheme() {
        view.theme.backgroundColor = themed { $0.backgroundColor }
        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
        backView.theme.tintColor = themed{ $0.navigationTintColor }
        mapHelp.theme.textColor = themed{ $0.navigationTintColor }
        setupMapText.theme.textColor = themed{ $0.navigationTintColor }
        setupMapTextSecond.theme.textColor = themed{ $0.navigationTintColor }
        setupMapTextField.theme.textColor = themed{ $0.navigationTintColor }
        setupMapTextFieldSecond.theme.textColor = themed{ $0.navigationTintColor }

    }
    
    var nextStatus = 1
    var backStatus = 1
    
    lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-70), height: 40))
        text.text = "Карта установки".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenHeight-200, width: 201, height: 207)
        return img
    }()
    
    lazy var successGreen: UIImageView = {
        let successGreen = UIImageView()
        successGreen.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        successGreen.image = #imageLiteral(resourceName: "successGreen")
        successGreen.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30)
        successGreen.frame.origin.x = screenWidth - 50
        successGreen.alpha = 0.0
        return successGreen
    }()
    
    lazy var successGreenSecond: UIImageView = {
        let successGreenSecond = UIImageView()
        successGreenSecond.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        successGreenSecond.image = #imageLiteral(resourceName: "successGreen")
        successGreenSecond.center.y = screenHeight/2
        successGreenSecond.alpha = 0.0
        successGreenSecond.frame.origin.x = screenWidth - 50
        return successGreenSecond
    }()
    
    lazy var statusBarRedOne: UIView =  {
        let statusBarRedOne = UIView()
        statusBarRedOne.frame = CGRect(x: 30, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedOne.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedOne.layer.cornerRadius = 3
        return statusBarRedOne
    }()
    lazy var statusBarRedTwo: UIView =  {
        let statusBarRedTwo = UIView()
        let a = Int(screenWidth-90)/6 + 5
        statusBarRedTwo.frame = CGRect(x: 30 + a, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedTwo.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedTwo.layer.cornerRadius = 3
        return statusBarRedTwo
    }()
    lazy var statusBarRedThree: UIView =  {
        let statusBarRedTwo = UIView()
        var a = Int(screenWidth-90)/6 + 5
        a = a*2
        statusBarRedTwo.frame = CGRect(x: 30 + a, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedTwo.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedTwo.layer.cornerRadius = 3
        return statusBarRedTwo
    }()
    lazy var statusBarRedFour: UIView =  {
        let statusBarRedTwo = UIView()
        var a = Int(screenWidth-90)/6 + 5
        a = a*3
        statusBarRedTwo.frame = CGRect(x: 30 + a, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedTwo.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedTwo.layer.cornerRadius = 3
        return statusBarRedTwo
    }()
    lazy var statusBarRedFive: UIView =  {
        let statusBarRedTwo = UIView()
        var a = Int(screenWidth-90)/6 + 5
        a = a*4
        statusBarRedTwo.frame = CGRect(x: 30 + a, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedTwo.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedTwo.layer.cornerRadius = 3
        return statusBarRedTwo
    }()
    lazy var statusBarRedSix: UIView =  {
        let statusBarRedTwo = UIView()
        var a = Int(screenWidth-90)/6 + 5
        a = a*5
        statusBarRedTwo.frame = CGRect(x: 30 + a, y: hasNotch ? 100 : 120, width: 0, height: 6)
        statusBarRedTwo.backgroundColor = UIColor(rgb: 0xE80000)
        statusBarRedTwo.layer.cornerRadius = 3
        return statusBarRedTwo
    }()
    lazy var mapHelp: UILabel = {
        let mapHelp = UILabel()
        mapHelp.frame = CGRect(x: 0, y: (hasNotch ? 0 : 50) + 100, width: 205, height: 80)
        mapHelp.text = "Карта установщика позволит вам:".localized(code)
        mapHelp.center.x = screenWidth/2
        mapHelp.textAlignment = .center
        mapHelp.numberOfLines = 0
        mapHelp.font = UIFont(name:"FuturaPT-Medium", size: 24.0)
        return mapHelp
    }()
    lazy var viewRedLines: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 0 : 50) + 175, width: 138, height: 3)
        v.backgroundColor = UIColor(rgb: 0xE80000)
        v.layer.cornerRadius = 2
        v.center.x = screenWidth/2
        return v
    }()
    
    lazy var mapHelpTwo: UIView = {
        let mapView = UIView()
        mapView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
        mapView.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30)
        let mapHelp = UILabel()
        mapHelp.frame = CGRect(x: 0, y: 0, width: 220, height: 60)
        mapHelp.text = "Грамотно составить карту вашего монтажа".localized(code)
        mapHelp.center.x = screenWidth/2
        mapHelp.textAlignment = .left
        mapHelp.numberOfLines = 0
        mapHelp.textColor = isNight ? UIColor(rgb: 0xD1D1D1): UIColor(rgb: 0x626262)
        mapHelp.font = UIFont(name:"FuturaPT-Light", size: 20.0)
        mapView.addSubview(mapHelp)
        let mapHelpImage = UIImageView()
        mapHelpImage.image = isNight ? #imageLiteral(resourceName: "Group 26") : #imageLiteral(resourceName: "Vector-2")
        mapHelpImage.frame = CGRect(x: screenWidth/2-150, y: 0, width: 30, height: 30)
        mapHelpImage.center.y = mapView.bounds.height/2
        mapView.addSubview(mapHelpImage)
        return mapView
    }()
    lazy var viewGrayLines: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 230, height: 2)
        v.center.y = screenHeight/2 - 53 - (hasNotch ? 0 : 15)
        v.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        v.layer.cornerRadius = 1
        v.center.x = screenWidth/2+6
        return v
    }()
    lazy var viewGrayLinesSecond: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 230, height: 2)
        v.center.y = screenHeight/2 - 53 - (hasNotch ? 0 : 15)
        v.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        v.layer.cornerRadius = 1
        v.center.x = screenWidth/2+6
        return v
    }()
    lazy var mapHelpThree: UIView = {
        let mapView = UIView()
        mapView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 80)
        mapView.center.y = screenHeight/2
        let mapHelp = UILabel()
        mapHelp.frame = CGRect(x: 0, y: 0, width: 220, height: 80)
        mapHelp.center.x = screenWidth/2
        mapHelp.textAlignment = .left
        mapHelp.numberOfLines = 0
        mapHelp.textColor = isNight ? UIColor(rgb: 0xD1D1D1): UIColor(rgb: 0x626262)
        mapHelp.font = UIFont(name:"FuturaPT-Light", size: 20.0)
        let fullString = NSMutableAttributedString(string: "Отправить её удобным способом  ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = isNight ? #imageLiteral(resourceName: "Vector-4") : #imageLiteral(resourceName: "Vector")
        image1Attachment.bounds.size = CGSize(width: 15, height: 15)
        let image1Attachment2 = NSTextAttachment()
        image1Attachment2.image = isNight ? #imageLiteral(resourceName: "Vector-3") : #imageLiteral(resourceName: "Vector-1")
        image1Attachment2.bounds.size = CGSize(width: 15, height: 15)
        let image1String = NSAttributedString(attachment: image1Attachment)
        let image2String = NSAttributedString(attachment: image1Attachment2)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: "  "))
        fullString.append(image2String)
        fullString.append(NSAttributedString(string: "  (и другие) в ваш диспетчерский центр"))
        mapHelp.attributedText = fullString
        mapView.addSubview(mapHelp)
        let mapHelpImage = UIImageView()
        mapHelpImage.image = isNight ? #imageLiteral(resourceName: "Group 27-2") : #imageLiteral(resourceName: "Group 28")
        mapHelpImage.frame = CGRect(x: screenWidth/2-150, y: 0, width: 30, height: 30)
        mapHelpImage.center.y = mapView.bounds.height/2
        mapView.addSubview(mapHelpImage)
        return mapView
    }()
    lazy var mapHelpLabel: UILabel = {
        let mapHelpLabel = UILabel()
        mapHelpLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 60)
        mapHelpLabel.center.x = screenWidth/2
        mapHelpLabel.center.y = screenHeight / 4 * 3 - 20
        mapHelpLabel.textAlignment = .center
        mapHelpLabel.numberOfLines = 0
        mapHelpLabel.textColor = isNight ? UIColor(rgb: 0xFFFFFF): UIColor(rgb: 0x424141)
        mapHelpLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        mapHelpLabel.text = "Для этого вам нужно пройти 6 простых шагов"
        return mapHelpLabel
    }()
    lazy var mapHelpButton: UIButton = {
        let mapHelpButton = UIButton()
        mapHelpButton.backgroundColor = UIColor(rgb: 0xE80000)
        mapHelpButton.frame = CGRect(x: 0, y: 0, width: screenWidth / 2.5, height: 46)
        mapHelpButton.center.x = screenWidth/2
        mapHelpButton.center.y = screenHeight / 4 * 3 + 50
        mapHelpButton.layer.cornerRadius = 8
        mapHelpButton.setTitle("Start".localized(code), for: .normal)
        mapHelpButton.titleLabel?.font =  UIFont(name: "FuturaPT-Medium", size: 20)
        return mapHelpButton
    }()
    
    lazy var progresViewAll: UIView = {
        var a = 0
        let x = 30
        let countStatus = 6
        let progresViewAll = UIView(frame: CGRect(x: -screenWidth, y: hasNotch ? 100 : 120, width: screenWidth, height: 10))
        progresViewAll.alpha = 0.0
        for _ in 1...countStatus {
            let progresViewOne = UIView()
            progresViewOne.frame = CGRect(x: x + a, y: 0, width: Int(screenWidth-CGFloat(x*2)-CGFloat(5*countStatus-1))/countStatus, height: 6)
            progresViewOne.backgroundColor = UIColor(rgb: 0xE6E6E6)
            progresViewOne.layer.cornerRadius = 3
            progresViewAll.addSubview(progresViewOne)
            a = a + Int(screenWidth-CGFloat(x*2)-CGFloat(5*countStatus))/countStatus + 5
        }
        return progresViewAll
    }()
    lazy var setupMapTextField: UITextField = {
        let setupMapTextField = UITextField()
        setupMapTextField.backgroundColor = .clear
        setupMapTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: setupMapTextField.frame.height))
        setupMapTextField.leftViewMode = .always
        setupMapTextField.attributedPlaceholder = NSAttributedString(string: "Иванов Иван Иванович", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTextField.frame = CGRect(x: 0, y: 0, width: screenWidth / 1.3, height: 46)
        setupMapTextField.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30)
        setupMapTextField.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        setupMapTextField.frame.origin.x = screenWidth
        setupMapTextField.layer.cornerRadius = 8
        setupMapTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
        return setupMapTextField
    }()
    lazy var setupMapTextFieldSecond: UITextField = {
        let setupMapTextFieldSecond = UITextField()
        setupMapTextFieldSecond.backgroundColor = .clear
        setupMapTextFieldSecond.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: setupMapTextFieldSecond.frame.height))
        setupMapTextFieldSecond.leftViewMode = .always
        setupMapTextFieldSecond.attributedPlaceholder = NSAttributedString(string: "ООО «Аврора»", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTextFieldSecond.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        setupMapTextFieldSecond.frame = CGRect(x: 0, y: 0, width: screenWidth / 1.3, height: 46)
        setupMapTextFieldSecond.center.y = screenHeight/2
        setupMapTextFieldSecond.alpha = 0.0
        setupMapTextFieldSecond.frame.origin.x = -screenWidth
        setupMapTextFieldSecond.layer.cornerRadius = 8
        setupMapTextFieldSecond.addTarget(self, action: #selector(self.textFieldDidChangeSecond(_:)),for: UIControl.Event.editingChanged)
        return setupMapTextFieldSecond
    }()
    
    lazy var setupMapText: UILabel = {
        let setupMapText = UILabel()
        setupMapText.text = "ФИО исполнителя"
        setupMapText.frame = CGRect(x: 0, y: 0, width: screenWidth / 1.3, height: 46)
        setupMapText.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30) - 30
        setupMapText.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        setupMapText.frame.origin.x = screenWidth
        return setupMapText
    }()
    lazy var setupMapTextSecond: UILabel = {
        let setupMapTextSecond = UILabel()
        setupMapTextSecond.text = "Заказчик"
        setupMapTextSecond.frame = CGRect(x: 0, y: 0, width: screenWidth / 1.3, height: 46)
        setupMapTextSecond.center.y = screenHeight/2-30
        setupMapTextSecond.alpha = 0.0
        setupMapTextSecond.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        setupMapTextSecond.frame.origin.x = -screenWidth
        return setupMapTextSecond
    }()
    
}
