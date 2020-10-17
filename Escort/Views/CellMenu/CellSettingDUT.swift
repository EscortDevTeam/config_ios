//
//  CellSettingDUT.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class CellSettingDUT: UITableViewCell {

    weak var mainSettings: UIImageView!
    weak var mainSettingsLabel: UILabel!
    weak var versionLabel: UILabel!
    weak var labelSettingDut: UILabel!
    weak var labelSettingDutInfo: UILabel!

 
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
        mainSettings.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth)/1.415)
        self.contentView.addSubview(mainSettings)
        self.mainSettings = mainSettings
        
        let mainSettingsLabel = UILabel()
        mainSettingsLabel.frame = CGRect(x: 0, y: 20, width: screenWidth-30, height: 30)
        mainSettingsLabel.font = UIFont(name:"FuturaPT-Medium", size: 24.0)
        mainSettingsLabel.textColor = .white
        mainSettingsLabel.textAlignment = .center
        mainSettingsLabel.center.x = screenWidth/2
        self.contentView.addSubview(mainSettingsLabel)
        self.mainSettingsLabel = mainSettingsLabel
        
        let versionLabel = UILabel()
        versionLabel.frame = CGRect(x: 0, y: 20, width: screenWidth-10, height: 30)
        versionLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        versionLabel.textColor = .white
        versionLabel.textAlignment = .right
        versionLabel.center.x = screenWidth/2
        self.contentView.addSubview(versionLabel)
        self.versionLabel = versionLabel
        
        let labelSettingDut = UILabel()
        labelSettingDut.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        labelSettingDut.frame = CGRect(x: 17, y: screenWidth/1.415*0.55, width: screenWidth/2, height: 30)
        labelSettingDut.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDut.textAlignment = .left
        self.contentView.addSubview(labelSettingDut)
        self.labelSettingDut = labelSettingDut
        
        let labelSettingDutInfo = UILabel()
        labelSettingDutInfo.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        labelSettingDutInfo.frame = CGRect(x: 17, y: screenWidth/1.415*0.65, width: screenWidth/2, height: 30)
        labelSettingDutInfo.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDutInfo.numberOfLines = 0
        labelSettingDutInfo.textAlignment = .left
        self.contentView.addSubview(labelSettingDutInfo)
        self.labelSettingDutInfo = labelSettingDutInfo

        setupTheme()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            labelSettingDut.theme.textColor = themed { $0.imageColorMenu }
            labelSettingDutInfo.theme.textColor = themed { $0.infoColor }
            mainSettingsLabel.theme.textColor = themed { $0.backgroundNavigationColor }
        } else {
            labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            labelSettingDutInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x0C005A)
            mainSettingsLabel.textColor = UIColor(rgb: isNight ? 0x000000 : 0xFFFFFF)
        }
//        setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
    }
}

