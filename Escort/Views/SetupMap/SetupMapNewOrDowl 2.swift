//
//  SetupMapNewOrDowl.swift
//  Escort
//
//  Created by Володя Зверев on 19.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import MobileCoreServices
import UIDrawer

class SetupMapNewOrDowl: UIViewController {

    let generator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        viewShow()
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        return activity
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight - (hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-60), height: 40))
        text.text = "Карта установки".localized(code)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    lazy var btTitle1: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 50))
        btTitle1.center.x = screenWidth/2
        btTitle1.text = "Создать новую".localized(code)
        btTitle1.textAlignment = .center
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 42.0)
        return btTitle1
    }()
    lazy var btTitle2: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 160, y: 16, width: screenWidth, height: 50))
        btTitle2.center.x = screenWidth/2
        btTitle2.text = "Продолжить".localized(code)
        btTitle2.textAlignment = .center
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 42.0)
        return btTitle2
    }()
    lazy var btTitle3: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 40, y: 36, width: screenWidth-80, height: 50))
        btTitle1.text = "Начать составлять карту устовки заново".localized(code)
        btTitle1.center.x = screenWidth/2
        btTitle1.numberOfLines = 0
        btTitle1.textAlignment = .center
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return btTitle1
    }()
    lazy var btTitle4: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 40, y: 16, width: screenWidth-80, height: 50))
        btTitle2.numberOfLines = 0
        btTitle2.textAlignment = .center
        btTitle2.center.x = screenWidth/2
        btTitle2.text = "Все данные останутся прежними".localized(code)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return btTitle2
    }()
    fileprivate lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + Int((screenHeight - headerHeight) / 2), width: Int(screenWidth), height: 1))
        separator.alpha = 0.1
        return separator
    }()
    fileprivate lazy var btImage1: UIImageView = {
        let btImage1 = UIImageView(image: #imageLiteral(resourceName: "startT"))
        btImage1.frame = CGRect(x: 40, y: 0, width: 70, height: 70)
        btImage1.image = btImage1.image!.withRenderingMode(.alwaysTemplate)
        return btImage1
    }()
    fileprivate lazy var btImage2: UIImageView = {
        let btImage2 = UIImageView(image: #imageLiteral(resourceName: "continT"))
        btImage2.frame = CGRect(x: 40, y: 0, width: 70, height: 60)
        btImage2.image = btImage2.image!.withRenderingMode(.alwaysTemplate)
        return btImage2
    }()

    
    private func viewShow() {
        
        view.addSubview(themeBackView3)
        MainLabel.text = "Карта установки".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)

        backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cellHeight = Int((screenHeight - headerHeight) / 2)
        let v1 = UIView()

//        btImage1.center.y = CGFloat(cellHeight/2)
        btTitle1.center.y = CGFloat(cellHeight/2)
        btTitle3.center.y = CGFloat(cellHeight/2+60)
        v1.addSubview(btTitle3)
//        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)

        v1.frame = CGRect(x:0, y: Int(headerHeight), width: Int(screenWidth), height: cellHeight)
        v1.addTapGesture{
            self.generator.impactOccurred()
            self.clearBD()
            self.navigationController?.pushViewController(SetupMap(), animated: true)
        }
        view.addSubview(separator)
        
        // Continue
        
        let v2 = UIView()
//        btImage2.center.y = CGFloat(cellHeight/2)
        btTitle2.center.y = CGFloat(cellHeight/2)
        btTitle4.center.y = CGFloat(cellHeight/2+60)
        v2.addSubview(btTitle4)
//        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight, width: Int(screenWidth), height: cellHeight)
        v2.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(SetupMap(), animated: true)
        }
        
        view.addSubview(v1)
        view.addSubview(v2)
    }
    
    func clearBD() {
        UserDefaults.standard.removeObject(forKey: "photoALLModel_1")
        UserDefaults.standard.removeObject(forKey: "photoALLModel_2")

        UserDefaults.standard.removeObject(forKey: "photoALLNumber_1")
        UserDefaults.standard.removeObject(forKey: "photoALLNumber_2")
        
        UserDefaults.standard.removeObject(forKey: "FioMap")
        UserDefaults.standard.removeObject(forKey: "ZakazMap")

        UserDefaults.standard.removeObject(forKey: "modelTcTextMap")
        UserDefaults.standard.removeObject(forKey: "numberTcTextMap")

        UserDefaults.standard.removeObject(forKey: "photoALLTrack_1")
        UserDefaults.standard.removeObject(forKey: "photoALLTrack_2")
        
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba_1")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba_2")

        UserDefaults.standard.removeObject(forKey: "photoALLPlace_1")
        UserDefaults.standard.removeObject(forKey: "photoALLPlace_2")
        UserDefaults.standard.removeObject(forKey: "photoALLPlace_3")
        UserDefaults.standard.removeObject(forKey: "photoALLPlace_4")
        
        UserDefaults.standard.removeObject(forKey: "modelTrackTextMap")
        UserDefaults.standard.removeObject(forKey: "plombaTrackTextMap")
        UserDefaults.standard.removeObject(forKey: "infoTrackTextMap")
        
        UserDefaults.standard.removeObject(forKey: "DUTMain_0")
        UserDefaults.standard.removeObject(forKey: "DUTMain_1")
        UserDefaults.standard.removeObject(forKey: "DUTMain_2")
        UserDefaults.standard.removeObject(forKey: "DUTMain_3"
        )
        UserDefaults.standard.removeObject(forKey: "DUT_0")
        UserDefaults.standard.removeObject(forKey: "DUT_1")
        UserDefaults.standard.removeObject(forKey: "DUT_2")
        UserDefaults.standard.removeObject(forKey: "DUT_3")
        
        UserDefaults.standard.removeObject(forKey: "DUTP_0")
        UserDefaults.standard.removeObject(forKey: "DUTP_1")
        UserDefaults.standard.removeObject(forKey: "DUTP_2")
        UserDefaults.standard.removeObject(forKey: "DUTP_3")
        
        UserDefaults.standard.removeObject(forKey: "DUTP2_0")
        UserDefaults.standard.removeObject(forKey: "DUTP2_1")
        UserDefaults.standard.removeObject(forKey: "DUTP2_2")
        UserDefaults.standard.removeObject(forKey: "DUTP2_3")
        
        UserDefaults.standard.removeObject(forKey: "DUTDop_0")
        UserDefaults.standard.removeObject(forKey: "DUTDop_1")
        UserDefaults.standard.removeObject(forKey: "DUTDop_2")
        UserDefaults.standard.removeObject(forKey: "DUTDop_3")
        
        UserDefaults.standard.removeObject(forKey: "countDuts")
        
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_10")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_11")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_12")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_13")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_20")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_21")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_22")
        UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_23")
        
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_10")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_11")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_12")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_13")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_20")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_21")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_22")
        UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_23")

        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_10")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_11")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_12")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_13")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_20")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_21")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_22")
        UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_23")
        
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            btTitle1.theme.textColor = themed{ $0.navigationTintColor }
            btTitle2.theme.textColor = themed{ $0.navigationTintColor }
            btTitle3.theme.textColor = themed{ $0.navigationTintColor }
            btTitle4.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            separator.theme.backgroundColor = themed { $0.navigationTintColor }
            btImage2.theme.tintColor = themed{ $0.navigationTintColor }
            btImage1.theme.tintColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            btTitle1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            btTitle2.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle4.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            separator.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btImage2.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btImage1.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)

        }

     }
}
