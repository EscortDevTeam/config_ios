//
//  MapLvlTopTwoCell.swift
//  Escort
//
//  Created by Володя Зверев on 06.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

class MapLvlTopTwoCell: UITableViewCell {
    
    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    weak var photoLabel: UILabel!
    weak var openButton: UILabel!
    weak var deleteButton: UILabel!
    
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

        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 100))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList


        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth/2-40, height: 30)
        titleLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let photoLabel = UILabel()
        photoLabel.frame = CGRect(x: screenWidth/2, y: 25, width: screenWidth/2-40, height: 30)
        photoLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        self.contentView.addSubview(photoLabel)
        self.photoLabel = photoLabel

        let openButton = UILabel()
        openButton.frame = CGRect(x: 40, y: 65, width: screenWidth/4, height: 30)
        openButton.font = UIFont(name:"FuturaPT-Medium", size: (iphone5s ? 22.0 : 26.0))
        openButton.textColor = .red
        self.contentView.addSubview(openButton)
        self.openButton = openButton
        
        let deleteButton = UILabel()
        deleteButton.frame = CGRect(x: screenWidth/4 + 50, y: 65, width: screenWidth/4, height: 30)
        deleteButton.font = UIFont(name:"FuturaPT-Medium", size: (iphone5s ? 22.0 : 26.0))
        deleteButton.textColor = .red
        self.contentView.addSubview(deleteButton)
        self.deleteButton = deleteButton

        NSLayoutConstraint.activate([
        ])

        setupTheme()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            photoLabel.theme.textColor = themed { $0.navigationTintColor }
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            photoLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            
        }
    }
}

