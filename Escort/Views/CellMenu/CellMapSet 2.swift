//
//  CellMapSet.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class CellMapSet: UITableViewCell {

    weak var mainSettings: UIImageView!
    weak var labelSettingDut: UILabel!
    weak var labelSettingDutInfo: UILabel!
    weak var labelBeta: UILabel!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        let mainSettings = UIImageView()
        mainSettings.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth+18)/2.092)
        self.contentView.addSubview(mainSettings)
        self.mainSettings = mainSettings
        
        let labelSettingDut = UILabel()
        labelSettingDut.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        labelSettingDut.frame = CGRect(x: screenWidth/2 + 20, y: screenWidth/2.092*0.35, width: screenWidth/2, height: 30)
        labelSettingDut.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDut.textAlignment = .left
        self.contentView.addSubview(labelSettingDut)
        self.labelSettingDut = labelSettingDut
        
        let labelSettingDutInfo = UILabel()
        labelSettingDutInfo.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        labelSettingDutInfo.frame = CGRect(x: screenWidth/2 + 20, y: screenWidth/2.092*0.45, width: screenWidth/2-40, height: 60)
        labelSettingDutInfo.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDutInfo.numberOfLines = 0
        labelSettingDutInfo.textAlignment = .left
        self.contentView.addSubview(labelSettingDutInfo)
        self.labelSettingDutInfo = labelSettingDutInfo
        
        let labelBeta = UILabel()
        let ui = UIView()
        ui.frame = CGRect(x: screenWidth/2 + 40, y: screenWidth/2.092*0.20, width: 50, height: 30)
        ui.layer.borderColor = UIColor(rgb: 0x005CDF).cgColor
        ui.layer.borderWidth = 2
        ui.backgroundColor = .clear
        ui.layer.cornerRadius = 5
        labelBeta.font = UIFont(name:"FuturaPT-Medium", size: 14.0)
        labelBeta.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        labelBeta.textColor = UIColor(rgb: 0x005CDF)
        labelBeta.text = "βETA"
        labelBeta.textAlignment = .center
        ui.addSubview(labelBeta)
        self.contentView.addSubview(ui)
        self.labelBeta = labelBeta
        
        setupTheme()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            labelSettingDut.theme.textColor = themed { $0.imageColorMenu }
            labelSettingDutInfo.theme.textColor = themed { $0.infoColor }
        } else {
            // Fallback on earlier versions
        }
    }
}

