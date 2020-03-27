//
//  MapTrackZeroCell.swift
//  Escort
//
//  Created by Володя Зверев on 06.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class MapTrackZeroCell: UITableViewCell {

    weak var titleLabel: UILabel!
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

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 30, y: hasNotch ? 10 : 35, width: screenWidth/2-30, height: 30)
        titleLabel.font = UIFont(name:"FuturaPT-Medium", size: 24.0)
//        titleLabel.textAlignment = .right
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel


        NSLayoutConstraint.activate([

        ])
        setupTheme()
    }
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
//        titleRSSI.theme.textColor = themed { $0.navigationTintColor }
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}

