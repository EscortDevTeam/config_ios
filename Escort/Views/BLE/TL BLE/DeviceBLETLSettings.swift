//
//  DeviceBLETLSettings.swift
//  Escort
//
//  Created by Володя Зверев on 19.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit



class DeviceBLETLSettings: UIViewController {
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var input1 = UITextField()
    var input2 = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        viewShow()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.color = .white
        activity.startAnimating()
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
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "TL BLE Settings".localized(code), showBack: true)
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
        let y = 20
        let x = 30
//        deltaY = 65
//        deltaYLite = 20
        
//        y = y + deltaY
        
        let btn4 = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4.backgroundColor = UIColor(rgb: 0xCF2121)
        btn4.layer.cornerRadius = 22
        
        let btn4Text = UILabel(frame: CGRect(x: x, y: y, width: Int(screenWidth-60), height: 44))
        btn4Text.text = "Reloading TL-BLE".localized(code)
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
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
