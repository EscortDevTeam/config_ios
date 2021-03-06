//
//  TirirovkaCellViewController.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class TirirovkaCellViewController: UITableViewCell {
    
    weak var coverView: UIView!
    weak var titleLabel: UILabel!
    weak var levelLabel: UILabel!
    weak var separetor: UIView!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        let coverView = UIView(frame: CGRect(x: 0, y: 5, width: screenWidth, height: 52))
//        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.layer.borderWidth = 2
        coverView.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        coverView.layer.cornerRadius = 5
        self.contentView.addSubview(coverView)
        self.coverView = coverView
        
        let separetor = UIView(frame: CGRect(x: screenWidth/2-1, y: 5, width: 2, height: 52))
        separetor.backgroundColor = UIColor(rgb: 0x959595)
        self.contentView.addSubview(separetor)
        self.separetor = separetor
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let levelLabel = UILabel(frame: .zero)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(levelLabel)
        self.levelLabel = levelLabel

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.coverView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.coverView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.coverView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.coverView.trailingAnchor),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor, constant: screenWidth/4),
            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.levelLabel.centerXAnchor, constant: -screenWidth/4),
            self.contentView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor),
        ])
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
//        self.titleLabel.textColor = .white
        self.levelLabel.font = UIFont.systemFont(ofSize: 18)
//        self.levelLabel.textColor = .white
        setupTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    fileprivate func setupTheme() {
        
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            levelLabel.theme.textColor = themed { $0.navigationTintColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            levelLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
