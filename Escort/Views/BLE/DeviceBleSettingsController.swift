//
//  DeviceBleSettingsController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

var full = "-----"
var nothing = "-----"
var cnt = "-----"
var cnt1 = "0"
var cnt2 = "2000"
var prov = ""
var prov2 = ""
var police = false

class DeviceBleSettingsController: UIViewController {
    
    let viewLoad = UIView(frame:CGRect(x: 30, y: headerHeight + 325, width: 200, height: 40))
    let viewLoadTwo = UIView(frame:CGRect(x: 30, y: headerHeight + 415, width: 300, height: 40))
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let termoSwitch = UISwitch()
    let uPicker = UIPickerView()
    let uPicker2 = UIPickerView()
    let dataSource = ["1023", "4095"]
    let dataSource2 = ["0", "1", "2","3", "4", "5", "6", "7", "8", "9", "10", "11","12", "13", "14", "15"]
    let input = UITextField()
    let input3 = UITextField()
    let input4 = UITextField()
    var iF = 0
    var check4 = UIImageView(image: UIImage(named: "check-red.png")!)
    var check3 = UIImageView(image: UIImage(named: "check-red.png")!)
    var lbl3 = UILabel()
    var lbl4 = UILabel()
    var lbl1 = UILabel()
    var lbl2 = UILabel()
    var timer = Timer()


    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        viewShow()
        uPicker.dataSource = self
        uPicker.delegate = self
        uPicker2.dataSource = self
        uPicker2.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
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
        input.placeholder = "\(enterValue)"
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
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "\(settingMain)", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)

        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        
        var y = 40 + Int(headerHeight)
        let x = 30, deltaY = 65, deltaYLite = 20
        let v2 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = "\(minLevel)"
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let check = UIImageView(image: UIImage(named: "check-green.png")!)
        check.frame = CGRect(x: x+120, y: y+4, width: 22, height: 26)
        
        input.frame = CGRect(x: 160, y: 0, width: Int(screenWidth/2-30), height: 40)
        input.text = "1"
        input.placeholder = "\(enterValue)"
        input.textColor = UIColor(rgb: 0xE9E9E9)
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.isEnabled = false
        
        
        v2.addSubview(lblTitle)
        v2.addSubview(input)
        view.addSubview(v2)
        
        uPicker.frame = CGRect(x: x+170, y: y+60, width: 100, height: 100)
