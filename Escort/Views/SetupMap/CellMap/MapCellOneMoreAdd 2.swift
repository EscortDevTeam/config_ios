//
//  MapCellOneMoreAdd.swift
//  Escort
//
//  Created by Володя Зверев on 26.01.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class MapCellOneMoreAdd: UITableViewCell {

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
        titleLabel.frame = CGRect(x: screenWidth/2, y: 25, width: screenWidth/2-30, height: 20)
        titleLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        titleLabel.textAlignment = .right
        titleLabel.textColor = .red
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
//        titleLabel.theme.textColor = themed { $0.navigationTintColor }
    }
}

