//
//  MapCollectionPhotoPlaceCell.swift
//  Escort
//
//  Created by Володя Зверев on 14.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class MapCollectionPhotoPlaceCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    weak var viewMainList: UIView!
    weak var imageAdd: UIImageView!
    weak var imageDelete: UIImageView!

    var imagesPreView: UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleToFill
            img.translatesAutoresizingMaskIntoConstraints = false
            img.layer.borderWidth = 2
            img.layer.borderColor = UIColor.orange.cgColor
            img.layer.cornerRadius = 35
            img.clipsToBounds = true
            return img
        }()

    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.imagesPreView.layer.masksToBounds = true
        }


    override init(frame: CGRect) {
                super.init(frame: frame)
        self.initialize()
        imagesPreView = UIImageView()
        addSubview(imagesPreView)
        textLabel = UILabel()
        textLabel.text = "sadsdasda"
        addSubview(textLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        let imageAdd = UIImageView()
        imageAdd.frame = CGRect(x: 0, y: 0, width: 75, height: 60)
        imageAdd.layer.cornerRadius = 5
        imageAdd.clipsToBounds = true
        self.contentView.addSubview(imageAdd)
        self.imageAdd = imageAdd
        
        let imageDelete = UIImageView()
        imageDelete.frame = CGRect(x: 52, y: 3, width: 20, height: 20)
        imageDelete.image = #imageLiteral(resourceName: "Group 22")
        self.contentView.addSubview(imageDelete)
        self.imageDelete = imageDelete
//        let viewMainList = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 60))
//        viewMainList.backgroundColor = .brown
//        viewMainList.layer.shadowRadius = 3.0
//        viewMainList.layer.shadowOpacity = 0.2
//        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        self.contentView.addSubview(viewMainList)
//        self.viewMainList = viewMainList
    }


    override func layoutSubviews() {
    super.layoutSubviews()

//    var frame = videoPreView.frame
//    videoPreView.frame = frame
    }
}
