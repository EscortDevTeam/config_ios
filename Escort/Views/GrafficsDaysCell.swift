//
//  GrafficsDaysCell.swift
//  Escort
//
//  Created by Володя Зверев on 30.07.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class GrafficsDaysCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    weak var viewMainList: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        let viewMainList = UIView()
        viewMainList.backgroundColor = .gray
        viewMainList.frame = CGRect(x: 0, y: 10, width: 80, height: 30)
        viewMainList.layer.cornerRadius = 10
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList

        let textLabel = UILabel()
        textLabel.backgroundColor = .clear
        textLabel.frame = CGRect(x: 0, y: 10, width: 80, height: 30)
        textLabel.layer.cornerRadius = 10
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name:"FuturaPT-Light", size: 12.0)
        self.contentView.addSubview(textLabel)
        self.textLabel = textLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
