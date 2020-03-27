//
//  AddSensorCellFive.swift
//  Escort
//
//  Created by Володя Зверев on 12.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

class AddSensorCellFive: UITableViewCell {
    
    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    weak var separetor: UIView!
    weak var fileLater: UIView!
    weak var fileAdd: UIView!
    weak var fileEdit: UILabel!
    weak var mapHelpButton : UIButton!

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

        
        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 95))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth/2, height: 30)
        titleLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        let fileEdit = UILabel(frame: CGRect(x: 40, y: 60, width: screenWidth-80, height: 35))
        fileEdit.text = "Тарировочный файл.csv"
        fileEdit.textColor = UIColor(rgb: 0xE80000)
        fileEdit.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        self.contentView.addSubview(fileEdit)
        self.fileEdit = fileEdit
        
        let fileLater = UIView(frame: CGRect(x: 40, y: 60, width: screenWidth/3, height: 35))
        fileLater.backgroundColor = UIColor(rgb: 0xE80000)
        fileLater.layer.cornerRadius = 10
        let fileName = UILabel(frame: CGRect(x: 0, y: 0, width: fileLater.bounds.width, height: fileLater.bounds.height))
        fileName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        fileName.textColor = .white
        fileName.center.x = fileLater.bounds.width/2
        fileName.textAlignment = .center
        let fullString = NSMutableAttributedString(string: "Прикрепить ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image =  #imageLiteral(resourceName: "Vector-5")
        image1Attachment.bounds.size = CGSize(width: 13, height: 13)
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fileName.attributedText = fullString
        fileLater.addSubview(fileName)
        self.contentView.addSubview(fileLater)
        self.fileLater = fileLater

        let fileAdd = UIView(frame: CGRect(x: screenWidth/2, y: 60, width: screenWidth/4, height: 35))
        fileAdd.backgroundColor = .clear
        fileAdd.layer.borderColor = UIColor(rgb: 0xE80000).cgColor
        fileAdd.layer.borderWidth = 2
        fileAdd.layer.cornerRadius = 10
        let fileName2 = UILabel(frame: CGRect(x: 0, y: 0, width: fileAdd.bounds.width, height: fileAdd.bounds.height))
        fileName2.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        fileName2.textColor = .white
        fileName2.center.x = fileAdd.bounds.width/2
        fileName2.textAlignment = .center
        let fullString2 = NSMutableAttributedString(string: "Создать ")
        let image1Attachment2 = NSTextAttachment()
        image1Attachment2.image =  #imageLiteral(resourceName: "Vector-6")
        image1Attachment2.bounds.size = CGSize(width: 13, height: 13)
        let image1String2 = NSAttributedString(attachment: image1Attachment2)
        fullString2.append(image1String2)
        fileName2.attributedText = fullString2
        fileName2.textColor = UIColor(rgb: 0xE80000)
        fileAdd.addSubview(fileName2)
        self.contentView.addSubview(fileAdd)
        self.fileAdd = fileAdd
        
        if addORopen {
            let mapHelpButton = UIButton()
            mapHelpButton.backgroundColor = UIColor(rgb: 0xE80000)
            mapHelpButton.frame = CGRect(x: 0, y: 140, width: screenWidth / 2.5 + (iphone5s ? 20 : 0), height: 46)
            mapHelpButton.center.x = screenWidth/2
            mapHelpButton.layer.cornerRadius = 8
            mapHelpButton.setTitle("Добавить датчик".localized(code), for: .normal)
            mapHelpButton.titleLabel?.font =  UIFont(name: "FuturaPT-Medium", size: 20)
            mapHelpButton.titleLabel?.textColor = .white
            self.contentView.addSubview(mapHelpButton)
            self.mapHelpButton = mapHelpButton
        } else {
            let mapHelpButton = UIButton()
            mapHelpButton.backgroundColor = UIColor(rgb: 0xE80000)
            mapHelpButton.frame = CGRect(x: 0, y: 140, width: screenWidth / 2.5, height: 46)
            mapHelpButton.center.x = screenWidth/2
            mapHelpButton.layer.cornerRadius = 8
            mapHelpButton.setTitle("Сохранить".localized(code), for: .normal)
            mapHelpButton.titleLabel?.font =  UIFont(name: "FuturaPT-Medium", size: 20)
            mapHelpButton.titleLabel?.textColor = .white
            self.contentView.addSubview(mapHelpButton)
            self.mapHelpButton = mapHelpButton
        }
        setupTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
       }
    }
}

