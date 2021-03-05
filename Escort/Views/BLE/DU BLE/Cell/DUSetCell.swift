//
//  DUSetCell.swift
//  Escort
//
//  Created by Володя Зверев on 18.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class DUSetCell: UITableViewCell {
    
//    var content: UIView!
    var setButton: UIButton!

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
        
        let button = UIButton()
        button.setTitle("Set".localized(code), for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(rgb: 0xE80000)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: screenWidth / 23)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSet), for: .touchUpInside)
        contentView.addSubview(button)
        self.setButton = button

        
        
        NSLayoutConstraint.activate([
//            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
//            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
//            self.content!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            self.content!.bottomAnchor.constraint(equalTo: self.imageUI!.bottomAnchor, constant: 25),
            self.setButton!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.setButton!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.setButton.heightAnchor.constraint(equalToConstant: 45),
            self.setButton.widthAnchor.constraint(equalToConstant: screenWidth / 2),
            self.setButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.setButton!.topAnchor.constraint(equalTo: contentView.topAnchor),

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
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    @objc func actionSet() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
