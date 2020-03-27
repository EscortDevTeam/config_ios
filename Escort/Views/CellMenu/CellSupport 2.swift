//
//  CellSupport.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class CellSupport: UITableViewCell {

    weak var mainSettings: UIImageView!
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
        mainSettings.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth)/2.011)
        self.contentView.addSubview(mainSettings)
        self.mainSettings = mainSettings
        
        let labelSettingDut = UILabel()
        labelSettingDut.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        labelSettingDut.frame = CGRect(x: screenWidth/2 + 30, y: screenWidth/2.011*0.35, width: screenWidth/2, height: 30)
        labelSettingDut.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDut.textAlignment = .left
        self.contentView.addSubview(labelSettingDut)
        self.labelSettingDut = labelSettingDut
        
        let labelSettingDutInfo = UILabel()
        labelSettingDutInfo.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        labelSettingDutInfo.frame = CGRect(x: screenWidth/2 + 30, y: screenWidth/2.011*0.5, width: screenWidth/2, height: 30)
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
        } else {
            // Fallback on earlier versions
        }
//        titleLabel.theme.textColor = themed { $0.navigationTintColor }
//        viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//        setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
    }
}

