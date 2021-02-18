//
//  SettingsReloadTLCell.swift
//  Escort
//
//  Created by Володя Зверев on 16.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//


import UIKit

class SettingsReloadTLCell: UITableViewCell {
    
    var content: UIView!
    var setButton: UIButton!
    var delegate: UpdateButtomDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
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

        let button = UIButton()
        button.setTitle("FW update".localized(code), for: .normal)
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
            self.content!.bottomAnchor.constraint(equalTo: self.setButton!.bottomAnchor, constant: 25),
   
            self.setButton!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
            self.setButton!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
            self.setButton!.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 25),
            self.setButton!.centerXAnchor.constraint(equalTo: self.content.centerXAnchor),
            self.setButton!.heightAnchor.constraint(equalToConstant: 45),
            self.setButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)

        ])
        setupTheme()
    }
    
    @objc func actionSet() {
        delegate?.updateDevice()
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.theme.backgroundColor = themed { $0.backgroundColor }
            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }

        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
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
