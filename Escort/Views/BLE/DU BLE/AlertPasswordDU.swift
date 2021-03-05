//
//  AlertPasswordDU.swift
//  Escort
//
//  Created by Володя Зверев on 18.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

extension DevicesDUController: AlertDelegate, UITextFieldDelegate {
    func buttonClose2() {
        animateOut()
//        tlVC.deviceTLVC.numberOfButton = 0
//        tlVC.blackBoxVC.numberOfButton = 0
        reload = 0
//        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
//        self.navigationController?.popToViewController(vc!, animated: true)
    }
    func forgotTapped2() {
        animateOut()
//        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
//        self.navigationController?.popToViewController(vc!, animated: true)
//        self.navigationController?.pushViewController(passwordVC, animated: true)
//        passwordVC.segmentedControl1.selectedSegmentIndex = 2
//        passwordVC.scrollView.setContentOffset(CGPoint(x: screenW * 2 - 20, y: 0), animated: false)
    }
    
    func buttonTapped2() {
        animateOut()
        reload = 9
        mainPassword = alertView.CustomTextField.text ?? ""
        alertView.CustomTextField.text = ""
        buttonTap()
//        animationSuccess()
//        if demoMode {
//            print("demo")
//            Access_Allowed = 2
//            if let viewControllers = navigationController?.viewControllers {
//                for viewController in viewControllers {
//                    if viewController.isKind(of: MeteoDataController.self) {
//                        tabBarVC.mainVC.demoData()
//                    }
//                }
//            }
//        }
//        if let viewControllers = navigationController?.viewControllers {
//            for viewController in viewControllers {
//                if viewController.isKind(of: PasswordController.self) {
//
//                }
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
//            self.navigationController?.pushViewController(TabBarController(), animated: true)
//        })
    }
    
    func setupVisualEffectView() {
        visualEffectView.effect = UIBlurEffect(style: isNight ? .light : .dark )
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func setAlert() {
        reload = -1
//        view.addSubview(alertView)
        setupVisualEffectView()
        navigationController?.view.addSubview(alertView)
        alertView.center = view.center
        alertView.set(title: "Introduce password".localized(code), body: "", buttonTitle: "Enter password".localized(code))
        //alertView.leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
    }
    
    func animateIn() {
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    func animateOut() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                       }) { (true) in
            self.alertView.removeFromSuperview()
        }    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE80000).cgColor
        textField.layer.shadowColor =  UIColor(rgb: 0xE80000).cgColor
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.shadowOpacity = 0.0
    }
}

extension DevicesDUController: AlertNewDelegate {
    func buttonClose() {
        animateOutNew()
        reload = 0
//        tlVC.deviceTLVC.numberOfButton = 0
//        tlVC.blackBoxVC.numberOfButton = 0
//        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
//        self.navigationController?.popToViewController(vc!, animated: true)
    }
    func forgotTapped() {
        animateOutNew()
//        let  vc =  self.navigationController?.viewControllers.filter({$0 is ConnectedMeteoController}).first
//        self.navigationController?.popToViewController(vc!, animated: true)
//        self.navigationController?.pushViewController(passwordVC, animated: true)
//        passwordVC.segmentedControl1.selectedSegmentIndex = 2
//        passwordVC.scrollView.setContentOffset(CGPoint(x: screenW * 2 - 20, y: 0), animated: false)
    }
    
    func buttonTapped() {
        animateOutNew()
        reload = 9
        mainPassword = alertViewNewPassword.CustomTextField.text ?? ""
        alertViewNewPassword.CustomTextField.text = ""
        alertViewNewPassword.CustomTextFieldSecond.text = ""
        buttonTap()
//        animationSuccess()
//        if demoMode {
//            print("demo")
//            Access_Allowed = 2
//            if let viewControllers = navigationController?.viewControllers {
//                for viewController in viewControllers {
//                    if viewController.isKind(of: MeteoDataController.self) {
//                        tabBarVC.mainVC.demoData()
//                    }
//                }
//            }
//        }
//        if let viewControllers = navigationController?.viewControllers {
//            for viewController in viewControllers {
//                if viewController.isKind(of: PasswordController.self) {
//
//                }
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
//            self.navigationController?.pushViewController(TabBarController(), animated: true)
//        })
    }
    
    func setupVisualEffectViewNew() {
        visualEffectView.effect = UIBlurEffect(style: isNight ? .light : .dark )
        navigationController?.view.addSubview(visualEffectView)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func setAlertNew() {
        reload = -1
//        view.addSubview(alertView)
        setupVisualEffectView()
        navigationController?.view.addSubview(alertViewNewPassword)
        alertViewNewPassword.center = view.center
        alertViewNewPassword.set(title: "Need to create a password".localized(code), body: "", buttonTitle: "Enter password".localized(code))
        //alertView.leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
    }
    
    func animateInNew() {
        alertViewNewPassword.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertViewNewPassword.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertViewNewPassword.alpha = 1
            self.alertViewNewPassword.transform = CGAffineTransform.identity
        }
    }
    func animateOutNew() {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertViewNewPassword.alpha = 0
                        self.alertViewNewPassword.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                       }) { (true) in
            self.alertViewNewPassword.removeFromSuperview()
        }
    }
}
