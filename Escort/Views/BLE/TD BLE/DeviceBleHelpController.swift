//
//  DeviceBleHelpController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer

class DeviceBleHelpController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 0, y: dIy + (hasNotch ? dIPrusy+20 : 20) + dy, width: Int(screenWidth), height: 40))
        text.text = "Reference".localized(code)
        text.textAlignment = .center
        text.font = UIFont(name:"BankGothicBT-Medium", size: 30.0)
        return text
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: 5, width: screenWidth/5, height: 20)
        backView.center.x = screenWidth/2
        let back = UIView()
        if isNight {
            back.backgroundColor = .white
        } else {
            back.backgroundColor = .black

        }
        back.layer.cornerRadius = 2
        back.frame = CGRect(x: 8, y: 0 , width: backView.bounds.width-15, height: 4)
        back.center.y = backView.bounds.height/2
        back.center.x = backView.bounds.width/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var text: UILabel = {
        let text = UILabel()
        text.text = "Info".localized(code)
        text.textColor = UIColor(rgb: 0xE9E9E9)
        text.lineBreakMode = .byWordWrapping
        text.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        text.numberOfLines = 0
        text.frame.origin.x = 20
        text.frame.size.width = screenWidth-40
        text.sizeToFit()
        return text
    }()
    private func viewShow() {
        warning = false

        view.addSubview(themeBackView3)
        MainLabel.text = "Reference".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.dismiss(animated: true)
        }
        
        view.addSubview(bgImage)
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight+20).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let textMain = UILabel(frame: CGRect(x: headerHeight+20, y: 20, width: screenWidth-40, height: 20))
        textMain.text = "Reference".localized(code)
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.textColor = UIColor(rgb: 0xE9E9E9)
        textMain.frame.origin.x = 20

//        view.addSubview(textMain)
        let lineMain = UIView(frame: CGRect(x: headerHeight+20, y: 50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)

        scrollView.addSubview(text)
        
        scrollView.contentSize = CGSize(width: screenWidth, height: text.frame.height)
    }
        fileprivate func setupTheme() {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            text.theme.textColor = themed{ $0.navigationTintColor }
    //        hamburger.theme.tintColor = themed{ $0.navigationTintColor }
    //        backView.theme.tintColor = themed{ $0.navigationTintColor }
    //        textLineCreateLevel.theme.textColor = themed{ $0.navigationTintColor }
    //        textLineCreateRssi.theme.textColor = themed{ $0.navigationTintColor }
    //        textLineCreateVbat.theme.textColor = themed{ $0.navigationTintColor }
    //        textLineCreateID.theme.textColor = themed{ $0.navigationTintColor }
    //        textLineCreateTempText.theme.textColor = themed{ $0.navigationTintColor }
    //        textLineCreateTemp.theme.tintColor = themed{ $0.navigationTintColor }
    //        textLineCreateName.theme.textColor = themed{ $0.navigationTintColor }
    //        sensorImage.theme.tintColor = themed{ $0.navigationTintColor }
    //        bgImageSignal.theme.tintColor = themed{ $0.navigationTintColor }
    //        bgImageSignal2.theme.tintColor = themed{ $0.navigationTintColor }
    //        bgImageSignal3.theme.tintColor = themed{ $0.navigationTintColor }
    //        bgImageBattary.theme.tintColor = themed{ $0.navigationTintColor }
    //        bgImageBattary1.theme.backgroundColor = themed{ $0.navigationTintColor }
    //        bgImageBattary2.theme.backgroundColor = themed{ $0.navigationTintColor }
    //        bgImageBattary3.theme.backgroundColor = themed{ $0.navigationTintColor }

        }
}
