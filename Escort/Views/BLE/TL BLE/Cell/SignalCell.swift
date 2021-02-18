//
//  SignalCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class SignalCell: UITableViewCell {
    
    var label: UILabel!
    var labelPassword: UILabel!
    var signalUI: UIImageView!
    var batUI: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "signal4")
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        imageUI.image = imageUI.image!.withRenderingMode(.alwaysTemplate)
        contentView.addSubview(imageUI)
        self.signalUI = imageUI
        
        let batUI = UIImageView()
        batUI.image = UIImage(named: "bat1")
        batUI.translatesAutoresizingMaskIntoConstraints = false
        batUI.image = batUI.image!.withRenderingMode(.alwaysTemplate)
        contentView.addSubview(batUI)
        self.batUI = batUI
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 20)
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
        
        NSLayoutConstraint.activate([

            self.signalUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.signalUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.signalUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            self.signalUI!.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.signalUI!.widthAnchor.constraint(equalToConstant: 24),
            self.signalUI!.heightAnchor.constraint(equalToConstant: 24),

            self.label!.leadingAnchor.constraint(equalTo: self.signalUI.trailingAnchor, constant: 10),
            self.label!.centerYAnchor.constraint(equalTo: self.signalUI.centerYAnchor),

            self.batUI!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.batUI!.centerYAnchor.constraint(equalTo: self.signalUI.centerYAnchor),
            
            self.labelPassword!.trailingAnchor.constraint(equalTo: self.batUI.leadingAnchor, constant: -10),
            self.labelPassword!.centerYAnchor.constraint(equalTo: self.signalUI.centerYAnchor),

        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            signalUI.theme.tintColor = themed{ $0.navigationTintColor }
            batUI.theme.tintColor = themed{ $0.navigationTintColor }
            label.theme.textColor = themed{ $0.navigationTintColor }
            labelPassword.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            signalUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            batUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            label.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelPassword.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
