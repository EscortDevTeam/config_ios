//
//  NumberDeviceCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.

import UIKit

class NumberDeviceCell: UITableViewCell {
    
//    var content: UIView!
    var label: UILabel!
    var labelPassword: UILabel!
    var imageUI: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
//        let content = UIView()
//        content.backgroundColor = .white
//        content.translatesAutoresizingMaskIntoConstraints = false
//        content.layer.shadowColor = UIColor.black.cgColor
//        content.layer.shadowRadius = 3.0
//        content.layer.shadowOpacity = 0.1
//        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        content.layer.cornerRadius = 10
//        self.contentView.addSubview(content)
//        self.content = content
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.label = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 20)
        labelMac.textAlignment = .left
        labelMac.textColor = .white
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        contentView.addSubview(labelMac)
        self.labelPassword = labelMac
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "account_Image")
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: self.imageUI!.bottomAnchor, constant: 25),
            
            self.label!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.label!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.label!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.label!.topAnchor.constraint(equalTo: contentView.topAnchor),

            self.labelPassword!.leadingAnchor.constraint(equalTo: self.label!.trailingAnchor, constant: 20),
            self.labelPassword!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

//            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
//            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.imageUI!.heightAnchor.constraint(equalToConstant: 72),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 72),
//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .clear
//            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            label.theme.textColor = themed{ $0.navigationTintColor }
            labelPassword.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            contentView.backgroundColor = .clear
//            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            label.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelPassword.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
