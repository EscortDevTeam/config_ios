//
//  DeviceBleSettingsAddController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer



class DeviceBleSettingsAddController: UIViewController {
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var input1 = UITextField()
    var input2 = UITextField()
    
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let validatePassword = UILabel()
    var saveAction = UIAlertAction()
    
    let firstTextFieldSecond = UITextField()
    let secondTextFieldSecond = UITextField()
    let validatePasswordSecond = UILabel()
    var saveActionSecond = UIAlertAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        viewShow()
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
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func textLineCreate(title: String, text: String, x: Int, y: Int, prefix: String) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let input = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input.text = text
        input.placeholder = "Enter value...".localized(code)
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        if !prefix.isEmpty {
            let lblPrefix = UILabel(frame: CGRect(x: screenWidth-80, y: 10, width: 100, height: 20))
            lblPrefix.text = prefix
            lblPrefix.textColor = UIColor(rgb: 0xE9E9E9)
            lblPrefix.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
            v.addSubview(lblPrefix)
        }
        
        v.addSubview(lblTitle)
        v.addSubview(input)
        return v
    }
    
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-70), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var lblPassword: UILabel = {
        let lblPassword = UILabel(frame: CGRect(x: 30, y: 20, width: Int(screenWidth)-30, height: 22))
        lblPassword.text = "Password for changing settings".localized(code)
        lblPassword.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        return lblPassword
    }()
    
    fileprivate lazy var lblTitle: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = "Password".localized(code)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var input: UITextField = {
        let input = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input.text = "\(mainPassword)"
        input.isSecureTextEntry = true
        input.addTarget(self, action: #selector(DeviceBleSettingsAddController.textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input.textColor = UIColor(rgb: 0xE9E9E9)
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        return input
    }()
    
    fileprivate lazy var lblSettings: UILabel = {
        let lblSettings = UILabel(frame: CGRect(x: 30, y: 255, width: Int(screenWidth), height: 22))
        lblSettings.text = "Manual configuration input".localized(code)
        lblSettings.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        return lblSettings
    }()
    fileprivate lazy var lblTitle1: UILabel = {
        let lblTitle1 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle1.text = "Full".localized(code)
        lblTitle1.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle1
    }()
    fileprivate lazy var lblPrefix1: UILabel = {
        let lblPrefix1 = UILabel(frame: CGRect(x: Int(screenWidth/2-30), y: 10, width: Int(screenWidth/2-30), height: 20))
        lblPrefix1.text = "\(full)"
        lblPrefix1.textAlignment = .right
        lblPrefix1.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        return lblPrefix1
    }()
    fileprivate lazy var lblTitle2: UILabel = {
        let lblTitle2 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle2.text = "Empty".localized(code)
        lblTitle2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle2
    }()
    fileprivate lazy var lblPrefix2: UILabel = {
        let lblPrefix2 = UILabel(frame: CGRect(x: Int(screenWidth/2-30), y: 10, width: Int(screenWidth/2-30), height: 20))
        lblPrefix2.text = "\(nothing)"
        lblPrefix2.textAlignment = .right
        lblPrefix2.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        return lblPrefix2
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
    //Убираем клавиатуру

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
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    private func viewShow() {
        warning = false
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        view.addSubview(themeBackView3)
        MainLabel.text = "TD BLE Settings".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(bgImage)
        view.addSubview(scrollView)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight))
        var y = 20
        let x = 30, deltaY = 65, deltaYLite = 20
        
        scrollView.addSubview(lblPassword)
        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
        
        y = y + deltaY
        
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))

        checkMaxLength(textField: input, maxLength: 10)
        v.addSubview(lblTitle)
        v.addSubview(input)
        
        let lblPrefix = UILabel(frame: CGRect(x: screenWidth-80, y: 10, width: 100, height: 20))
        lblPrefix.text = ""
        lblPrefix.textColor = UIColor(rgb: 0xE9E9E9)
        lblPrefix.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        v.addSubview(lblPrefix)
        
        

        y = y + deltaY
        let btn1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1.layer.cornerRadius = 22
        
        let btn1Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn1Text.text =  "Set".localized(code)
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        let btn1TruePass = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2-60), height: 44))
        btn1TruePass.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1TruePass.layer.cornerRadius = 22
        
        let btn1TextTruePass = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth/2-60), height: 44))
        btn1TextTruePass.text = "Enter".localized(code)
        btn1TextTruePass.textColor = .white
        btn1TextTruePass.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1TextTruePass.textAlignment = .center
        
        let btnTruePassDelete = UIView(frame: CGRect(x: Int(screenWidth/2) + x, y: y, width: Int(screenWidth/2-60), height: 44))
        btnTruePassDelete.backgroundColor = UIColor(rgb: 0xCF2121)
        btnTruePassDelete.layer.cornerRadius = 22
        
        let btnTextTruePassDelete = UILabel(frame: CGRect(x: Int(screenWidth/2) + x, y: y, width: Int(screenWidth/2-60), height: 44))
        btnTextTruePassDelete.text = "Remove".localized(code)
        btnTextTruePassDelete.textColor = .white
        btnTextTruePassDelete.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnTextTruePassDelete.textAlignment = .center
        if passwordHave == false {
            scrollView.addSubview(v)
            scrollView.addSubview(btn1)
            scrollView.addSubview(btn1Text)
        } else {
            scrollView.addSubview(v)
            scrollView.addSubview(btn1TruePass)
            scrollView.addSubview(btn1TextTruePass)
            scrollView.addSubview(btnTruePassDelete)
            scrollView.addSubview(btnTextTruePassDelete)
        }
        btn1TruePass.addTapGesture {
            if let it: Int = Int(self.input.text!) {
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
                        self.input1.removeFromSuperview()
                        self.input2.removeFromSuperview()
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password is entered".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                self.scrollView.removeFromSuperview()
                                v.removeFromSuperview()
                                btn1TruePass.removeFromSuperview()
                                btn1TextTruePass.removeFromSuperview()
                                btnTruePassDelete.removeFromSuperview()
                                btnTextTruePassDelete.removeFromSuperview()
                                self.view.subviews.forEach({ $0.removeFromSuperview() })
                                self.viewShow()
                                self.setupTheme()
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
        btnTruePassDelete.addTapGesture {
            if let it: Int = Int(self.input.text!) {
                mainPassword = "\(it)"
                reload = 7
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
                        self.input1.removeFromSuperview()
                        self.input2.removeFromSuperview()
                        passwordHave = false
                        mainPassword = ""
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password deleted successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                self.scrollView.removeFromSuperview()
                                v.removeFromSuperview()
                                btn1TruePass.removeFromSuperview()
                                btn1TextTruePass.removeFromSuperview()
                                btnTruePassDelete.removeFromSuperview()
                                btnTextTruePassDelete.removeFromSuperview()
                                self.view.subviews.forEach({ $0.removeFromSuperview() })
                                self.viewShow()
                                self.setupTheme()
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
        btn1.addTapGesture {
            if let it: Int = Int(self.input.text!) {
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
                    self.input1.removeFromSuperview()
                    self.input2.removeFromSuperview()
                    let alert = UIAlertController(title: "Success".localized(code), message: "Password set successfully".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.scrollView.removeFromSuperview()
                            v.removeFromSuperview()
                            btn1.removeFromSuperview()
                            btn1Text.removeFromSuperview()
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                            self.viewShow()
                            self.setupTheme()
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
        
        y = y + deltaY + deltaYLite
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        scrollView.addSubview(separator)

        
        
        y = y + deltaYLite
        
        scrollView.addSubview(lblSettings)
        
        y = y + deltaY
        
        //        scrollView.addSubview(textLineCreate(title: "\(setFull)", text: "\(full)", x: x, y: y, prefix: "\(full)"))
        let v1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        input1 = UITextField(frame: CGRect(x: 70, y: 0, width: Int(screenWidth/2-30), height: 40))
        input1.text = "\(full)"
        input1.addTarget(self, action: #selector(DeviceBleSettingsAddController.textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
        input1.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input1.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input1.layer.borderWidth = 1.0
        input1.layer.cornerRadius = 4.0
        input1.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input1.backgroundColor = .clear
        input1.leftViewMode = .always
        input1.keyboardType = UIKeyboardType.decimalPad
        
        v1.addSubview(lblPrefix1)
        
        
        v1.addSubview(lblTitle1)
        v1.addSubview(input1)
        scrollView.addSubview(v1)
        
        y = y + deltaY
        
        let v2 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        
        input2 = UITextField(frame: CGRect(x: 70, y: 0, width: Int(screenWidth/2-30), height: 40))
        input2.text = "\(nothing)"
        input2.addTarget(self, action: #selector(DeviceBleSettingsAddController.textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
        input2.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input2.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input2.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input2.layer.borderWidth = 1.0
        input2.layer.cornerRadius = 4.0
        input2.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input2.backgroundColor = .clear
        input2.leftViewMode = .always
        input2.keyboardType = UIKeyboardType.decimalPad
        
        v2.addSubview(lblPrefix2)
        
        
        v2.addSubview(lblTitle2)
        v2.addSubview(input2)
        scrollView.addSubview(v2)
        
        y = y + deltaY
        
        let btn3 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        btn3.layer.cornerRadius = 22
        
        let btn3Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3Text.text = "Set".localized(code)
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        
        scrollView.addSubview(btn3)
        scrollView.addSubview(btn3Text)
        
        btn3.addTapGesture {
            let textfieldInt: Int? = Int(self.input1.text!) ?? 1
            let textfieldIntNothing: Int? = Int(self.input2.text!) ?? 1
            if textfieldInt! > textfieldIntNothing! {
                if passwordHave == false {
                    reload = 5
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    full = self.input1.text!
                    nothing = self.input2.text!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.stopAnimating()
                        if errorWRN == false {
                            let alert = UIAlertController(title: "Success".localized(code), message: "Data updated successfully".localized(code), preferredStyle: .alert)
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
                        } else {
                            let alert = UIAlertController(title: "Warning".localized(code), message: "Data update failure".localized(code), preferredStyle: .alert)
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
                        
                    }
                } else {
                    reload = 10
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    full = self.input1.text!
                    nothing = self.input2.text!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.stopAnimating()
                        if errorWRN == false {
                            let alert = UIAlertController(title: "Success".localized(code), message: "Data updated successfully".localized(code), preferredStyle: .alert)
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
                        } else {
                            let alert = UIAlertController(title: "Warning".localized(code), message: "Data update failure".localized(code), preferredStyle: .alert)
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
                        
                    }
                }
            } else {
                let alert = UIAlertController(title: "Attention".localized(code), message: "“Full” value shall be higher than “Empty” value".localized(code), preferredStyle: .alert)
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
        
        
        y = y + deltaY
        
        let btn4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4.backgroundColor = UIColor(rgb: 0xCF2121)
        btn4.layer.cornerRadius = 22
        
        let btn4Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4Text.text = "Reloading TD-BLE".localized(code)
        btn4Text.textColor = .white
        btn4Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn4Text.textAlignment = .center
        
        scrollView.addSubview(btn4)
        scrollView.addSubview(btn4Text)
        
        
        btn4Text.addTapGesture {
            reload = 1
            if passwordHave == true {
                if passwordSuccess == true {
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        self.activityIndicator.stopAnimating()
                        if errorWRN == false {
                            let alert = UIAlertController(title: "Success".localized(code), message: "Reloading...".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    reloadBack = 1
                                    self.navigationController?.popViewController(animated: true)
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Warning".localized(code), message: "Failed to reload".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    errorWRN = false
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
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.activityIndicator.stopAnimating()
                    if errorWRN == false {
                        let alert = UIAlertController(title: "Success".localized(code), message: "Reloading...".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                reloadBack = 1
                                self.navigationController?.popViewController(animated: true)
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Warning".localized(code), message: "Failed to reload".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                errorWRN = false
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
                    self.input1.removeFromSuperview()
                    self.input2.removeFromSuperview()
                    let alert = UIAlertController(title: "Success".localized(code), message: "Password set successfully".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            print("default")
                            self.scrollView.removeFromSuperview()
                            v.removeFromSuperview()
                            btn1.removeFromSuperview()
                            btn1Text.removeFromSuperview()
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                            self.viewShow()
                            self.setupTheme()
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
                    self.input1.removeFromSuperview()
                    self.input2.removeFromSuperview()
                    if passwordSuccess == true {
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password is entered".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                self.scrollView.removeFromSuperview()
                                v.removeFromSuperview()
                                btn1.removeFromSuperview()
                                btn1Text.removeFromSuperview()
                                self.view.subviews.forEach({ $0.removeFromSuperview() })
                                self.viewShow()
                                self.setupTheme()
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
                                mainPassword = ""
                                self.scrollView.removeFromSuperview()
                                v.removeFromSuperview()
                                btn1.removeFromSuperview()
                                btn1Text.removeFromSuperview()
                                self.view.subviews.forEach({ $0.removeFromSuperview() })
                                self.viewShow()
                                self.setupTheme()
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
    
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePasswordSecond.text = "Пароль \"0\" не может быть использован"
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
                validatePasswordSecond.text = "Пароль может содержать только цифры"
                validatePasswordSecond.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        
        checkMaxLength(textField: textField, maxLength: 10)
        
    }
    @objc func textFieldDidChangeFirst(_ textField: UITextField) {
        print(textField.text!)
        
        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePassword.text = "Пароль \"0\" не может быть использован"
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
                validatePassword.text = "Пароль может содержать только цифры"
                validatePassword.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        checkMaxLength(textField: textField, maxLength: 10)
    }
    
        fileprivate func setupTheme() {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            input.theme.textColor = themed{ $0.navigationTintColor }
            input1.theme.textColor = themed{ $0.navigationTintColor }
            input2.theme.textColor = themed{ $0.navigationTintColor }
            lblPassword.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle.theme.textColor = themed{ $0.navigationTintColor }
            lblSettings.theme.textColor = themed{ $0.navigationTintColor }
            lblPrefix2.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle2.theme.textColor = themed{ $0.navigationTintColor }
            lblPrefix1.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle1.theme.textColor = themed{ $0.navigationTintColor }
        }
}
