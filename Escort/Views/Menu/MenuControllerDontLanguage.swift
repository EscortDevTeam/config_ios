//
//  MenuControllerDontLanguage.swift
//  Escort
//
//  Created by Володя Зверев on 06.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer

class MenuControllerDontLanguage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
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
        return img
    }()
    
    private func viewShow() {
        warning = false
        
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        view.addSubview(bgImage)
        let textMain = UILabel(frame: CGRect(x: 20, y: 20, width: screenWidth-40, height: 20))
        textMain.center.x = view.center.x
        textMain.textAlignment = .center
        textMain.text = "Menu".localized(code)
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.textColor = UIColor(rgb: 0xE9E9E9)
        textMain.frame.origin.x = 20
        
        view.addSubview(textMain)
        let lineMain = UIView(frame: CGRect(x: 20, y: 50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)
        lineMain.center.x = view.center.x
        view.addSubview(lineMain)
        
        let aboutApp = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutApp.center.x = view.center.x
        aboutApp.textAlignment = .center
        
        let aboutAppView = UIView(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutAppView.backgroundColor = .clear
        aboutAppView.center.x = view.center.x
        aboutApp.text = "About the program".localized(code)
        aboutApp.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp.textColor = .white
        let redLineApp = UIView(frame: CGRect(x: 0, y: 45, width: 200, height: 2))
        redLineApp.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(aboutApp)
        view.addSubview(aboutAppView)
        aboutAppView.addTapGesture {
            let viewController = SettingAppController()
            self.present(viewController, animated: true)
        }
        
        let aboutApp2 = UILabel(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        aboutApp2.center.x = view.center.x
        aboutApp2.textAlignment = .center
        
        let aboutAppView2 = UIView(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        aboutAppView2.backgroundColor = .clear
        aboutAppView2.center.x = view.center.x
        aboutApp2.text = "Tech support".localized(code)
        aboutApp2.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp2.textColor = .white
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
        let aboutApp4 = UILabel(frame: CGRect(x: 0, y: 170, width: 300, height: 45))
        aboutApp4.center.x = view.center.x
        aboutApp4.textAlignment = .center
        
        let aboutAppView4 = UIView(frame: CGRect(x: 0, y: 170, width: 300, height: 45))
        aboutAppView4.backgroundColor = .clear
        aboutAppView4.center.x = view.center.x
        aboutApp4.text = "Reference".localized(code)
        aboutApp4.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp4.textColor = .white
        view.addSubview(aboutApp4)
        view.addSubview(aboutAppView4)
        
        aboutAppView4.addTapGesture {
            let viewController = DeviceBleHelpController()
            self.present(viewController, animated: true)
        }
        
        let aboutApp3 = UILabel(frame: CGRect(x: 0, y: 220, width: 300, height: 45))
        aboutApp3.center.x = view.center.x
        aboutApp3.textAlignment = .center
        
        let aboutAppView3 = UIView(frame: CGRect(x: 0, y: 220, width: 300, height: 45))
        aboutAppView3.backgroundColor = .clear
        aboutAppView3.center.x = view.center.x
        aboutApp3.text = "Language".localized(code)
        aboutApp3.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp3.textColor = .white
//        view.addSubview(aboutApp3)
//        view.addSubview(aboutAppView3)
        aboutAppView3.addTapGesture {
            let alert = UIAlertController(title: "Language".localized(code), message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "РУССКИЙ", style: .default, handler: { (_) in
                code = "ru"
                aboutApp.text = "About the program".localized(code)
                aboutApp2.text = "Tech support".localized(code)
                aboutApp3.text = "Language".localized(code)
                textMain.text = "Menu".localized(code)
                aboutApp4.text = "Reference".localized(code)
                
                checkMenu = true
                
            }))
            
            alert.addAction(UIAlertAction(title: "ENGLISH", style: .default, handler: { (_) in
                code = "en"
                aboutApp.text = "About the program".localized(code)
                aboutApp2.text = "Tech support".localized(code)
                aboutApp3.text = "Language".localized(code)
                textMain.text = "Menu".localized(code)
                aboutApp4.text = "Reference".localized(code)
                
                checkMenu = true
            }))
            
            alert.addAction(UIAlertAction(title: "PORTUGUÊS", style: .default, handler: { (_) in
                code = "pt-PT"
                aboutApp.text = "About the program".localized(code)
                aboutApp2.text = "Tech support".localized(code)
                aboutApp3.text = "Language".localized(code)
                textMain.text = "Menu".localized(code)
                aboutApp4.text = "Reference".localized(code)
                
                checkMenu = true
            }))
            alert.addAction(UIAlertAction(title: "ESPAÑOl", style: .default, handler: { (_) in
                code = "es"
                aboutApp.text = "About the program".localized(code)
                aboutApp2.text = "Tech support".localized(code)
                aboutApp3.text = "Language".localized(code)
                textMain.text = "Menu".localized(code)
                aboutApp4.text = "Reference".localized(code)
                
                checkMenu = true
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                print("Назад")
            }))
            
            self.present(alert, animated: true)
        }
    }
}
extension MenuControllerDontLanguage: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

