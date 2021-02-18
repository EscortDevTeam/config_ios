//
//  RedLineCell.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class RedLineCell: UITableViewCell {
    
    var imageUI: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {

        let imageUI = UIView()
        imageUI.backgroundColor = .red
        imageUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageUI)
        self.imageUI = imageUI
        
        NSLayoutConstraint.activate([
            
            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.imageUI!.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.imageUI!.widthAnchor.constraint(equalToConstant: screenWidth / 2.5),
            self.imageUI!.heightAnchor.constraint(equalToConstant: 1),

        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .clear
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
