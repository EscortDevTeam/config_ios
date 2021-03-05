//
//  DeviceSelectCell.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//


import UIKit

class DeviceSelectCell: UITableViewCell {
    
    var content: UIView!
    var container: UIView!
    var label: UILabel!
    var labelNext: UILabel!
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
        
        let conteiner = UIView()
        conteiner.backgroundColor = .clear
        conteiner.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(conteiner)
        self.container = conteiner
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenWidth / 18)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.container.addSubview(label)
        self.label = label
        
        let labelNext = UILabel()
        labelNext.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 18)
        labelNext.textAlignment = .center
        labelNext.textColor = .black
        labelNext.translatesAutoresizingMaskIntoConstraints = false
        labelNext.numberOfLines = 0
        self.container.addSubview(labelNext)
        self.labelNext = labelNext
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Light", size: screenHeight / 23)
        labelMac.textAlignment = .left
        labelMac.textColor = UIColor(rgb: 0x998F99)
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
//        self.content.addSubview(labelMac)
        self.labelPassword = labelMac
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "account_Image")
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        self.content.addSubview(imageUI)
        self.imageUI = imageUI
        
        
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.content!.bottomAnchor.constraint(equalTo: self.labelNext!.bottomAnchor, constant: 25),
            
            self.container!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 15),
            self.container!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -15),
            self.container!.centerYAnchor.constraint(equalTo: self.content.centerYAnchor),
            self.container!.bottomAnchor.constraint(equalTo: self.labelNext.bottomAnchor, constant: 25),
            self.container!.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 15),

            self.label!.leadingAnchor.constraint(equalTo: self.container!.leadingAnchor, constant: 0),
            self.label!.trailingAnchor.constraint(equalTo: self.container!.trailingAnchor, constant: 0),
            self.label!.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10),

            self.labelNext!.leadingAnchor.constraint(equalTo: self.container!.leadingAnchor, constant: 0),
            self.labelNext!.trailingAnchor.constraint(equalTo: self.container!.trailingAnchor, constant: 0),
            self.labelNext!.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 5),
            self.labelNext!.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10),

            self.imageUI!.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 25),
            self.imageUI!.centerYAnchor.constraint(equalTo: self.content.centerYAnchor),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 72),
            self.imageUI!.widthAnchor.constraint(equalToConstant: 72),
//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.theme.backgroundColor = themed { $0.backgroundColor }
            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            label.theme.textColor = themed{ $0.navigationTintColor }
            labelNext.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            label.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelNext.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
