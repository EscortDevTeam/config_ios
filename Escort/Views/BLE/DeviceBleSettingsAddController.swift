//
//  DeviceBleSettingsAddController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit



class DeviceBleSettingsAddController: UIViewController {
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        viewShow()
        
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
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
        input.placeholder = "\(enterValue)"
        input.textColor = UIColor(rgb: 0xE9E9E9)
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 10)

    }
    let limitLength = 10
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "\(settingDop)", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
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
        
        let lblPassword = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth)-30, height: 22))
        lblPassword.text = "\(passwordForChange)"
        lblPassword.textColor = UIColor(rgb: 0xE9E9E9)
        lblPassword.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        
        scrollView.addSubview(lblPassword)
        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
        
        y = y + deltaY
        
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = password
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let input = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input.text = "\(mainPassword)"
        input.isSecureTextEntry = true
        checkMaxLength(textField: input, maxLength: 10)
        input.addTarget(self, action: #selector(DeviceBleSettingsAddController.textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
        input.attributedPlaceholder = NSAttributedString(string: "\(enterValue)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input.textColor = UIColor(rgb: 0xE9E9E9)
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
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
        btn1Text.text = "\(set)"
        btn1Text.textColor = .white
        btn1Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1Text.textAlignment = .center
        
        let btn1TruePass = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2-60), height: 44))
        btn1TruePass.backgroundColor = UIColor(rgb: 0xCF2121)
        btn1TruePass.layer.cornerRadius = 22
        
        let btn1TextTruePass = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth/2-60), height: 44))
        btn1TextTruePass.text = "Ввести"
        btn1TextTruePass.textColor = .white
        btn1TextTruePass.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn1TextTruePass.textAlignment = .center
        
        let btnTruePassDelete = UIView(frame: CGRect(x: Int(screenWidth/2) + x, y: y, width: Int(screenWidth/2-60), height: 44))
        btnTruePassDelete.backgroundColor = UIColor(rgb: 0xCF2121)
        btnTruePassDelete.layer.cornerRadius = 22
        
        let btnTextTruePassDelete = UILabel(frame: CGRect(x: Int(screenWidth/2) + x, y: y, width: Int(screenWidth/2-60), height: 44))
        btnTextTruePassDelete.text = "Удалить"
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
            if let it: Int = Int(input.text!) {
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
                        let alert = UIAlertController(title: "Успешно", message: "Пароль введен правильно", preferredStyle: .alert)
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
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль", preferredStyle: .alert)
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
                let alert = UIAlertController(title: "Пароль некоректен", message: "Пароль может содержать только цифры", preferredStyle: .alert)
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
        btnTruePassDelete.addTapGesture {
            if let it: Int = Int(input.text!) {
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
                        passwordHave = false
                        mainPassword = ""
                        let alert = UIAlertController(title: "Успешно", message: "Пароль с устройства удален", preferredStyle: .alert)
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
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль", preferredStyle: .alert)
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
                let alert = UIAlertController(title: "Пароль некоректен", message: "Пароль может содержать только цифры", preferredStyle: .alert)
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
        btn1.addTapGesture {
            if let it: Int = Int(input.text!) {
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
                    let alert = UIAlertController(title: "Пароль записан", message: "Пароль записан на текущее BLE устройство", preferredStyle: .alert)
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
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Пароль некоректен", message: "Пароль может содержать только цифры", preferredStyle: .alert)
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
        
        y = y + deltaY + deltaYLite
        
        let separator = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth/2 + 40), height: 1))
        separator.backgroundColor = UIColor(rgb: 0xCF2121)
        scrollView.addSubview(separator)

        
        
        y = y + deltaYLite
        
        let lblSettings = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 22))
        lblSettings.text = "\(manualInput)"
        lblSettings.textColor = UIColor(rgb: 0xE9E9E9)
        lblSettings.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        
        scrollView.addSubview(lblSettings)
        
        y = y + deltaY
        
        //        scrollView.addSubview(textLineCreate(title: "\(setFull)", text: "\(full)", x: x, y: y, prefix: "\(full)"))
        let v1 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        let lblTitle1 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle1.text = setFull
        lblTitle1.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle1.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let input1 = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input1.text = "\(full)"
        input1.attributedPlaceholder = NSAttributedString(string: "\(enterValue)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input1.textColor = UIColor(rgb: 0xE9E9E9)
        input1.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input1.layer.borderWidth = 1.0
        input1.layer.cornerRadius = 4.0
        input1.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input1.backgroundColor = .clear
        input1.leftViewMode = .always
        input1.keyboardType = UIKeyboardType.decimalPad
        
        let lblPrefix1 = UILabel(frame: CGRect(x: screenWidth-80, y: 10, width: 100, height: 20))
        lblPrefix1.text = "\(full)"
        lblPrefix1.textColor = UIColor(rgb: 0xE9E9E9)
        lblPrefix1.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        v1.addSubview(lblPrefix1)
        
        
        v1.addSubview(lblTitle1)
        v1.addSubview(input1)
        scrollView.addSubview(v1)
        
        y = y + deltaY
        
        let v2 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth), height: 40))
        
        let lblTitle2 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle2.text = setNothing
        lblTitle2.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        let input2 = UITextField(frame: CGRect(x: 120, y: 0, width: Int(screenWidth/2-30), height: 40))
        input2.text = "\(nothing)"
        input2.attributedPlaceholder = NSAttributedString(string: "\(enterValue)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        input2.textColor = UIColor(rgb: 0xE9E9E9)
        input2.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input2.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input2.layer.borderWidth = 1.0
        input2.layer.cornerRadius = 4.0
        input2.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input2.backgroundColor = .clear
        input2.leftViewMode = .always
        input2.keyboardType = UIKeyboardType.decimalPad
        
        let lblPrefix2 = UILabel(frame: CGRect(x: screenWidth-80, y: 10, width: 100, height: 20))
        lblPrefix2.text = "\(nothing)"
        lblPrefix2.textColor = UIColor(rgb: 0xE9E9E9)
        lblPrefix2.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        v2.addSubview(lblPrefix2)
        
        
        v2.addSubview(lblTitle2)
        v2.addSubview(input2)
        scrollView.addSubview(v2)
        
        y = y + deltaY
        
        let btn3 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3.backgroundColor = UIColor(rgb: 0xCF2121)
        btn3.layer.cornerRadius = 22
        
        let btn3Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn3Text.text = "\(set)"
        btn3Text.textColor = .white
        btn3Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn3Text.textAlignment = .center
        
        scrollView.addSubview(btn3)
        scrollView.addSubview(btn3Text)
        
        btn3.addTapGesture {
            let textfieldInt: Int? = Int(input1.text!)
            let textfieldIntNothing: Int? = Int(input2.text!)
            if textfieldInt! > textfieldIntNothing! {
                if passwordHave == false {
                    reload = 5
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    full = input1.text!
                    nothing = input2.text!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.stopAnimating()
                        if errorWRN == false {
                            let alert = UIAlertController(title: "Успешно", message: "Данные успешно изменены", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.navigationController?.popViewController(animated: true)
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Ошибка", message: "Не удалось изменить данные", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.navigationController?.popViewController(animated: true)
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                } else {
                    reload = 10
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    full = input1.text!
                    nothing = input2.text!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.stopAnimating()
                        if errorWRN == false {
                            let alert = UIAlertController(title: "Успешно", message: "Данные успешно изменены", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.navigationController?.popViewController(animated: true)
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Ошибка", message: "Не удалось изменить данные", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.navigationController?.popViewController(animated: true)
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            } else {
                let alert = UIAlertController(title: "\(ifFull)", message: "", preferredStyle: .alert)
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
        
        
        y = y + deltaY
        
        let btn4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4.backgroundColor = UIColor(rgb: 0xCF2121)
        btn4.layer.cornerRadius = 22
        
        let btn4Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4Text.text = "\(reloadName)"
        btn4Text.textColor = .white
        btn4Text.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btn4Text.textAlignment = .center
        
        scrollView.addSubview(btn4)
        scrollView.addSubview(btn4Text)
        
        
        btn4Text.addTapGesture {
            reload = 1
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                if errorWRN == false {
                    let alert = UIAlertController(title: "Успешная перезагрузка", message: "Устройство успешно перезагрузилось, повторите попытку входа", preferredStyle: .alert)
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
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "\(failReloud)", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            errorWRN = false
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
}
