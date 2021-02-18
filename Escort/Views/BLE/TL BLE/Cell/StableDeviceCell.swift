//
//  StableDeviceCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class StableDeviceCell: UITableViewCell {
    
    var labelNumber: UILabel!

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
        label.textColor = UIColor(rgb: 0x00A778)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentView.addSubview(label)
        self.labelNumber = label
                    
        NSLayoutConstraint.activate([
            
            self.labelNumber!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.labelNumber!.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.labelNumber!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .clear
//            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//            labelNumber.theme.textColor = themed{ $0.navigationTintColor }
//            labelVersion.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            contentView.backgroundColor = .clear
//            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
//            labelNumber.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
//            labelVersion.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
