//
//  MenuControllerDontLanguage.swift
//  Escort
//
//  Created by Володя Зверев on 06.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import RxSwift
import RxTheme

class MenuControllerDontLanguage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
        if isNight == true {
            themeSwitch.isOn = true
        }
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
        img.frame = CGRect(x: 0, y: screenHeight-300, width: 201, height: 207)
        return img
    }()
    lazy var styleBackground: UILabel = {
        let styleBackground = UILabel(frame: CGRect(x: 0, y: 220, width: 300, height: 45))
        styleBackground.center.x = view.center.x
        styleBackground.textAlignment = .center
        styleBackground.text = "Appearance".localized(code)
        styleBackground.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        styleBackground.textColor = .white
        return styleBackground
    }()
    lazy var themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.onTintColor = .lightGray
        if isNight {
            themeSwitch.thumbTintColor = UIColor(rgb: 0x1F2222)
        } else {
            themeSwitch.thumbTintColor = .white
        }
        themeSwitch.addTarget(self, action: #selector(didChangeThemeSwitchValue), for: .valueChanged)
        return themeSwitch
    }()
    
    @objc func didChangeThemeSwitchValue() {
        if themeSwitch.isOn {
            if #available(iOS 13.0, *) {
                themeService.switch(.dark)
                isNight = true
                UserDefaults.standard.set(isNight, forKey: "isNight")
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                themeSwitch.thumbTintColor = UIColor(rgb: 0x1F2222)
            } else {
                // Fallback on earlier versions
            }

        } else {
            if #available(iOS 13.0, *) {
                themeService.switch(.light)
                isNight = false
                UserDefaults.standard.set(isNight, forKey: "isNight")
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
                themeSwitch.thumbTintColor = .white
            } else {
                // Fallback on earlier versions
            }
        }
    }
    fileprivate lazy var textMain: UILabel = {
        let textMain = UILabel(frame: CGRect(x: 20, y: 20, width: screenWidth-40, height: 20))
        textMain.center.x = view.center.x
        textMain.textAlignment = .center
        textMain.text = "Menu".localized(code)
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.frame.origin.x = 20
        return textMain
    }()
    
    fileprivate lazy var aboutApp: UILabel = {
        let aboutApp = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutApp.center.x = view.center.x
        aboutApp.textAlignment = .center
        aboutApp.text = "About the program".localized(code)
        aboutApp.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp.textColor = .white
        return aboutApp
    }()
    
    fileprivate lazy var aboutApp2: UILabel = {
        let aboutApp2 = UILabel(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        aboutApp2.center.x = view.center.x
        aboutApp2.textAlignment = .center
        aboutApp2.text = "Tech support".localized(code)
        aboutApp2.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp2.textColor = .white
        return aboutApp2
    }()
    fileprivate lazy var aboutApp4: UILabel = {
        let aboutApp4 = UILabel(frame: CGRect(x: 0, y: 170, width: 300, height: 45))
        aboutApp4.center.x = view.center.x
        aboutApp4.textAlignment = .center
        aboutApp4.text = "Reference".localized(code)
        aboutApp4.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp4.textColor = .white
        return aboutApp4
    }()
    
    private func viewShow() {
        warning = false
        
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        view.addSubview(bgImage)
        textMain.text = "Menu".localized(code)
        view.addSubview(textMain)
        
        themeSwitch.frame = CGRect(x: 0, y: 230, width: 50, height: 45)
        themeSwitch.center.x = screenWidth/2+130
        view.addSubview(themeSwitch)
        
        view.addSubview(styleBackground)

        let lineMain = UIView(frame: CGRect(x: 20, y: 50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)
        lineMain.center.x = view.center.x
        view.addSubview(lineMain)

        let aboutAppView = UIView(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutAppView.backgroundColor = .clear
        aboutAppView.center.x = view.center.x

        view.addSubview(aboutApp)
        view.addSubview(aboutAppView)
        aboutAppView.addTapGesture {
            let viewController = SettingAppController()
            self.present(viewController, animated: true)
        }
        
        let aboutAppView2 = UIView(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        aboutAppView2.backgroundColor = .clear
        aboutAppView2.center.x = view.center.x

        view.addSubview(aboutApp2)
        view.addSubview(aboutAppView2)
        
        aboutAppView2.addTapGesture {
            let alert = UIAlertController(title: "Tech support".localized(code), message: "Social network".localized(code), preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Viber", style: .default, handler: { (_) in
                if let url = URL(string:"viber://chat?number=+79600464665") {
                    UIApplication.shared.open(url) { success in
                        if success {
                            print("success")
                        } else {
                            self.showToast(message: "Viber " + "app is not installed on this device".localized(code), seconds: 1)
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Telegram", style: .default, handler: { (_) in
                if let url = URL(string:"https://telegram.me/EscortSupport") {
                    UIApplication.shared.open(url) { success in
                        if success {
                            print("success")
                        } else {
                            self.showToast(message: "Telegram " + "app is not installed on this device".localized(code), seconds: 1)
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { (_) in
                if let url = URL(string:"https://api.whatsapp.com/send?phone=+79600464665") {
                    UIApplication.shared.open(url) { success in
                        if success {
                            print("success")
                        } else {
                            self.showToast(message: "WhatsApp " + "app is not installed on this device".localized(code), seconds: 1)
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                print("Назад")
            }))
            
            self.present(alert, animated: true)
        }

        let aboutAppView4 = UIView(frame: CGRect(x: 0, y: 170, width: 300, height: 45))
        aboutAppView4.backgroundColor = .clear
        aboutAppView4.center.x = view.center.x
        
        view.addSubview(aboutApp4)
        view.addSubview(aboutAppView4)
        
        aboutAppView4.addTapGesture {
            let viewController = DeviceBleHelpController()
            self.present(viewController, animated: true)
        }
        
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            textMain.theme.textColor = themed { $0.navigationTintColor }
            aboutApp.theme.textColor = themed { $0.navigationTintColor }
            aboutApp2.theme.textColor = themed { $0.navigationTintColor }
            styleBackground.theme.textColor = themed { $0.navigationTintColor }
            aboutApp4.theme.textColor = themed { $0.navigationTintColor }
        } else {
            // Fallback on earlier versions
        }
    }
}
extension MenuControllerDontLanguage: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

