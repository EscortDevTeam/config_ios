//
//  SettingsNewPasswordCell.swift
//  Escort
//
//  Created by Володя Зверев on 09.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class SettingsNewPasswordCell: UITableViewCell {
    
    var content: UIView!
    var mainLabel: UILabel!
    var passwordFirstLabel: UILabel!
    var passwordSecondLabel: UILabel!
    var passwordFirstTextField: TextFieldWithPadding!
    var passwordSecondTextField: TextFieldWithPadding!
    var setButton: UIButton!
    var delegate: PasswordSetDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
        textFieldDelegate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor.black.cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 10
        self.contentView.addSubview(content)
        self.content = content
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 18)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Password for changing settings".localized(code)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.content.addSubview(label)
        self.mainLabel = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        labelMac.textAlignment = .left
        labelMac.text = "Password".localized(code)
        labelMac.textColor = UIColor(rgb: 0x998F99)
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        self.content.addSubview(labelMac)
        self.passwordFirstLabel = labelMac
        
        let textField = TextFieldWithPadding(placeholder: "********")
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.tintColor = .red
        textField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        textField.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        textField.textColor = UIColor(rgb: 0x998F99)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        self.content.addSubview(textField)
        self.passwordFirstTextField = textField
        
        let passwordSecondLabel = UILabel()
        passwordSecondLabel.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        passwordSecondLabel.textAlignment = .left
        passwordSecondLabel.text = "Password".localized(code)
        passwordSecondLabel.textColor = UIColor(rgb: 0x998F99)
        passwordSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordSecondLabel.numberOfLines = 0
        self.content.addSubview(passwordSecondLabel)
        self.passwordSecondLabel = passwordSecondLabel
        
        let passwordSecondTextField = TextFieldWithPadding(placeholder: "********")
        passwordSecondTextField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        passwordSecondTextField.layer.borderWidth = 1.0
        passwordSecondTextField.layer.cornerRadius = 10
        passwordSecondTextField.tintColor = .red
        passwordSecondTextField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        passwordSecondTextField.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        passwordSecondTextField.textAlignment = .left
        passwordSecondTextField.keyboardType = .numberPad
        passwordSecondTextField.textColor = UIColor(rgb: 0x998F99)
        passwordSecondTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecondTextField.isSecureTextEntry = true
        self.content.addSubview(passwordSecondTextField)
        self.passwordSecondTextField = passwordSecondTextField

        let button = UIButton()
        button.setTitle("Set".localized(code), for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(rgb: 0xE80000)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 23)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSet), for: .touchUpInside)
        self.content.addSubview(button)
        self.setButton = button

        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.content!.bottomAnchor.constraint(equalTo: self.setButton!.bottomAnchor, constant: 10),
            
            self.mainLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.mainLabel!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.mainLabel!.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 20),
            
            self.passwordFirstTextField!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.passwordFirstTextField!.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: 30),
            self.passwordFirstTextField!.heightAnchor.constraint(equalToConstant: 50),
            self.passwordFirstTextField!.widthAnchor.constraint(equalToConstant: screenWidth
             / 2),

            self.passwordFirstLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.passwordFirstLabel!.centerYAnchor.constraint(equalTo: self.passwordFirstTextField.centerYAnchor),
            self.passwordFirstLabel!.trailingAnchor.constraint(equalTo: self.passwordFirstTextField!.leadingAnchor, constant: -20),

            self.passwordSecondTextField!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.passwordSecondTextField!.topAnchor.constraint(equalTo: self.passwordFirstTextField.bottomAnchor, constant: 15),
            self.passwordSecondTextField!.heightAnchor.constraint(equalToConstant: 50),
            self.passwordSecondTextField!.widthAnchor.constraint(equalToConstant: screenWidth
             / 2),

            self.passwordSecondLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.passwordSecondLabel!.centerYAnchor.constraint(equalTo: self.passwordSecondTextField.centerYAnchor),
            self.passwordSecondLabel!.trailingAnchor.constraint(equalTo: self.passwordSecondTextField!.leadingAnchor, constant: -20),

            
            self.setButton!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.setButton!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.setButton!.topAnchor.constraint(equalTo: self.passwordSecondTextField.bottomAnchor, constant: 20),
            self.setButton!.centerXAnchor.constraint(equalTo: self.content.centerXAnchor),
            self.setButton!.heightAnchor.constraint(equalToConstant: 45),
            self.setButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)

        ])
        setupTheme()
    }
    
    @objc func actionSet() {
        if passwordFirstTextField.text != passwordSecondTextField.text {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "Passwords do not match".localized(code), seconds: 1.0)
        } else if passwordFirstTextField.text == "" || passwordFirstTextField.text == "0" {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "/0/ password can't be used".localized(code), seconds: 1.0)
        } else {
            if mainPassword == "" {
                mainPassword = passwordFirstTextField.text ?? "0"
                delegate?.setPassword(bool: true)
            } else {
                delegate?.setPassword(bool: false)
            }
        }
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.theme.backgroundColor = themed { $0.backgroundColor }
            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            mainLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordFirstLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordFirstTextField.theme.textColor = themed{ $0.navigationTintColor }
            passwordSecondLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordSecondTextField.theme.textColor = themed{ $0.navigationTintColor }

        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            mainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordFirstLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordFirstTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordSecondLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordSecondTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 9)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension  SettingsNewPasswordCell: UITextFieldDelegate {
    func textFieldDelegate() {
        passwordFirstTextField.delegate = self
        passwordSecondTextField.delegate = self

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE80000).cgColor
        textField.layer.shadowColor = UIColor(rgb: 0xE80000).withAlphaComponent(0.5).cgColor
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        textField.layer.shadowOpacity = 0.0
    }
}
