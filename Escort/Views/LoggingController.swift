//
//  Logging.swift
//  Escort
//
//  Created by Володя Зверев on 25.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation
import UIKit

class LoggingController: UIViewController, UINavigationControllerDelegate {
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    let picker = UIPickerView()
    let labelDays = UILabel()
    let labelHours = UILabel()
    let stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
        registgerPickerView()
        createLabelHoursOrDays(label: labelDays, name: "дней", centerX: 1)
        createLabelHoursOrDays(label: labelHours, name: "часов", centerX: 2)
        
        view.addSubview(stack)
        getButton.addTarget(self, action: #selector(onButtonClick(_:)), for: UIControl.Event.touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        picker.selectRow(6, inComponent: 0, animated: true)
        picker.selectRow(16, inComponent: 1, animated: true)

        
    }
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    @objc private func onButtonClick(_ sender: UIButton) {
        reload = 11
        print("reload: \(reload)")
    }
    
    lazy var getButton: UIButton = {
        let getButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth / 2, height: 50)))
        getButton.setTitle("Выдать всё", for: .normal)
        getButton.tintColor = .white
        getButton.layer.cornerRadius = 20
        getButton.backgroundColor = UIColor(rgb: 0xE80000)
        getButton.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 20)!
       return getButton
    }()
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
   
    lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
        text.text = "Select connection type".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()

    lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0) )
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
}

extension LoggingController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 31
        } else {
            return 24
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else {
            return "\(row + 1)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
            label?.textColor = isNight ? UIColor.white : UIColor.black
        }
        switch component {
        case 0:
            label?.text = "\(row)"
            label?.font = UIFont(name:"FuturaPT-Light", size: 45)
            label?.textAlignment = .center
            return label!
        case 1:
            label?.text = "\(row + 1)"
            label?.font = UIFont(name:"FuturaPT-Light", size: 45)
            label?.textAlignment = .center
            return label!
        default:
            return label!
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            switch row {
            case 0,5...20,25...30:
                labelDays.text = "дней"
            case 1,21:
                labelDays.text = "день"
            case 2...4,22...24:
                labelDays.text = "дня"
            default:
                print("default")
            }
        } else {
            switch row {
            case 4...19:
                labelHours.text = "часов"
            case 0,20:
                labelHours.text = "час"
            case 1...4,21...23:
                labelHours.text = "часа"
            default:
                print("default")
            }
        }
    }
}
