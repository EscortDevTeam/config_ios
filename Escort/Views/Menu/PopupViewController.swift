//
//  PopupTwoVC.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 14/08/2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    weak var delegate: SecondVCDelegate?
    
    var labelLanguage = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 60))
    var labelLanguageView = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 60))
    var labelLanguageMain = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/2))
    var strel = UIImageView(image: UIImage(named: "strel.png")!)
    let VCMenu = UIView()
    var container = UIView()
    var closeMenu = UIImageView(image: UIImage(named: "closeMenu.png")!)
//    let DeviceSelectCUSB = DeviceSelectControllerUSB()
//    let DeviceSelectC = DeviceSelectController()
    var parsedData:[String : AnyObject] = [:]

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        delegate?.secondVC_BackClicked(data: "\(code)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        moveIn()
//        updateLangues()
    }
    override func viewDidAppear(_ animated: Bool) {
        moveIn()
        menuLoad()
    }

    func menuLoad() {
        let containerApp = UIView(frame: CGRect(x: Int(screenWidth-270), y: Int(screenHeight/2-190), width: 300, height: 280))
        let aboutApp = UILabel(frame: CGRect(x: 0, y: 5, width: 300, height: 30))
        let aboutAppView = UIView(frame: CGRect(x: 0, y: 5, width: 250, height: 40))
        aboutAppView.backgroundColor = .clear
        aboutApp.text = "About the program".localized(code)
        aboutApp.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp.textColor = .black
        let redLineApp = UIView(frame: CGRect(x: 0, y: 45, width: 200, height: 2))
        redLineApp.backgroundColor = UIColor(rgb: 0xCF2121)
        containerApp.addSubview(aboutApp)
        containerApp.addSubview(aboutAppView)
        containerApp.addSubview(redLineApp)
        view.addSubview(containerApp)
        
        let cellHeight = 70
        var y = 10
        VCMenu.removeFromSuperview()
        VCMenu.frame = CGRect(x: 0, y: 0, width: 0, height: screenHeight)
        container = UIView(frame: CGRect(x: Int(screenWidth-270), y: Int(screenHeight/2-100), width: Int(screenWidth - 40), height: 280))
        var withLine = 123
        for (i, i2) in menuSideNext.enumerated() {
            if i2.name == "Language"{
                withLine = 180
            }
            if i2.name == "Язык"{
                withLine = 123
            }
            strel.frame = CGRect(x: Int(screenWidth-60), y: y + Int(screenHeight/2-115), width: 39, height: 12)
//            self.view.addSubview(strel)
            var yHamb = screenHeight/22
            
            if screenHeight >= 750{
                yHamb = screenHeight/18
            }
            closeMenu.frame = CGRect(x: screenWidth-50, y: yHamb, width: 30, height: 30)
            self.view.addSubview(closeMenu)
            
            if i2.name == "USB"{
                withLine = withLine / 2
            }
            
            let title = UILabel(frame: CGRect(x: 0, y: y - 40, width: Int(screenWidth/2+40), height: 60))
            let titleTap = UILabel(frame: CGRect(x: Int(screenWidth/2-80), y: y + Int(screenHeight/2-140), width: Int(screenWidth/2+80), height: 60))
            let redLine = UIView(frame: CGRect(x: 0, y: y + 15, width: withLine, height: 2))
            closeMenu.addTapGesture {
                self.moveOut()
                for (_,j2) in menuSideNext.enumerated() {
                    print(j2)
                    title.removeFromSuperview()
                }
                self.strel.removeFromSuperview()
                aboutAppView.removeFromSuperview()
                aboutApp.removeFromSuperview()
                redLineApp.removeFromSuperview()
                self.labelLanguageMain.removeFromSuperview()
                self.container.removeFromSuperview()
                self.strel.image = UIImage(named: "strel.png")
            }
            
            aboutAppView.addTapGesture {
                if let navController = self.navigationController {
                    for (_,j2) in menuSideNext.enumerated() {
                        print(j2)
                        title.removeFromSuperview()
                    }
                    aboutAppView.removeFromSuperview()
                    aboutApp.removeFromSuperview()
                    redLineApp.removeFromSuperview()
                    self.strel.removeFromSuperview()
                    self.strel.image = UIImage(named: "strel.png")
                    self.labelLanguageMain.removeFromSuperview()
                    self.container.removeFromSuperview()
                    navController.pushViewController(SettingAppController(), animated: true)
                }
            }
            redLine.backgroundColor = UIColor(rgb: 0xCF2121)
            title.text = i2.name
            title.textColor = .black
            title.font = UIFont(name:"FuturaPT-Light", size: 36.0)
            if i == 2 {
                title.text = "Language".localized(code)
            }
            container.addSubview(title)
            container.addSubview(redLine)
            view.addSubview(titleTap)
            
            VCMenu.addSubview(container)
            view.addSubview(VCMenu)
            titleTap.addTapGesture {
                print("I: \(i2), \(i)")
                if i == 0 {
                    boolBLE = true
                }
                if i == 1 {
                    boolBLE = false
                }
                if i == 2 {
                    if self.strel.image == UIImage(named: "strel.png"){
                        y = 200
                        title.font = UIFont(name:"FuturaPT-Medium", size: 36.0)
                        self.strel.image = UIImage(named: "strela2.png")
                        for (_,j2) in languages.enumerated() {
                            self.labelLanguage = UILabel(frame: CGRect(x: Int(screenWidth/2)-50, y: y + Int(screenHeight/2-140), width: Int(screenWidth/2), height: 60))
                            self.labelLanguageView = UILabel(frame: CGRect(x: Int(screenWidth/2)-70, y: y + Int(screenHeight/2-140), width: Int(screenWidth/2+50), height: 60))
                            self.labelLanguage.text = j2.name
                            self.labelLanguage.textColor = .black
                            self.labelLanguage.font = UIFont(name:"FuturaPT-Light", size: 24.0)
                            self.labelLanguageMain.addSubview(self.labelLanguage)
                            self.view.addSubview(self.labelLanguageMain)
                            self.view.addSubview(self.labelLanguageView)
                            if title.font == UIFont(name:"FuturaPT-Medium", size: 36.0) {
                                self.labelLanguageView.addTapGesture {
                                    print(j2)
                                    title.removeFromSuperview()
                                    self.labelLanguageMain.removeFromSuperview()
                                    title.font = UIFont(name:"FuturaPT-Light", size: 36.0)
                                    
                                    self.strel.image = UIImage(named: "strel.png")
                                    code = j2.code
                                    //                                    self.updateLangues()
                                    self.container.removeFromSuperview()
                                    for (_,j2) in menuSide.enumerated() {
                                        print(j2)
                                        title.removeFromSuperview()
                                    }
                                    self.labelLanguageMain.removeFromSuperview()
                                    self.strel.removeFromSuperview()
                                    aboutAppView.removeFromSuperview()
                                    aboutApp.removeFromSuperview()
                                    redLineApp.removeFromSuperview()
                                    self.strel.image = UIImage(named: "strel.png")
                                    self.moveOut()
                                }
                            }
                            //                            self.view.addSubview(self.labelLanguage)
                            y = y + cellHeight - 20
                        }
                    } else {
                        title.font = UIFont(name:"FuturaPT-Light", size: 36.0)
                        self.strel.image = UIImage(named: "strel.png")
                        self.labelLanguageMain.removeFromSuperview()
                        for (_,j2) in languages.enumerated() {
                            print(j2)
                            self.labelLanguageView.removeFromSuperview()
                        }
                    }
                }
                if i == 1 || i == 0 {
                    if self.navigationController != nil {
                        
                        //                        navController.pushViewController(boolBLE ? DeviceSelectController() : DeviceSelectControllerUSB() , animated: true)
                    }
                }
            }
            
            y = y + cellHeight
        }
    }
    //    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
    //            if sender.state == .ended {
    //                switch sender.direction {
    //                case .left:
    //                        print("Left")
    //                        moveOut()
    //                        rightCount -= 1
    //                default:
    //                    break
    //                }
    //        }
    //    }
    func moveIn() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.24) {
            //            self.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
            self.view.alpha = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            UIView.animate(withDuration: 0.24) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func moveOut() {
        
        UIView.animate(withDuration: 0.24) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.24, animations: {
                //                self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
                //                    self.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                self.view.alpha = 0.0
                
                
                //                self.view.alpha = 0.0
            }) { _ in
                self.view.removeFromSuperview()
            }
        }
    }
    
}

