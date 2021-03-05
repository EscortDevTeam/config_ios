//
//  DuControlAngleCell.swift
//  Escort
//
//  Created by Володя Зверев on 20.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class DuControlAngleCell: UITableViewCell {
    
    var content: UIView!
    var passwordFirstLabel: UILabel!
    var passwordSecondLabel: UILabel!
    var passwordFirstTextField: TextFieldWithPadding!
    var passwordSecondTextField: TextFieldWithPadding!
    var setButton: UIButton!
    var delegate : SettingsDUDelegate?

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
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        labelMac.textAlignment = .center
        labelMac.text = "Top".localized(code)
        labelMac.textColor = UIColor(rgb: 0x998F99)
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        self.content.addSubview(labelMac)
        self.passwordFirstLabel = labelMac
        
        let textField = TextFieldWithPadding(placeholder: "100")
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
        self.content.addSubview(textField)
        self.passwordFirstTextField = textField
        
        let passwordSecondLabel = UILabel()
        passwordSecondLabel.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        passwordSecondLabel.textAlignment = .center
        passwordSecondLabel.text = "Down".localized(code)
        passwordSecondLabel.textColor = UIColor(rgb: 0x998F99)
        passwordSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordSecondLabel.numberOfLines = 0
        self.content.addSubview(passwordSecondLabel)
        self.passwordSecondLabel = passwordSecondLabel
        
        let passwordSecondTextField = TextFieldWithPadding(placeholder: "50")
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
        self.content.addSubview(passwordSecondTextField)
        self.passwordSecondTextField = passwordSecondTextField

        let button = UIButton()
        button.setTitle("Write parameters to the device".localized(code), for: .normal)
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
            
            self.passwordFirstTextField!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.passwordFirstTextField!.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 20),
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
        if Int(self.passwordFirstTextField.text ?? "0") ?? 0 < 1 || Int(self.passwordFirstTextField.text ?? "0") ?? 0 > 179 {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "Value top only 1 to 179".localized(code), seconds: 2.0)
        } else if Int(self.passwordSecondTextField.text ?? "0") ?? 0 < 1 || Int(self.passwordSecondTextField.text ?? "0") ?? 0 > 179 {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "Value down only 1 to 179".localized(code), seconds: 2.0)
        } else {
            valH = passwordFirstTextField.text!
            valL = passwordSecondTextField.text!
            delegate?.buttonSetParameters(load: 22)
        }
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.theme.backgroundColor = themed { $0.backgroundColor }
            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            passwordFirstLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordFirstTextField.theme.textColor = themed{ $0.navigationTintColor }
            passwordSecondLabel.theme.textColor = themed{ $0.navigationTintColor }
            passwordSecondTextField.theme.textColor = themed{ $0.navigationTintColor }

        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
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

extension  DuControlAngleCell: UITextFieldDelegate {
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
