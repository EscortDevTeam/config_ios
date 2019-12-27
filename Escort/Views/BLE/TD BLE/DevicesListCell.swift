//
//  DevicesListCell.swift
//  Escort
//
//  Created by Володя Зверев on 16.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.

import UIKit

class DevicesListCell: UITableViewCell {
    
    weak var coverView: UIView!
    weak var titleLabel: UILabel!
    weak var levelLabel: UILabel!
    weak var macAdres: UILabel!
    weak var FW: UILabel!
    weak var T: UILabel!
    weak var Lvl: UILabel!
    weak var Vbat: UILabel!


    weak var separetor: UIView!
    weak var btnConnet: UIView!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        let coverView = UIView(frame: CGRect(x: 16, y: -2, width: screenWidth-32, height: 55))
//        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.layer.borderWidth = 2
        coverView.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        coverView.layer.cornerRadius = 5
        self.contentView.addSubview(coverView)
        self.coverView = coverView
//        
//        let separetor = UIView(frame: CGRect(x: screenWidth/2-1, y: 5, width: 2, height: 52))
//        separetor.backgroundColor = UIColor(rgb: 0x959595)
//        self.contentView.addSubview(separetor)
//        self.separetor = separetor
        
//        let btnConnet = UIView(frame: CGRect(x: Int(screenWidth-140-40), y: 12, width: 140, height: 44))
//        btnConnet.translatesAutoresizingMaskIntoConstraints = false
//        btnConnet.backgroundColor = UIColor(rgb: 0xCF2121)
//        btnConnet.layer.cornerRadius = 22
//        self.contentView.addSubview(btnConnet)
//        self.btnConnet = btnConnet
        let macAdres = UILabel(frame: CGRect(x: 30, y: 5, width: 200, height: 15))
//        macAdres.translatesAutoresizingMaskIntoConstraints = false
        macAdres.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        self.contentView.addSubview(macAdres)
        self.macAdres = macAdres
        
        let FW = UILabel(frame: CGRect(x: 30, y: 5, width: 100, height: 15))
//        FW.translatesAutoresizingMaskIntoConstraints = false
        FW.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        self.contentView.addSubview(FW)
        self.FW = FW
        
        let T = UILabel(frame: CGRect(x: 30, y: 30, width: 200, height: 15))
//        T.translatesAutoresizingMaskIntoConstraints = false
        T.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        self.contentView.addSubview(T)
        self.T = T
        
        let Lvl = UILabel(frame: CGRect(x: Int(screenWidth-140-20), y: 5, width: 100, height: 15))
//        Lvl.translatesAutoresizingMaskIntoConstraints = false
        Lvl.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        self.contentView.addSubview(Lvl)
        self.Lvl = Lvl
        
        let Vbat = UILabel(frame: CGRect(x: Int(screenWidth-140-20), y: 30, width: 100, height: 15))
//        Vbat.translatesAutoresizingMaskIntoConstraints = false
        Vbat.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        self.contentView.addSubview(Vbat)
        self.Vbat = Vbat

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
            
//            self.contentView.centerXAnchor.constraint(equalTo: self.btnConnet.centerXAnchor, constant: screenWidth/2),
//            self.contentView.centerYAnchor.constraint(equalTo: self.btnConnet.centerYAnchor),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.levelLabel.centerXAnchor, constant: -screenWidth/4),
            self.contentView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor),
        ])
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.titleLabel.textColor = .white
        self.levelLabel.font = UIFont.systemFont(ofSize: 18)
        self.levelLabel.textColor = .white
        setupTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        coverView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        macAdres.theme.textColor = themed { $0.navigationTintColor }
        FW.theme.textColor = themed { $0.navigationTintColor }
        T.theme.textColor = themed { $0.navigationTintColor }
        Lvl.theme.textColor = themed { $0.navigationTintColor }
        Vbat.theme.textColor = themed { $0.navigationTintColor }
        titleLabel.theme.textColor = themed { $0.navigationTintColor }
        levelLabel.theme.textColor = themed { $0.navigationTintColor }
    }
}

