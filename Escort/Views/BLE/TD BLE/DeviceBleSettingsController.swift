//
//  DeviceBleSettingsController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer

var full = "-----"
var nothing = "-----"
var cnt = "-----"
var cnt1 = "0"
var cnt2 = "2000"
var prov = ""
var prov2 = ""
var police = false

class DeviceBleSettingsController: UIViewController {
    
    let viewLoad = UIView(frame:CGRect(x: 30, y: headerHeight + 370, width: 200, height: 40))
    let viewLoadTwo = UIView(frame:CGRect(x: 30, y: headerHeight + 510, width: 300, height: 40))
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
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let validatePassword = UILabel()
    var saveAction = UIAlertAction()
    let generator = UIImpactFeedbackGenerator(style: .light)

    let firstTextFieldSecond = UITextField()
    let secondTextFieldSecond = UITextField()
    let validatePasswordSecond = UILabel()
    var saveActionSecond = UIAlertAction()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShow()
        uPicker.dataSource = self
        uPicker.delegate = self
        uPicker2.dataSource = self
        uPicker2.delegate = self
        uPicker.setValue(UIColor.black, forKey: "textColor")
        uPicker2.setValue(UIColor.red, forKey: "textColor")
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
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
        input.placeholder = "Enter value...".localized(code)
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
    fileprivate lazy var btn2: UIView =  {
        let btn2 = UIView(frame: CGRect(x: 0, y: 0, width: Int(screenWidth / 2), height: 44))
        btn2.backgroundColor = UIColor(rgb: 0xAAAAAA)
        btn2.layer.cornerRadius = 22
        return btn2
    }()
    
