//
//  SettingsPasswordCell.swift
//  Escort
//
//  Created by Володя Зверев on 08.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class SettingsPasswordCell: UITableViewCell {
    
    var content: UIView!
    var mainLabel: UILabel!
    var passwordLabel: UILabel!
    var passwordTextField: TextFieldWithPadding!
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
        self.passwordLabel = labelMac
        
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
        self.passwordTextField = textField

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
            
            self.passwordTextField!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.passwordTextField!.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: 30),
            self.passwordTextField!.heightAnchor.constraint(equalToConstant: 50),
            self.passwordTextField!.widthAnchor.constraint(equalToConstant: screenWidth
             / 2),

            self.passwordLabel!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.passwordLabel!.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor),
            self.passwordLabel!.trailingAnchor.constraint(equalTo: self.passwordTextField!.leadingAnchor, constant: -20),

            self.setButton!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.setButton!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.setButton!.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            self.setButton!.centerXAnchor.constraint(equalTo: self.content.centerXAnchor),
            self.setButton!.heightAnchor.constraint(equalToConstant: 45),
            self.setButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)

        ])
        setupTheme()
    }
    
    @objc func actionSet() {
        if passwordTextField.text == "" || passwordTextField.text == "0" {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "/0/ password can't be used".localized(code), seconds: 1.0)
        } else {
            if mainPassword == "" {
                mainPassword = passwordTextField.text ?? "0"
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
            passwordLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordTextField.theme.textColor = themed{ $0.navigationTintColor }

        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            mainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            passwordTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
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

extension  SettingsPasswordCell: UITextFieldDelegate {
    func textFieldDelegate() {
        passwordTextField.delegate = self
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
