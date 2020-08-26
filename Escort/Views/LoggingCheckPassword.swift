//
//  LoggingCheckPassword.swift
//  Escort
//
//  Created by Володя Зверев on 08.07.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

extension LoggingController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    func showPassword() {
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
        self.firstTextField.inputAccessoryView = toolBar()
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
        self.secondTextField.inputAccessoryView = toolBar()
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
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.viewAlpha.removeFromSuperview()
                    passwordHave = true
                    self.input1.removeFromSuperview()
                    self.input2.removeFromSuperview()
                    let alert = UIAlertController(title: "Success".localized(code), message: "Password set successfully".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("OK")
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
        self.firstTextFieldSecond.inputAccessoryView = toolBar()
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.viewAlpha.removeFromSuperview()
                    self.input1.removeFromSuperview()
                    self.input2.removeFromSuperview()
                    if passwordSuccess == true {
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password is entered".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("OK")
                                reload = 14
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
                                print("OK")
                                mainPassword = ""
                                if passwordHave == false {
                                    self.present(alertController, animated: true)
                                } else {
                                    self.present(alertControllerSecond, animated: true)
                                    
                                }
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