    fileprivate lazy var btn2Text: UILabel =  {
        let btn2Text = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth / 2), height: 44))
        btn2Text.text = "Empty".localized(code)
        btn2Text.textColor = .white
        btn2Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn2Text.textAlignment = .center
        return btn2Text
    }()
    fileprivate lazy var btn3: UIView =  {
        let btn3 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xAAAAAA)
        btn3.layer.cornerRadius = 22
        return btn3
    }()
    
    fileprivate lazy var btn3Text: UILabel =  {
        let btn3Text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        btn3Text.text = "Full".localized(code)
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        return btn3Text
    }()
    
    fileprivate lazy var btnAuto: UIView =  {
        let btnAuto = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        btnAuto.backgroundColor = UIColor(rgb: 0xCF2121)
        btnAuto.layer.cornerRadius = 22
        return btnAuto
    }()
    
    fileprivate lazy var btnAutoText: UILabel =  {
        let btnAutoText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        btnAutoText.text = "Calibrate".localized(code)
        btnAutoText.textColor = .white
        btnAutoText.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnAutoText.textAlignment = .center
        return btnAutoText
    }()
    
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
    fileprivate lazy var lblTitle: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = "Minimum level".localized(code)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    
    fileprivate lazy var lblTitle3: UILabel = {
        let lblTitle3 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle3.text = "Maximum level".localized(code)
        lblTitle3.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle3
    }()
    
    fileprivate lazy var lblTitle4: UILabel = {
        let lblTitle4 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle4.text = "Filtration".localized(code)
        lblTitle4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle4
    }()
    
    fileprivate lazy var termoLabel: UILabel = {
        let termoLabel = UILabel(frame: CGRect(x: 30, y: 130 + Int(headerHeight) + 65*7, width: Int(screenWidth/2 + 70), height: 20))
        termoLabel.text = "Disable Thermal Compensation".localized(code)
        return termoLabel
    }()
    fileprivate lazy var autoCalibLabel: UILabel = {
        let termoLabel = UILabel(frame: CGRect(x: 30, y: Int(headerHeight) + 65*7, width: Int(screenWidth/2 + 70), height: 20))
        termoLabel.text = "Calibrate without fuel".localized(code)
        return termoLabel
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
            
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    fileprivate lazy var autoCalibSwitch: UISwitch = {
        let autoCalibSwitch = UISwitch()
        autoCalibSwitch.isOn = true
        autoCalibSwitch.thumbTintColor = .lightGray
        autoCalibSwitch.onTintColor = UIColor(rgb: 0xCF2121)
        autoCalibSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
        //        v2.addTarget(self, action: #selector(onButtonClick(_:)), for: UIControl.Event.touchUpInside)

        return autoCalibSwitch
    }()
    @objc private func switchPressed(_ sender: UISwitch) {
        print(sender.isOn)
        if sender.isOn == true {
            btnAuto.backgroundColor = UIColor(rgb: 0xCF2121)
            btn2.backgroundColor = UIColor(rgb: 0xAAAAAA)
            btn3.backgroundColor = UIColor(rgb: 0xAAAAAA)
        } else {
            btnAuto.backgroundColor = UIColor(rgb: 0xAAAAAA)
            btn2.backgroundColor = UIColor(rgb: 0xCF2121)
            btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        }
    }
    
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-70), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
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
    fileprivate func changeTermoSwitch() {
        if passwordHave == true {
            if passwordSuccess == true {
                police = false
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
                        police = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        //                            self.viewShow()
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        //                    self.viewAlpha.removeFromSuperview()
                        //                    self.view.isUserInteractionEnabled = true
                    }
                    //                check.removeFromSuperview()
                    
                }
            } else {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Enter password to continue".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        } else  {
            police = false
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
                    police = true
                    self.viewAlpha.removeFromSuperview()
                    self.viewLoad.isHidden = false
                    self.viewLoadTwo.isHidden = false
                    //                            self.viewShow()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    //                    self.viewAlpha.removeFromSuperview()
                    //                    self.view.isUserInteractionEnabled = true
                }
                //                check.removeFromSuperview()
                
            }
        }
    }
    
    fileprivate func changeBtn3() {
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
                        let alert = UIAlertController(title: "Value changed – calibration is done successfully".localized(code), message: "“Full” value changed successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        errorWRN = false
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "“Full” value changing failure".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Enter password to continue".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
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
                    let alert = UIAlertController(title: "Value changed – calibration is done successfully".localized(code), message: "“Full” value changed successfully".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    errorWRN = false
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.viewLoad.isHidden = false
                    self.viewLoadTwo.isHidden = false
                    let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "“Full” value changing failure".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func changeBtn2() {
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
                        let alert = UIAlertController(title: "Value changed – calibration is done successfully".localized(code), message: "“Empty” value changed successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        errorWRN = false
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "“Empty” value changing failure".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            } else {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Enter password to continue".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
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
                    let alert = UIAlertController(title: "Value changed – calibration is done successfully".localized(code), message: "“Empty” value changed successfully".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    errorWRN = false
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.viewLoad.isHidden = false
                    self.viewLoadTwo.isHidden = false
                    let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "“Empty” value changing failure".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    fileprivate func changeBntAuto() {
        if let tempInt = Int(temp ?? "-1"), let cntInt = Int(cnt) {
            let emptyAuto = cntInt - temperKoef * tempInt + 100
            nothing = "\(emptyAuto)"
            var fullAuto = 2 * (cntInt - 9770) + 9770
            fullAuto = fullAuto - tempInt * (temperKoef - cntInt / (2 * 1200))
            full = "\(fullAuto)"
            reload = 10
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
                            let alert = UIAlertController(title: "Success".localized(code), message: "Value changed – calibration is done successfully".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            errorWRN = false
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            self.viewAlpha.removeFromSuperview()
                            self.viewLoad.isHidden = false
                            self.viewLoadTwo.isHidden = false
                            let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "Error".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Warning".localized(code), message: "Enter password to continue".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
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
                        let alert = UIAlertController(title: "Success".localized(code), message: "Value changed – calibration is done successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        errorWRN = false
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        let alert = UIAlertController(title: "Value not changed – calibration failure".localized(code), message: "Error".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            self.showToast(message: "Попробуйте снова", seconds: 1.0)
        }
    }
    
    fileprivate func changeBnt1() {
        if passwordHave == true {
            if passwordSuccess == true {
                police = false
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
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
                        police = true
                        self.viewAlpha.removeFromSuperview()
                        self.viewLoad.isHidden = false
                        self.viewLoadTwo.isHidden = false
                        //                            self.viewShow()
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        //                    self.viewAlpha.removeFromSuperview()
                        //                    self.view.isUserInteractionEnabled = true
                    }
                    //                check.removeFromSuperview()
                    
                }
            } else {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Enter password to continue".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        } else  {
            police = false
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
                    police = true
                    self.viewAlpha.removeFromSuperview()
                    self.viewLoad.isHidden = false
                    self.viewLoadTwo.isHidden = false
                    //                            self.viewShow()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    //                    self.viewAlpha.removeFromSuperview()
                    //                    self.view.isUserInteractionEnabled = true
                }
                //                check.removeFromSuperview()
                
            }
        }
    }
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.addSubview(scrollView)

        view.addSubview(themeBackView3)
        MainLabel.text = "TD BLE Settings".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight+100))
        
        var y = 40 + Int(headerHeight)
        let x = 30, deltaY = 65, deltaYLite = 20
        let v2 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))

        
        let check = UIImageView(image: UIImage(named: "check-green.png")!)
        check.frame = CGRect(x: x+120, y: y+4, width: 22, height: 26)
        
        input.frame = CGRect(x: 160, y: 0, width: Int(screenWidth/2-30), height: 40)
        input.text = "1"
        input.placeholder = "Enter value...".localized(code)
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
        scrollView.addSubview(v2)
        
        uPicker.frame = CGRect(x: x+170, y: y+60, width: 100, height: 100)
//        view.addSubview(uPicker)
        
        y = y + deltaY
        let v3 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))

                
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
                input3.placeholder = "Enter value...".localized(code)
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
                scrollView.addSubview(v3)
                scrollView.addSubview(imputTap)
                uPicker.frame = CGRect(x: x+200, y: y-30, width: 100, height: 100)
                uPicker.tintColor = .white
                imputTap.addTapGesture {
                    self.iF = 1
                    self.uPicker2.removeFromSuperview()
                    self.scrollView.addSubview(self.uPicker)
                    
                }
    
        y = y + deltaY
        let v4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
                
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
        input4.placeholder = "Enter value...".localized(code)
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
        scrollView.addSubview(v4)
        scrollView.addSubview(imputTap2)
        uPicker2.frame = CGRect(x: x+200, y: y-30, width: 100, height: 100)
        imputTap2.addTapGesture {
            self.iF = 2
            self.uPicker.removeFromSuperview()
            self.scrollView.addSubview(self.uPicker2)
        }
        scrollView.addTapGesture {
            self.uPicker.removeFromSuperview()
            self.uPicker2.removeFromSuperview()
        }
        y = y + deltaY
        
        let btn1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1.layer.cornerRadius = 22
        
        let btn1Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1Text.text = "Write parameters to the device".localized(code)
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        y = y + deltaY
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        
        scrollView.addSubview(btn1)
        scrollView.addSubview(btn1Text)
        scrollView.addSubview(separator)
        
        
        btn1.addTapGesture {
            let alert = UIAlertController(title: "Warning".localized(code), message: "Are you sure you want to make changes?".localized(code), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                          style: .destructive,
                                          handler: {(_: UIAlertAction!) in
                                            self.changeBnt1()
            }))
            self.present(alert, animated: true, completion: nil)
        }

        autoCalibSwitch.frame = CGRect(x: Int(screenWidth / 2 + 110) - (iphone5s ? 10 : 0), y: y + 25, width: 30, height: 20)
        autoCalibLabel.frame.origin = CGPoint(x: 30, y: y + 32)

        scrollView.addSubview(autoCalibLabel)
        scrollView.addSubview(autoCalibSwitch)
        y = y + deltaY
        
        lbl1 = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        lbl1.text = "\(nothing)"
        lbl1.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        lbl2 = UILabel(frame: CGRect(x: Int(screenWidth-170), y: 0, width: 120, height: 20))
        lbl2.text = "\(full)"
        lbl2.textColor = UIColor(rgb: 0xE9E9E9)
        lbl2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        

        
        y = y + deltaYLite + deltaYLite/2
        
        btn2.frame = CGRect(x: x, y: y, width: Int(screenWidth / 2) - x - (x / 2), height: 44)

        
        btn2Text.frame = CGRect(x: x, y: y, width: Int(screenWidth / 2) - x, height: 44)
        
        scrollView.addSubview(btn2)
        scrollView.addSubview(btn2Text)
        
        btn3.frame = CGRect(x: Int(screenWidth / 2) + (x / 2), y: y, width: Int(screenWidth / 2) - x - (x / 2), height: 44)

        
        btn3Text.frame =  CGRect(x: Int(screenWidth / 2) + (x / 2), y: y, width: Int(screenWidth / 2) - x - (x / 2), height: 44)
        
        scrollView.addSubview(btn3)
        scrollView.addSubview(btn3Text)
        
        y = y + deltaYLite * 3
        
        btnAuto.frame = CGRect(x: x, y: y, width: Int(screenWidth) - (2 * x), height: 44)
        
        btnAutoText.frame = CGRect(x: x, y: y, width: Int(screenWidth) - (2 * x), height: 44)
        
        scrollView.addSubview(btnAuto)
        scrollView.addSubview(btnAutoText)
        
        btnAuto.addTapGesture {
            self.generator.impactOccurred()
            if self.btnAuto.backgroundColor != UIColor(rgb: 0xAAAAAA) {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Are you sure you want to make changes?".localized(code), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                    //Cancel Action
                }))
                alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                              style: .destructive,
                                              handler: {(_: UIAlertAction!) in
                                                self.changeBntAuto()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        btn2.addTapGesture {
            self.generator.impactOccurred()
            if self.btn2.backgroundColor != UIColor(rgb: 0xAAAAAA) {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Are you sure you want to make changes?".localized(code), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                    //Cancel Action
                }))
                alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                              style: .destructive,
                                              handler: {(_: UIAlertAction!) in
                                                self.changeBtn2()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        btn3.addTapGesture {
            self.generator.impactOccurred()
            if self.btn3.backgroundColor != UIColor(rgb: 0xAAAAAA) {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Are you sure you want to make changes?".localized(code), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                    //Cancel Action
                }))
                alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                              style: .destructive,
                                              handler: {(_: UIAlertAction!) in
                                                self.changeBtn3()
                }))
                self.present(alert, animated: true, completion: nil)
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
        y = y + deltaYLite + 10
        let separatorTwo = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separatorTwo.backgroundColor = UIColor(rgb: 0xCF2121)
        scrollView.addSubview(separatorTwo)

        scrollView.addSubview(termoLabel)
        
        termoSwitch.frame = CGRect(x: Int(screenWidth / 2 + 110) - (iphone5s ? 10 : 0), y: y + 25, width: 30, height: 20)
        termoSwitch.thumbTintColor = .lightGray
        termoSwitch.onTintColor = UIColor(rgb: 0xCF2121)
        
        scrollView.addSubview(termoSwitch)
        
        let viewTermoSwitch = UIView(frame: CGRect(x: Int(screenWidth / 2 + 110), y: y + 22, width: 60, height: 40))
        viewTermoSwitch.backgroundColor = .clear
        scrollView.addSubview(viewTermoSwitch)

        viewTermoSwitch.addTapGesture {
            let alert = UIAlertController(title: "Warning".localized(code), message: "Are you sure you want to make changes?".localized(code), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                          style: .destructive,
                                          handler: {(_: UIAlertAction!) in
                                            self.changeTermoSwitch()
            }))
            self.present(alert, animated: true, completion: nil)
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
            
            let alertController = UIAlertController(title: "Set password".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
            let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 200, height: 30))
            labelLits.text = "Create a password".localized(code)
            labelLits.alpha = 0.58
            labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 240)

            alertController.view.addConstraint(height)
            
            self.firstTextField.frame = CGRect(x: 20, y: 70, width: self.view.frame.width/3*2-40, height: 30)
            self.firstTextField.keyboardType = .numberPad
            self.firstTextField.isSecureTextEntry = true
            self.firstTextField.inputAccessoryView = self.toolBar()
            self.firstTextField.layer.cornerRadius = 5
            self.firstTextField.layer.borderWidth = 1
            self.firstTextField.returnKeyType = .next
            self.firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
            self.firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.firstTextField.frame.height))
            self.firstTextField.leftViewMode = .always
            self.firstTextField.addTarget(self, action: #selector(self.textFieldDidChangeFirst(_:)),for: UIControl.Event.editingChanged)

            let firstTextHide = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 74, width: 22, height: 22))
            firstTextHide.image = #imageLiteral(resourceName: "глаз")
            let firstTextHideView = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 60, width: 50, height: 50))
            
            firstTextHideView.addTapGesture {
                if firstTextHide.image == #imageLiteral(resourceName: "глаз") {
                    self.firstTextField.isSecureTextEntry = false
                    firstTextHide.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.firstTextField.isSecureTextEntry = true
                    firstTextHide.image = #imageLiteral(resourceName: "глаз")
                }
            }

            let labelLevel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 30))
            labelLevel.text = "Confirm password".localized(code)
            labelLevel.alpha = 0.58
            labelLevel.font = UIFont(name:"FuturaPT-Light", size: 14.0)
            
            self.secondTextField.frame = CGRect(x: 20, y: 130, width: self.view.frame.width/3*2-40, height: 30)
            self.secondTextField.keyboardType = .numberPad
            self.secondTextField.isSecureTextEntry = true
            self.secondTextField.inputAccessoryView = self.toolBar()
            self.secondTextField.layer.cornerRadius = 5
            self.secondTextField.layer.borderWidth = 1
            self.secondTextField.layer.borderColor = UIColor(named: "Color")?.cgColor
            self.secondTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.secondTextField.frame.height))
            self.secondTextField.leftViewMode = .always
            self.secondTextField.addTarget(self, action: #selector(self.textFieldDidChangeFirst(_:)),for: UIControl.Event.editingChanged)

            let secondTextHideView = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 120, width: 50, height: 50))

            
            let secondTextHide = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 134, width: 22, height: 22))
            secondTextHide.image = #imageLiteral(resourceName: "глаз")
            secondTextHide.tintColor = .white
            
            secondTextHideView.addTapGesture {
                if secondTextHide.image == #imageLiteral(resourceName: "глаз") {
                    self.secondTextField.isSecureTextEntry = false
                    secondTextHide.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.secondTextField.isSecureTextEntry = true
                    secondTextHide.image = #imageLiteral(resourceName: "глаз")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            
            self.saveAction = UIAlertAction(title: "Set".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let it: Int = Int(self.firstTextField.text!) {
                    reload = 8
                    mainPassword = "\(it)"
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        passwordHave = true
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password set successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                passwordSuccess = true
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Warning".localized(code), message: "“Password” accepts values from 1 to 2000000000".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.navigationController?.popViewController(animated: true)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            self.saveAction.isEnabled = false
            
            self.validatePassword.frame = CGRect(x: 25, y: 160, width: 250, height: 30)
            self.validatePassword.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            alertController.view.addSubview(labelLits)
            alertController.view.addSubview(labelLevel)
            alertController.view.addSubview(self.firstTextField)
            alertController.view.addSubview(self.secondTextField)
            alertController.view.addSubview(self.validatePassword)
            alertController.view.addSubview(firstTextHide)
            alertController.view.addSubview(firstTextHideView)
            alertController.view.addSubview(secondTextHide)
            alertController.view.addSubview(secondTextHideView)

            alertController.addAction(cancelAction)
            alertController.addAction(self.saveAction)
            
            
            //-----------------------------------------------------------SECOND ALERT----------------
            
            let alertControllerSecond = UIAlertController(title: "Enter password".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
            let labelLitsSecond = UILabel(frame: CGRect(x: 25, y: 40, width: 200, height: 30))
            labelLitsSecond.text = "Enter password".localized(code)
            labelLitsSecond.alpha = 0.58
            labelLitsSecond.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            let heightSecond:NSLayoutConstraint = NSLayoutConstraint(item: alertControllerSecond.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 170)

            alertControllerSecond.view.addConstraint(heightSecond)
            
            self.firstTextFieldSecond.frame = CGRect(x: 20, y: 70, width: self.view.frame.width/3*2-40, height: 30)
            self.firstTextFieldSecond.keyboardType = .numberPad
            self.firstTextFieldSecond.isSecureTextEntry = true
            self.firstTextFieldSecond.inputAccessoryView = self.toolBar()
            self.firstTextFieldSecond.layer.cornerRadius = 5
            self.firstTextFieldSecond.layer.borderWidth = 1
            self.firstTextFieldSecond.returnKeyType = .next
            self.firstTextFieldSecond.layer.borderColor = UIColor(named: "Color")!.cgColor
            self.firstTextFieldSecond.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.firstTextField.frame.height))
            self.firstTextFieldSecond.leftViewMode = .always
            self.firstTextFieldSecond.addTarget(self, action: #selector(self.textFieldDidChangeSecond(_:)),for: UIControl.Event.editingChanged)

            let firstTextHideSecond = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 74, width: 22, height: 22))
            firstTextHideSecond.image = #imageLiteral(resourceName: "глаз")
            let firstTextHideViewSecond = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 60, width: 50, height: 50))
            
            firstTextHideViewSecond.addTapGesture {
                if firstTextHideSecond.image == #imageLiteral(resourceName: "глаз") {
                    self.firstTextFieldSecond.isSecureTextEntry = false
                    firstTextHideSecond.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.firstTextFieldSecond.isSecureTextEntry = true
                    firstTextHideSecond.image = #imageLiteral(resourceName: "глаз")
                }
            }
            
            let cancelActionSecond = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            
            self.saveActionSecond = UIAlertAction(title: "Enter".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let it: Int = Int(self.firstTextFieldSecond.text!) {
                    mainPassword = "\(it)"
                    reload = 9
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        if passwordSuccess == true {
                            let alert = UIAlertController(title: "Success".localized(code), message: "Password is entered".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    passwordSuccess = true
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Warning".localized(code), message: "Wrong password".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.present(alertControllerSecond, animated: true)
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Warning".localized(code), message: "“Password” accepts values from 1 to 2000000000".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.present(alertControllerSecond, animated: true)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            self.saveActionSecond.isEnabled = false
            
            self.validatePasswordSecond.frame = CGRect(x: 25, y: 95, width: 250, height: 30)
            self.validatePasswordSecond.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            alertControllerSecond.view.addSubview(labelLitsSecond)
            alertControllerSecond.view.addSubview(self.firstTextFieldSecond)
            alertControllerSecond.view.addSubview(self.validatePasswordSecond)
            alertControllerSecond.view.addSubview(firstTextHideSecond)
            alertControllerSecond.view.addSubview(firstTextHideViewSecond)

            alertControllerSecond.addAction(cancelActionSecond)
            alertControllerSecond.addAction(self.saveActionSecond)
            if mainPassword == "" {
                if passwordHave == false {
                    self.present(alertController, animated: true)
                } else {
                    self.present(alertControllerSecond, animated: true)
                    
                }
            }
        }
    }
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePasswordSecond.text = "/0/ password can't be used".localized(code)
                validatePasswordSecond.textColor = UIColor(rgb: 0xCF2121)
                self.saveActionSecond.isEnabled = false
            } else {
                validatePasswordSecond.text = ""
                self.saveActionSecond.isEnabled = true
            }
        } else {
            if textField.text == "" {
                self.saveActionSecond.isEnabled = false
                validatePasswordSecond.text = ""
            } else {
                self.saveActionSecond.isEnabled = false
                validatePasswordSecond.text = "Only numbers are allowed for password".localized(code)
                validatePasswordSecond.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        
        checkMaxLength(textField: textField, maxLength: 10)

    }
    @objc func textFieldDidChangeFirst(_ textField: UITextField) {
        print(textField.text!)

        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePassword.text = "/0/ password can't be used".localized(code)
                validatePassword.textColor = UIColor(rgb: 0xCF2121)
                self.saveAction.isEnabled = false
            } else {
                if textField.text == firstTextField.text {
                    if textField.text == secondTextField.text {
                        validatePassword.text = "Passwords match".localized(code)
                        validatePassword.textColor = UIColor(rgb: 0x00A778)
                        self.saveAction.isEnabled = true
                        print("Пароли одинаковы")
                    } else {
                        self.saveAction.isEnabled = false
                        print("Пароли разыне")
                        validatePassword.text = "Passwords do not match".localized(code)
                        validatePassword.textColor = UIColor(rgb: 0xCF2121)
                    }
                } else {
                    self.saveAction.isEnabled = false
                    print("Пароли разыне")
                    validatePassword.text = "Passwords do not match".localized(code)
                    validatePassword.textColor = UIColor(rgb: 0xCF2121)
                }
            }
        } else {
            if textField.text == "" {
                self.saveAction.isEnabled = false
                validatePassword.text = ""
            } else {
                self.saveActionSecond.isEnabled = false
                validatePassword.text = "Only numbers are allowed for password".localized(code)
                validatePassword.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    @objc func timerAction(){
        viewShowParametrs(lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4, y: Int(headerHeight + 415))
    }
    


    func viewShowParametrs(lbl1: UILabel,lbl2: UILabel,lbl3: UILabel, lbl4: UILabel, y: Int) {
        lbl3.text = "CNT\t\t\(cnt)"
        lbl3.textColor = isNight ? UIColor.white : UIColor.black
        lbl1.text = "\(nothing)"
        lbl1.textColor = isNight ? UIColor.white : UIColor.black
        lbl2.text = "\(full)"
        lbl2.textColor = isNight ? UIColor.white : UIColor.black
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
        scrollView.addSubview(viewLoad)
        scrollView.addSubview(viewLoadTwo)
        viewLoad.addSubview(lbl1)
        viewLoad.addSubview(lbl2)
        viewLoadTwo.addSubview(lbl3)
        viewLoadTwo.addSubview(lbl4)

    }
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            lbl1.theme.textColor = themed{ $0.navigationTintColor }
            lbl2.theme.textColor = themed{ $0.navigationTintColor }
            lbl3.theme.textColor = themed{ $0.navigationTintColor }
            autoCalibLabel.theme.textColor = themed{ $0.navigationTintColor }
            input.theme.textColor = themed{ $0.navigationTintColor }
            input3.theme.textColor = themed{ $0.navigationTintColor }
            input4.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle3.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle4.theme.textColor = themed{ $0.navigationTintColor }
            termoLabel.theme.textColor = themed{ $0.navigationTintColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            
            lbl1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lbl2.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lbl3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            autoCalibLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            input.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            
            input3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            input4.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle4.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            termoLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
//        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//        footer.theme.backgroundColor = themed { $0.backgroundNavigationColor }
    }
    fileprivate func toolBar() -> UIToolbar {
        let bar = UIToolbar()
        let reset = UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done".localized(code), style: .done, target: self, action: #selector(resetTapped))
        bar.setItems([reset,done], animated: false)
        bar.sizeToFit()
        return bar
    }
    @objc func resetTapped() {
        secondTextField.endEditing(true)
        firstTextField.endEditing(true)
        firstTextFieldSecond.endEditing(true)
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
                self.scrollView.addSubview(check4)
            } else {
                    check4.removeFromSuperview()
            }
            uPicker2.removeFromSuperview()
        } else {
            input3.text = dataSource[row]
            if prov != self.input3.text {
                check3.image = UIImage(named: "check-red.png")
                self.scrollView.addSubview(check3)
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
            return NSAttributedString(string: dt2, attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor.white : UIColor.black])
        } else {
            let dt = dataSource[row]
            return NSAttributedString(string: dt, attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor.white : UIColor.black])
        }
    }
}
