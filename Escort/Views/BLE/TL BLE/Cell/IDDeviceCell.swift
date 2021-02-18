//
//  IDDeviceCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class IDDeviceCell: UITableViewCell {
    
    var labelNumber: UILabel!
    var labelVersion: UILabel!

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
        label.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 18)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.labelNumber = label
        
        let labelMac = UILabel()
        labelMac.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 18)
        labelMac.textAlignment = .left
        labelMac.textColor = .white
        labelMac.translatesAutoresizingMaskIntoConstraints = false
        labelMac.numberOfLines = 0
        contentView.addSubview(labelMac)
        self.labelVersion = labelMac
            
        NSLayoutConstraint.activate([
            
            self.labelNumber!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.labelNumber!.topAnchor.constraint(equalTo: contentView.topAnchor),

            self.labelVersion!.topAnchor.constraint(equalTo: self.labelNumber!.bottomAnchor, constant: 5),
            self.labelVersion!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.labelVersion!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .clear
//            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            labelNumber.theme.textColor = themed{ $0.navigationTintColor }
            labelVersion.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            contentView.backgroundColor = .clear
//            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            labelNumber.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelVersion.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
