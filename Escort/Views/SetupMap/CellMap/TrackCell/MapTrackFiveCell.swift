//
//  MaptrackFiveCell.swift
//  Escort
//
//  Created by Володя Зверев on 06.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

class MapTrackFiveCell: UITableViewCell {
    
    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    weak var setupMapTableTextField: UITextField!
    weak var separetor: UIView!
    weak var referenceImage: UIImageView!

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

        
        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 80))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList
        
        let setupMapTableTextField = UITextField()
        setupMapTableTextField.backgroundColor = .clear
        setupMapTableTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: setupMapTableTextField.frame.height))
        setupMapTableTextField.leftViewMode = .always
        setupMapTableTextField.attributedPlaceholder = NSAttributedString(string: "Не обязательно", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTableTextField.frame = CGRect(x: 35, y: 40, width: screenWidth / 1.4, height: 46)
        setupMapTableTextField.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        setupMapTableTextField.addTarget(self, action: #selector(self.textFieldDidChangeSecond(_:)),for: UIControl.Event.editingChanged)

        self.contentView.addSubview(setupMapTableTextField)
        self.setupMapTableTextField = setupMapTableTextField

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth-80, height: 20)
        titleLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        
        let separetor = UIView()
        separetor.frame = CGRect(x: 40, y: 75, width: screenWidth/1.4, height: 2)
        separetor.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        separetor.layer.cornerRadius = 1
        self.contentView.addSubview(separetor)
        self.separetor = separetor
        
        let referenceImage = UIImageView()
        referenceImage.frame = CGRect(x: 40, y: 23, width: 23, height: 23)
        referenceImage.center.x = 250
        referenceImage.image = isNight ? #imageLiteral(resourceName: "справка черная") : #imageLiteral(resourceName: "справка белая")
        self.contentView.addSubview(referenceImage)
        self.referenceImage = referenceImage
        
        setupTheme()
    }
    
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        print(textField.text!)
        infoTrackText = textField.text!
        UserDefaults.standard.set(infoTrackText, forKey: "infoTrackTextMap")
        
        checkMaxLength(textField: textField, maxLength: 200)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            setupMapTableTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        }

    }
}

