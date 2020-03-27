//
//  TarirovkaSettingsViewControllet.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer

var textName = ""

class TarirovkaSettingsViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        sliv = true
        startVTar = 0
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        viewShow()
        setupTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        warning = false
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()

    
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "tlBleBack")!)
        img.frame = CGRect(x: screenWidth/2, y: screenHeight/6+40, width: 152, height: 166)
        return img
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func textLineCreate(title: String, text: String, x: Int, y: Int) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        
        let lblText = UILabel(frame: CGRect(x: 70, y: 0, width: Int(screenWidth/2), height: 20))
        lblText.text = text
        lblText.textColor = UIColor(rgb: 0xE9E9E9)
        lblText.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        v.addSubview(lblTitle)
        v.addSubview(lblText)
        
        return v
    }
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-60), height: 40))
        text.text = "Tank calibration".localized(code)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    fileprivate lazy var zalivButton: UIButton = {
        let zalivButton = UIButton(frame: CGRect(x: Int(screenWidth/2+25), y: hasNotch ? Int(88) : Int(headerHeight+40), width: Int(screenWidth/2-50), height: 43))
        zalivButton.layer.cornerRadius = 20
        zalivButton.layer.borderWidth = 1
        zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
        return zalivButton
    }()
    fileprivate lazy var slivButton: UIButton = {
        let slivButton = UIButton(frame: CGRect(x: 25, y: hasNotch ? Int(88) : Int(headerHeight+40), width: Int(screenWidth/2-50), height: 43))
        slivButton.layer.cornerRadius = 20
        slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
        slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
        return slivButton
    }()
    fileprivate lazy var nameFileField: UITextField = {
        let nameFileField = UITextField(frame: CGRect(x: 25, y: 77 + (hasNotch ? Int(88) : Int(headerHeight+40)), width: Int(screenWidth - 50), height: 36))
        nameFileField.layer.cornerRadius = 2
        nameFileField.layer.borderWidth = 1
        nameFileField.textColor = .white
        nameFileField.attributedPlaceholder = NSAttributedString(string: "Enter file name".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        nameFileField.leftViewMode = .always
        nameFileField.inputAccessoryView = self.toolBar()
        nameFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        return nameFileField
    }()
    fileprivate lazy var stepFileField: UITextField = {
        let stepFileField = UITextField(frame: CGRect(x: 25, y: 125 + (hasNotch ? Int(88) : Int(headerHeight+40)), width: Int(screenWidth - 50), height: 36))
        stepFileField.layer.cornerRadius = 2
        stepFileField.layer.borderWidth = 1
        stepFileField.textColor = .white
        stepFileField.attributedPlaceholder = NSAttributedString(string: "Step".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        stepFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        stepFileField.leftViewMode = .always
        stepFileField.inputAccessoryView = self.toolBar()
        stepFileField.keyboardType = .numberPad
        stepFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        return stepFileField
    }()
    fileprivate lazy var startVBacFileField: UITextField = {
        let startVBacFileField = UITextField(frame: CGRect(x: 25, y: 177 + (hasNotch ? Int(88) : Int(headerHeight+40)), width: Int(screenWidth - 50), height: 36))
        startVBacFileField.layer.cornerRadius = 2
        startVBacFileField.layer.borderWidth = 1
        startVBacFileField.textColor = .white
        startVBacFileField.attributedPlaceholder = NSAttributedString(string: "Initial tank volume".localized(code), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        startVBacFileField.inputAccessoryView = self.toolBar()
        startVBacFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        startVBacFileField.leftViewMode = .always
        startVBacFileField.keyboardType = .numberPad
        startVBacFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        return startVBacFileField
    }()
    fileprivate lazy var nextTextFile: UILabel = {
        let nextTextFile = UILabel(frame: CGRect(x: 25, y: 281 + (hasNotch ? Int(88) : Int(headerHeight+40)), width: Int(screenWidth-50), height: 60))
        nextTextFile.text = "The file will be saved in the application \"Files\", in the folder \"Escort\"".localized(code)
        nextTextFile.textColor = .white
        nextTextFile.numberOfLines = 0
        nextTextFile.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return nextTextFile
    }()
    
    private func viewShow() {
        view.addSubview(themeBackView3)
        MainLabel.text = "Tank calibration".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        view.addSubview(bgImage)

        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        var yHeight = (hasNotch ? 88 : headerHeight+40)
        
        view.addSubview(slivButton)
        
        view.addSubview(zalivButton)
        
        yHeight = yHeight + 77
        
        view.addSubview(nameFileField)
        
        yHeight = yHeight + 48
        
        view.addSubview(stepFileField)
        
        yHeight = yHeight + 52
        
        view.addSubview(startVBacFileField)
        
        yHeight = yHeight + 52
        
        let nextButton = UIButton(frame: CGRect(x: Int(screenWidth/2+25), y:Int(yHeight), width: Int(screenWidth/2-50), height: 43))
        nextButton.layer.cornerRadius = 20
        nextButton.backgroundColor = UIColor(rgb: 0xCF2121)
        nextButton.setTitle("Continue Next".localized(code), for: UIControl.State.normal)
        view.addSubview(nextButton)

        view.addSubview(nextTextFile)

        slivButton.addTapGesture {
            self.view.addSubview(self.startVBacFileField)
            nextButton.removeFromSuperview()
            nextButton.frame = CGRect(x: Int(screenWidth/2+25), y: Int(yHeight), width: Int(screenWidth/2-50), height: 43)
            self.view.addSubview(nextButton)
            self.slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            self.slivButton.layer.borderWidth = 0
            self.zalivButton.layer.borderWidth = 1
            self.zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            self.zalivButton.backgroundColor = .clear
            if isNight {
                self.zalivButton.setTitleColor(.white, for: .normal)
                self.slivButton.setTitleColor(.white, for: .normal)
            } else {
                self.zalivButton.setTitleColor(.black, for: .normal)
                self.slivButton.setTitleColor(.white, for: .normal)
            }
            sliv = true
        }
        zalivButton.addTapGesture {
            self.startVBacFileField.removeFromSuperview()
            nextButton.removeFromSuperview()
            nextButton.frame = CGRect(x: Int(screenWidth/2+25), y: Int(yHeight-52), width: Int(screenWidth/2-50), height: 43)
            self.view.addSubview(nextButton)
            if isNight {
                self.zalivButton.setTitleColor(.white, for: .normal)
                self.slivButton.setTitleColor(.white, for: .normal)
            } else {
                self.zalivButton.setTitleColor(.white, for: .normal)
                self.slivButton.setTitleColor(.black, for: .normal)
            }
            self.zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            self.zalivButton.layer.borderWidth = 0
            self.startVBacFileField.text = ""
            self.slivButton.layer.borderWidth = 1
            self.slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            self.slivButton.backgroundColor = .clear
            sliv = false
        }
        if nameFileField.text == "" {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = true
        }
        nextButton.addTapGesture {
            if self.nameFileField.text != "" && self.stepFileField.text != "" {
                if sliv == true {
                    if self.startVBacFileField.text != "" {
                        textName = self.nameFileField.text ?? "No name Escort"
                        stepTar = Int(self.stepFileField.text!) ?? 0
                        startVTar = Int(self.startVBacFileField.text!) ?? 0
                        print("startVTar: \(startVTar)")
                        tarNew = true
                        self.navigationController?.pushViewController(TirirovkaTableViewController(), animated: true)
                    } else {
                        self.showToast(message: "Enter".localized(code) + " " + "Initial tank volume".localized(code), seconds: 1.0)
                    }
                } else {
                    textName = self.nameFileField.text ?? "No name Escort"
                    stepTar = Int(self.stepFileField.text!) ?? 0
                    tarNew = true
                    self.navigationController?.pushViewController(TirirovkaTableViewController(), animated: true)
                }
            } else {
                self.showToast(message: "Enter".localized(code) + " " + "Initial tank volume".localized(code) + ", " + "Step".localized(code) + ", " + "Name".localized(code), seconds: 1.0)
            }
        }
    }
    fileprivate func toolBar() -> UIToolbar {
        let bar = UIToolbar()
        let reset = UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done".localized(code), style: .done, target: self, action: #selector(resetTapped))
        bar.setItems([reset,done], animated: false)
        bar.sizeToFit()
        return bar
    }
    @objc func resetTapped() {
        startVBacFileField.endEditing(true)
        stepFileField.endEditing(true)
        nameFileField.endEditing(true)
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            zalivButton.theme.titleColor(from: themed{ $0.navigationTintColor }, for: .normal)
            nameFileField.theme.textColor = themed{ $0.navigationTintColor }
            stepFileField.theme.textColor = themed{ $0.navigationTintColor }
            startVBacFileField.theme.textColor = themed{ $0.navigationTintColor }
            nextTextFile.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            zalivButton.setTitleColor(UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F), for: .normal)
            nameFileField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            stepFileField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            startVBacFileField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            nextTextFile.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
     }
}
