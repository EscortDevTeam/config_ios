//
//  CustomAlert.swift
//  Escort
//
//  Created by Володя Зверев on 08.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class CustomAlert: UIView {
    
    @IBOutlet weak var CustomEnter: UIButton!
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var CustomMainLabel: UILabel!
    @IBOutlet weak var CustomImage: UIImageView!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var CloseImage: UIButton!
    
    weak var delegate: AlertDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        customeizingButton()
        customeizingContentView()
        setupTheme()
    }
    
    func set(title: String, body: String, buttonTitle: String) {
        CustomMainLabel.text = title
        CustomEnter.setTitle(buttonTitle, for: .normal)
        CustomTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized(code),attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: isNight ? 0x979797 : 0xB8B8B8).withAlphaComponent(0.5)])
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        delegate?.forgotTapped2()
    }
    @IBAction func ActionButton(_ sender: Any) {
        if CustomTextField.text == "" || CustomTextField.text == "0" {
            let window = UIApplication.shared.keyWindow!
            window.rootViewController?.showToast(message: "/0/ password can't be used".localized(code), seconds: 1.0)
        } else {
            delegate?.buttonTapped2()
        }
    }
    @IBAction func clouseButton(sender: Any) {
        delegate?.buttonClose2()
    }
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    func customeizingButton() {
        CustomEnter.layer.cornerRadius = 10
        CloseImage.frame.size = CGSize(width: 50, height: 50)
    }
    func customeizingContentView() {
        CustomTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized(code),attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: isNight ? 0x979797 : 0xB8B8B8).withAlphaComponent(0.5)])
        CustomTextField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        CustomTextField.layer.masksToBounds = true
        CustomTextField.layer.borderWidth = 1.0
        CustomTextField.layer.cornerRadius = 10
        CustomTextField.tintColor = .red
        CustomTextField.keyboardAppearance = isNight ? .dark : .light
        ContentView.layer.shadowColor = UIColor(rgb: 0xE80000).cgColor
        ContentView.layer.shadowRadius = 20.0
        ContentView.layer.shadowOpacity = 0.2
        ContentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        ContentView.layer.cornerRadius = 20
        
        CustomTextField.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            ContentView.theme.backgroundColor = themed { $0.backgroundColor }
            CustomMainLabel.theme.textColor = themed{ $0.navigationTintColor }
            CustomTextField.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            ContentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            CustomMainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            CustomTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