//        view.addSubview(uPicker)
        
        y = y + deltaY
        let v3 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
                let lblTitle3 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
                lblTitle3.text = "\(maxLevel)"
                lblTitle3.textColor = UIColor(rgb: 0xE9E9E9)
                lblTitle3.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
                
                check3.frame = CGRect(x: x+120, y: y+4, width: 22, height: 26)
                let imputTap = UIView(frame: CGRect(x: x+160, y: y, width: Int(screenWidth/2)-30, height: 40))
                input3.frame = CGRect(x: 160, y: 0, width: Int(screenWidth/2-30), height: 40)
        print("wmMax: \(wmMax)")
        if dataSource2.contains(wmMax) {
            input3.text = "1023"
            prov = input3.text!
        } else {
            input3.text = "4095"
            prov = input3.text!
        }
                input3.placeholder = "\(enterValue)"
                input3.textColor = UIColor(rgb: 0xE9E9E9)
                input3.font = UIFont(name:"FuturaPT-Light", size: 18.0)
                input3.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
                input3.layer.borderWidth = 1.0
                input3.layer.cornerRadius = 4.0
                input3.layer.borderColor = UIColor(rgb: 0x959595).cgColor
                input3.backgroundColor = .clear
                input3.leftViewMode = .always
                input3.isEnabled = false
                
                v3.addSubview(lblTitle3)
                v3.addSubview(input3)
                view.addSubview(v3)
                view.addSubview(imputTap)
                uPicker.frame = CGRect(x: x+200, y: y-30, width: 100, height: 100)
                uPicker.tintColor = .white
                imputTap.addTapGesture {
                    self.iF = 1
                    self.uPicker2.removeFromSuperview()
                    self.view.addSubview(self.uPicker)
                    
                }
    
        y = y + deltaY
        let v4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
                let lblTitle4 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
                lblTitle4.text = "\(fitr)"
                lblTitle4.textColor = UIColor(rgb: 0xE9E9E9)
                lblTitle4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
                
                check4.frame = CGRect(x: x+120, y: y+4, width: 22, height: 26)
                let imputTap2 = UIView(frame: CGRect(x: x+160, y: y, width: Int(screenWidth/2)-30, height: 40))
                input4.frame = CGRect(x: 160, y: 0, width: Int(screenWidth/2-30), height: 40)
        let number = UInt(exactly: wmMaxInt)!
        var str = String(number, radix: 16, uppercase: false)
        if str.count == 1 {
            if str == "0" {
                input4.text = "0"
                prov2 = input4.text!
            }
            if str == "1" {
                input4.text = "1"
                prov2 = input4.text!
            }
            if str == "2" {
                input4.text = "2"
                prov2 = input4.text!
            }
            if str == "3" {
                input4.text = "3"
                prov2 = input4.text!
            }
            if str == "4" {
                input4.text = "4"
                prov2 = input4.text!
            }
            if str == "5" {
                input4.text = "5"
                prov2 = input4.text!
            }
            if str == "6" {
                input4.text = "6"
                prov2 = input4.text!
            }
            if str == "7" {
                input4.text = "7"
                prov2 = input4.text!
            }
            if str == "8" {
                input4.text = "8"
                prov2 = input4.text!
            }
            if str == "9" {
                input4.text = "9"
                prov2 = input4.text!
            }
            if str == "a" {
                input4.text = "10"
                prov2 = input4.text!
            }
            if str == "b" {
                input4.text = "11"
                prov2 = input4.text!
            }
            if str == "c" {
                input4.text = "12"
                prov2 = input4.text!
            }
            if str == "d" {
                input4.text = "13"
                prov2 = input4.text!
            }
            if str == "e" {
                input4.text = "14"
                prov2 = input4.text!
            }
            if str == "f" {
                input4.text = "15"
                prov2 = input4.text!
            }
        }
        if str.count == 2 {
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 1))
            let str1 = str.split(separator: " ")
            let strFirst = str1.first!
            let strMoreLast = str1.last!
            input3.text = "1023"
            if strFirst == "0" {
                print("strMoreFirst0: \(strFirst)")
                termoSwitch.isOn = false
            } else {
                print("strMoreFirst8: \(strFirst)")
                termoSwitch.isOn = true
            }
            if strMoreLast == "0" {
                input4.text = "0"
                prov2 = input4.text!
            }
            if strMoreLast == "1" {
                input4.text = "1"
                prov2 = input4.text!
            }
            if strMoreLast == "2" {
                input4.text = "2"
                prov2 = input4.text!
            }
            if strMoreLast == "3" {
                input4.text = "3"
                prov2 = input4.text!
            }
            if strMoreLast == "4" {
                input4.text = "4"
                prov2 = input4.text!
            }
            if strMoreLast == "5" {
                input4.text = "5"
                prov2 = input4.text!
            }
            if strMoreLast == "6" {
                input4.text = "6"
                prov2 = input4.text!
            }
            if strMoreLast == "7" {
                input4.text = "7"
                prov2 = input4.text!
            }
            if strMoreLast == "8" {
                input4.text = "8"
                prov2 = input4.text!
            }
            if strMoreLast == "9" {
                input4.text = "9"
                prov2 = input4.text!
            }
            if strMoreLast == "a" {
                input4.text = "10"
                prov2 = input4.text!
            }
            if strMoreLast == "b" {
                input4.text = "11"
                prov2 = input4.text!
            }
            if strMoreLast == "c" {
                input4.text = "12"
                prov2 = input4.text!
            }
            if strMoreLast == "d" {
                input4.text = "13"
                prov2 = input4.text!
            }
            if strMoreLast == "e" {
                input4.text = "14"
                prov2 = input4.text!
            }
            if strMoreLast == "f" {
                input4.text = "15"
                prov2 = input4.text!
            }

        }
        if str.count > 3 {
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 2))
            let str1 = str.split(separator: " ")
            let strFirst = str1.first!
            var strLast = str1.last!
            print("\(strFirst) - first; \(strLast) = last")
            if strFirst == "80" {
                input3.text = "4095"
            } else {
                input3.text = "1023"
            }
            strLast.insert(" ", at: strLast.index(strLast.startIndex, offsetBy: 1))
            let strMore = strLast.split(separator: " ")
            let strMoreFirst = strMore.first!
            let strMoreLast = strMore.last!
            if strMoreFirst == "0" {
                print("strMoreFirst0: \(strMoreFirst)")
                termoSwitch.isOn = false
            } else {
                print("strMoreFirst8: \(strMoreFirst)")
                termoSwitch.isOn = true
            }
            if strMoreLast == "0" {
                input4.text = "0"
                prov2 = input4.text!
            }
            if strMoreLast == "1" {
                input4.text = "1"
                prov2 = input4.text!
            }
            if strMoreLast == "2" {
                input4.text = "2"
                prov2 = input4.text!
            }
            if strMoreLast == "3" {
                input4.text = "3"
                prov2 = input4.text!
            }
            if strMoreLast == "4" {
                input4.text = "4"
                prov2 = input4.text!
            }
            if strMoreLast == "5" {
                input4.text = "5"
                prov2 = input4.text!
            }
            if strMoreLast == "6" {
                input4.text = "6"
                prov2 = input4.text!
            }
            if strMoreLast == "7" {
                input4.text = "7"
                prov2 = input4.text!
            }
            if strMoreLast == "8" {
                input4.text = "8"
                prov2 = input4.text!
            }
            if strMoreLast == "9" {
                input4.text = "9"
                prov2 = input4.text!
            }
            if strMoreLast == "a" {
                input4.text = "10"
                prov2 = input4.text!
            }
            if strMoreLast == "b" {
                input4.text = "11"
                prov2 = input4.text!
            }
            if strMoreLast == "c" {
                input4.text = "12"
                prov2 = input4.text!
            }
            if strMoreLast == "d" {
                input4.text = "13"
                prov2 = input4.text!
            }
            if strMoreLast == "e" {
                input4.text = "14"
                prov2 = input4.text!
            }
            if strMoreLast == "f" {
                input4.text = "15"
                prov2 = input4.text!
            }
            
        }
        print(str)
