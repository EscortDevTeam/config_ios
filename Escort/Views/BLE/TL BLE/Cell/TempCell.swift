//
//  TempCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class TempCell: UITableViewCell {
    
//    var content: UIView!
    var label: UILabel!
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
        
        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.label = label
        
        
        let imageUI = UIImageView()
        imageUI.image = UIImage(named: "temp")
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        imageUI.image = imageUI.image!.withRenderingMode(.alwaysTemplate)
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        NSLayoutConstraint.activate([
            
            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.imageUI!.topAnchor.constraint(equalTo: contentView.topAnchor),

            self.label!.leadingAnchor.constraint(equalTo: self.imageUI!.trailingAnchor, constant: 20),
            self.label!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .clear
            imageUI.theme.tintColor = themed{ $0.navigationTintColor }
            label.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            contentView.backgroundColor = .clear
            imageUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            label.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
