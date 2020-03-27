//
//  CellSettings.swift
//  Escort
//
//  Created by Володя Зверев on 05.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//


import UIKit

class CellSettings: UITableViewCell {

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
        mainSettings.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth)/2)
        self.contentView.addSubview(mainSettings)
        self.mainSettings = mainSettings
        
        let labelSettingDut = UILabel()
        labelSettingDut.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        labelSettingDut.frame = CGRect(x: 17, y: screenWidth/2 * (iphone5s ? 0.3 : 0.4), width: screenWidth/2, height: 60)
        labelSettingDut.textColor = UIColor(rgb: 0x0C005A)
        labelSettingDut.textAlignment = .center
        labelSettingDut.numberOfLines = 0
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
        } else {
            // Fallback on earlier versions
        }
//        titleLabel.theme.textColor = themed { $0.navigationTintColor }
//        viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//        setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
    }
}

