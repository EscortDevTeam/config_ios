//
//  GrafficsParametrCell.swift
//  Escort
//
//  Created by Володя Зверев on 15.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class GrafficsParametrCell: UICollectionViewCell {
    
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
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let viewMainList = UIView()
        viewMainList.backgroundColor = .gray
        viewMainList.translatesAutoresizingMaskIntoConstraints = false
        viewMainList.layer.cornerRadius = 10
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList

        let textLabel = UILabel()
        textLabel.backgroundColor = .clear
        textLabel.layer.cornerRadius = 10
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 1
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name:"FuturaPT-Light", size: screenHeight / 45)
        self.viewMainList.addSubview(textLabel)
        self.textLabel = textLabel
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            self.viewMainList.leftAnchor.constraint(equalTo: leftAnchor),
            self.viewMainList.rightAnchor.constraint(equalTo: rightAnchor),
            self.viewMainList.topAnchor.constraint(equalTo: topAnchor),
            self.viewMainList.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            self.textLabel!.centerXAnchor.constraint(equalTo: self.viewMainList!.centerXAnchor),
            self.textLabel!.centerYAnchor.constraint(equalTo: self.viewMainList!.centerYAnchor),
            self.textLabel!.leadingAnchor.constraint(equalTo: self.viewMainList!.leadingAnchor, constant: 5),
            self.textLabel!.trailingAnchor.constraint(equalTo: self.viewMainList!.trailingAnchor, constant: -5),




        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