//        if wmMax == "32768" || wmMax == "0"{
//            input4.text = "0"
//            prov2 = input4.text!
//        }
//        if wmMax == "32769" || wmMax == "1" {
//            input4.text = "1"
//            prov2 = input4.text!
//        }
//        if wmMax == "32770" || wmMax == "2"{
//            input4.text = "2"
//            prov2 = input4.text!
//        }
//        if wmMax == "32771" || wmMax == "3" {
//            input4.text = "3"
//            prov2 = input4.text!
//        }
//        if wmMax == "32772" || wmMax == "4" {
//            input4.text = "4"
//            prov2 = input4.text!
//        }
//        if wmMax == "32773" || wmMax == "5" {
//            input4.text = "5"
//            prov2 = input4.text!
//        }
//        if wmMax == "32774" || wmMax == "6" {
//            input4.text = "6"
//            prov2 = input4.text!
//        }
//        if wmMax == "32775" || wmMax == "7" {
//            input4.text = "7"
//            prov2 = input4.text!
//        }
//        if wmMax == "32776" || wmMax == "8" {
//            input4.text = "8"
//            prov2 = input4.text!
//        }
//        if wmMax == "32777" || wmMax == "9" {
//            input4.text = "9"
//            prov2 = input4.text!
//        }
//        if wmMax == "32778" || wmMax == "10" {
//            input4.text = "10"
//            prov2 = input4.text!
//        }
//        if wmMax == "32779" || wmMax == "11" {
//            input4.text = "11"
//            prov2 = input4.text!
//        }
//        if wmMax == "32780"  || wmMax == "12"{
//            input4.text = "12"
//            prov2 = input4.text!
//        }
//        if wmMax == "32781" || wmMax == "13" {
//            input4.text = "13"
//            prov2 = input4.text!
//        }
//        if wmMax == "32782"  || wmMax == "14"{
//            input4.text = "14"
//            prov2 = input4.text!
//        }
//        if wmMax == "32783" || wmMax == "15" {
//            input4.text = "15"
//            prov2 = input4.text!
//        }
                input4.placeholder = "\(enterValue)"
                input4.textColor = UIColor(rgb: 0xE9E9E9)
                input4.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input4.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input4.layer.borderWidth = 1.0
        input4.layer.cornerRadius = 4.0
        input4.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input4.backgroundColor = .clear
        input4.leftViewMode = .always
        input4.isEnabled = false
        
        v4.addSubview(lblTitle4)
        v4.addSubview(input4)
        view.addSubview(v4)
        view.addSubview(imputTap2)
        uPicker2.frame = CGRect(x: x+200, y: y-30, width: 100, height: 100)
        imputTap2.addTapGesture {
            self.iF = 2
            self.uPicker.removeFromSuperview()
            self.view.addSubview(self.uPicker2)
        }
        view.addTapGesture {
            self.uPicker.removeFromSuperview()
            self.uPicker2.removeFromSuperview()
        }
        y = y + deltaY
        
        let btn1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1.layer.cornerRadius = 22
        
        let btn1Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1Text.text = "\(paramDevice)"
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        y = y + deltaY
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        
        view.addSubview(btn1)
        view.addSubview(btn1Text)
        view.addSubview(separator)
        
        
        btn1.addTapGesture {
            if passwordHave == true {
                if passwordSuccess == true {
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    self.viewLoad.removeFromSuperview()
                    self.viewLoadTwo.removeFromSuperview()
                    self.lbl1.removeFromSuperview()
                    self.lbl2.removeFromSuperview()
                    self.lbl3.removeFromSuperview()
                    self.lbl4.removeFromSuperview()
                    let b = (self.input4.text! as NSString).integerValue
                    reload = 6
                    if self.input3.text == "1023" {
                        if self.termoSwitch.isOn == false{
                            wmPar = "\(b)"
                        } else {
                            let a = 128 + b
                            wmPar = "\(a)"
                        }
                    }
                    if self.input3.text == "4095" {
                        if self.termoSwitch.isOn == false{
                            let a = 32768 + b
                            wmPar = "\(a)"
                        } else {
                            let a = 32896 + b
                            wmPar = "\(a)"
                        }
                    }
                    self.viewLoad.isHidden = true
                    self.viewLoadTwo.isHidden = true
                    
                    //            self.view.addSubview(check)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.check4.image = UIImage(named: "check-green.png")
                        self.check3.image = UIImage(named: "check-green.png")
                        //                check.image = UIImage(named: "check-green.png")
                        //                self.view.addSubview(check)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                        self.check4.removeFromSuperview()
                        self.check3.removeFromSuperview()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            police = false
                            self.viewLoad.removeFromSuperview()
                            self.viewLoadTwo.removeFromSuperview()
                            self.lbl1.removeFromSuperview()
                            self.lbl2.removeFromSuperview()
                            self.lbl3.removeFromSuperview()
                            self.lbl4.removeFromSuperview()
                            self.viewShow()
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            //                    self.viewAlpha.removeFromSuperview()
                            //                    self.view.isUserInteractionEnabled = true
                        }
                        //                check.removeFromSuperview()
                        
                    }
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "Устройство запароленно", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            } else  {
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                self.viewLoad.removeFromSuperview()
                self.viewLoadTwo.removeFromSuperview()
                self.lbl1.removeFromSuperview()
                self.lbl2.removeFromSuperview()
                self.lbl3.removeFromSuperview()
                self.lbl4.removeFromSuperview()
                let b = (self.input4.text! as NSString).integerValue
                reload = 6
                if self.input3.text == "1023" {
                    if self.termoSwitch.isOn == false{
                        wmPar = "\(b)"
                    } else {
                        let a = 128 + b
                        wmPar = "\(a)"
                    }
                }
                if self.input3.text == "4095" {
                    if self.termoSwitch.isOn == false{
                        let a = 32768 + b
                        wmPar = "\(a)"
                    } else {
                        let a = 32896 + b
                        wmPar = "\(a)"
                    }
                }
                self.viewLoad.isHidden = true
                self.viewLoadTwo.isHidden = true
                
                //            self.view.addSubview(check)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.check4.image = UIImage(named: "check-green.png")
                    self.check3.image = UIImage(named: "check-green.png")
                    //                check.image = UIImage(named: "check-green.png")
                    //                self.view.addSubview(check)
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                    self.check4.removeFromSuperview()
                    self.check3.removeFromSuperview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        police = false
                        self.viewLoad.removeFromSuperview()
                        self.viewLoadTwo.removeFromSuperview()
                        self.lbl1.removeFromSuperview()
                        self.lbl2.removeFromSuperview()
                        self.lbl3.removeFromSuperview()
                        self.lbl4.removeFromSuperview()
                        self.viewShow()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        //                    self.viewAlpha.removeFromSuperview()
                        //                    self.view.isUserInteractionEnabled = true
                    }
                    //                check.removeFromSuperview()
                    
                }
            }
        }

        y = y + deltaYLite
        
        lbl1 = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        lbl1.text = "\(nothing)"
        lbl1.textColor = UIColor(rgb: 0xE9E9E9)
        lbl1.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        lbl2 = UILabel(frame: CGRect(x: Int(screenWidth-170), y: 0, width: 120, height: 20))
        lbl2.text = "\(full)"
        lbl2.textColor = UIColor(rgb: 0xE9E9E9)
        lbl2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        

        
        y = y + deltaYLite + deltaYLite/2
        
        let btn2 = UIView(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn2.backgroundColor = UIColor(rgb: 0xCF2121)
        btn2.layer.cornerRadius = 22
        
        let btn2Text = UILabel(frame: CGRect(x: x, y: y, width: 120, height: 44))
        btn2Text.text = "\(setNothing)"
        btn2Text.textColor = .white
        btn2Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn2Text.textAlignment = .center
        
        view.addSubview(btn2)
        view.addSubview(btn2Text)
        
        let btn3 = UIView(frame: CGRect(x: Int(screenWidth-150), y: y, width: 120, height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        btn3.layer.cornerRadius = 22
        
        let btn3Text = UILabel(frame: CGRect(x: Int(screenWidth-150), y: y, width: 120, height: 44))
        btn3Text.text = "\(setFull)"
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        
        view.addSubview(btn3)
        view.addSubview(btn3Text)
        
        btn2.addTapGesture {
            reload = 3
            if passwordHave == true {
                if passwordSuccess == true {
                    errorWRN = false
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    self.viewLoad.isHidden = true
                    self.viewLoadTwo.isHidden = true
                    self.viewLoad.removeFromSuperview()
                    self.lbl1.removeFromSuperview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                        if errorWRN == false {
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            self.viewAlpha.removeFromSuperview()
                            self.viewLoad.isHidden = false
                            self.viewLoadTwo.isHidden = false
                            let alert = UIAlertController(title: "\(valueYes)", message: "\(nothingIfYes)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            errorWRN = false
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            self.viewAlpha.removeFromSuperview()
                            self.viewLoad.isHidden = false
                            self.viewLoadTwo.isHidden = false
                            let alert = UIAlertController(title: "\(valueNo)", message: "\(nothingIfNo)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                }}))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "Устройство запароленно", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                errorWRN = false
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                self.viewLoad.isHidden = true
                self.viewLoadTwo.isHidden = true
                self.viewLoad.removeFromSuperview()
                self.lbl1.removeFromSuperview()
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                    if errorWRN == false {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "\(valueYes)", message: "\(nothingIfYes)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        errorWRN = false
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "\(valueNo)", message: "\(nothingIfNo)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
        }
        btn3.addTapGesture {
            reload = 2
            if passwordHave == true {
                if passwordSuccess == true {
                    errorWRN = false
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    self.viewLoad.isHidden = true
                    self.viewLoadTwo.isHidden = true
                    self.viewLoad.removeFromSuperview()
                    self.lbl2.removeFromSuperview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                        if errorWRN == false {
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            self.viewAlpha.removeFromSuperview()
                            self.viewLoad.isHidden = false
                            self.viewLoadTwo.isHidden = false
                            let alert = UIAlertController(title: "\(valueYes)", message: "\(fullIfYes)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            errorWRN = false
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            self.viewAlpha.removeFromSuperview()
                            self.viewLoad.isHidden = false
                            self.viewLoadTwo.isHidden = false
                            let alert = UIAlertController(title: "\(valueNo)", message: "\(fullIfNo)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "Устройство запароленно", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                errorWRN = false
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                self.viewLoad.isHidden = true
                self.viewLoadTwo.isHidden = true
                self.viewLoad.removeFromSuperview()
                self.lbl2.removeFromSuperview()
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                    if errorWRN == false {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "\(valueYes)", message: "\(fullIfYes)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        errorWRN = false
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "\(valueNo)", message: "\(fullIfNo)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        y = y + deltaY
        
        lbl3 = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: 20))
        lbl3.text = "CNT          \(cnt)"
        lbl3.textColor = UIColor(rgb: 0xE9E9E9)
        lbl3.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        lbl4 = UILabel(frame: CGRect(x: Int(screenWidth/2+20), y: 0, width: Int(screenWidth/3), height: 20))
        lbl4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
//        lbl4.textAlignment = .right
        y = y + deltaY
        let separatorTwo = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separatorTwo.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(separatorTwo)
        
        let termoLabel = UILabel(frame: CGRect(x: x, y: y+35, width: Int(screenWidth/2 + 70), height: 20))
        termoLabel.text = "\(termocompetition)"
        termoLabel.textColor = UIColor(rgb: 0xE9E9E9)
        view.addSubview(termoLabel)
        
        termoSwitch.frame = CGRect(x: Int(screenWidth/2+110), y: y+32, width: 30, height: 20)
        termoSwitch.thumbTintColor = UIColor(rgb: 0xFFFFFF)
        termoSwitch.onTintColor = UIColor(rgb: 0xCF2121)

        view.addSubview(termoSwitch)
        
        let viewTermoSwitch = UIView(frame: CGRect(x: Int(screenWidth/2+110), y: y+32, width: 60, height: 40))
        viewTermoSwitch.backgroundColor = .clear
        view.addSubview(viewTermoSwitch)

        viewTermoSwitch.addTapGesture {
            if passwordHave == true {
                if passwordSuccess == true {
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    self.viewLoad.removeFromSuperview()
                    self.viewLoadTwo.removeFromSuperview()
                    self.lbl1.removeFromSuperview()
                    self.lbl2.removeFromSuperview()
                    self.lbl3.removeFromSuperview()
                    self.lbl4.removeFromSuperview()
                    let b = (self.input4.text! as NSString).integerValue
                    reload = 6
                    if self.input3.text == "1023" {
                        if self.termoSwitch.isOn == true{
                            wmPar = "\(b)"
                        } else {
                            let a = 128 + b
                            wmPar = "\(a)"
                        }
                    }
                    if self.input3.text == "4095" {
                        if self.termoSwitch.isOn == true{
                            let a = 32768 + b
                            wmPar = "\(a)"
                        } else {
                            let a = 32896 + b
                            wmPar = "\(a)"
                        }
                    }
                    self.viewLoad.isHidden = true
                    self.viewLoadTwo.isHidden = true
                    
                    //            self.view.addSubview(check)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.check4.image = UIImage(named: "check-green.png")
                        self.check3.image = UIImage(named: "check-green.png")
                        //                check.image = UIImage(named: "check-green.png")
                        //                self.view.addSubview(check)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                        self.check4.removeFromSuperview()
                        self.check3.removeFromSuperview()
                        if self.termoSwitch.isOn == true {
                            self.termoSwitch.isOn = false
                        } else {
                            self.termoSwitch.isOn = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            police = false
                            self.viewLoad.removeFromSuperview()
                            self.viewLoadTwo.removeFromSuperview()
                            self.lbl1.removeFromSuperview()
                            self.lbl2.removeFromSuperview()
                            self.lbl3.removeFromSuperview()
                            self.lbl4.removeFromSuperview()
                            self.viewShow()
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            //                    self.viewAlpha.removeFromSuperview()
                            //                    self.view.isUserInteractionEnabled = true
                        }
                        //                check.removeFromSuperview()
                        
                    }
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "Устройство запароленно", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            } else  {
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                self.viewLoad.removeFromSuperview()
                self.viewLoadTwo.removeFromSuperview()
                self.lbl1.removeFromSuperview()
                self.lbl2.removeFromSuperview()
                self.lbl3.removeFromSuperview()
                self.lbl4.removeFromSuperview()
                let b = (self.input4.text! as NSString).integerValue
                reload = 6
                if self.input3.text == "1023" {
                    if self.termoSwitch.isOn == true{
                        wmPar = "\(b)"
                    } else {
                        let a = 128 + b
                        wmPar = "\(a)"
                    }
                }
                if self.input3.text == "4095" {
                    if self.termoSwitch.isOn == true {
                        let a = 32768 + b
                        wmPar = "\(a)"
                    } else {
                        let a = 32896 + b
                        wmPar = "\(a)"
                    }
                }
                self.viewLoad.isHidden = true
                self.viewLoadTwo.isHidden = true
                
                //            self.view.addSubview(check)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.check4.image = UIImage(named: "check-green.png")
                    self.check3.image = UIImage(named: "check-green.png")
                    //                check.image = UIImage(named: "check-green.png")
                    //                self.view.addSubview(check)
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                    self.check4.removeFromSuperview()
                    self.check3.removeFromSuperview()
                    if self.termoSwitch.isOn == true {
                        self.termoSwitch.isOn = false
                    } else {
                        self.termoSwitch.isOn = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        police = false
                        self.viewLoad.removeFromSuperview()
                        self.viewLoadTwo.removeFromSuperview()
                        self.lbl1.removeFromSuperview()
                        self.lbl2.removeFromSuperview()
                        self.lbl3.removeFromSuperview()
                        self.lbl4.removeFromSuperview()
                        self.viewShow()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        //                    self.viewAlpha.removeFromSuperview()
                        //                    self.view.isUserInteractionEnabled = true
                    }
                    //                check.removeFromSuperview()
                    
                }
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        activityIndicator.startAnimating()
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.viewAlpha.removeFromSuperview()
            self.viewLoad.isHidden = false
            self.viewLoadTwo.isHidden = false
            police = true
        }
    }
    
    @objc func timerAction(){
        viewShowParametrs(lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4, y: Int(headerHeight + 415))
    }
    


    func viewShowParametrs(lbl1: UILabel,lbl2: UILabel,lbl3: UILabel, lbl4: UILabel, y: Int) {
        lbl3.text = "CNT          \(cnt)"
        lbl1.text = "\(nothing)"
        lbl2.text = "\(full)"
        lbl4.text = "\(statusDeviceY)"
        if itemColor == 0 {
            lbl4.textColor = UIColor(rgb: 0xCF2121)
        } else {
            lbl4.textColor = UIColor(rgb: 0x00A778)
        }
        viewLoad.removeFromSuperview()
        viewLoadTwo.removeFromSuperview()
        if police == false {
            viewLoad.isHidden = true
            viewLoadTwo.isHidden = true
        }
        view.addSubview(viewLoad)
        view.addSubview(viewLoadTwo)
        viewLoad.addSubview(lbl1)
        viewLoad.addSubview(lbl2)
        viewLoadTwo.addSubview(lbl3)
        viewLoadTwo.addSubview(lbl4)

    }
}

extension DeviceBleSettingsController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if iF == 2 {
        return dataSource2.count
        } else {
        return dataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if iF == 2 {
            input4.text = dataSource2[row]
            if prov2 != self.input4.text {
                check4.image = UIImage(named: "check-red.png")
                self.view.addSubview(check4)
            } else {
                    check4.removeFromSuperview()
            }
            uPicker2.removeFromSuperview()
        } else {
            input3.text = dataSource[row]
            if prov != self.input3.text {
                check3.image = UIImage(named: "check-red.png")
                self.view.addSubview(check3)
            } else {
                check3.removeFromSuperview()
            }
            uPicker.removeFromSuperview()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if iF == 2 {
            return dataSource2[row]

        } else {
            return dataSource[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if iF == 2 {
            let dt2 = dataSource2[row]
            return NSAttributedString(string: dt2, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            let dt = dataSource[row]
            return NSAttributedString(string: dt, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        }
    }
}
