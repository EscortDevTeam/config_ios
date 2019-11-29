//
//  TarirovkaSettingsViewControllet.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class TarirovkaSettingsViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        let (headerView, backView) = headerSet(title: "Tank calibration".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        view.addSubview(bgImage)
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        var yHeight = 88
        let slivButton = UIButton(frame: CGRect(x: 25, y: yHeight, width: Int(screenWidth/2-50), height: 43))
        slivButton.layer.cornerRadius = 20
        slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
        slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
        view.addSubview(slivButton)
        
        let zalivButton = UIButton(frame: CGRect(x: Int(screenWidth/2+25), y:yHeight, width: Int(screenWidth/2-50), height: 43))
        zalivButton.layer.cornerRadius = 20
        zalivButton.layer.borderWidth = 1
        zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
        view.addSubview(zalivButton)
        
        yHeight = yHeight + 77
        
        let nameFileField = UITextField(frame: CGRect(x: 25, y: yHeight, width: Int(screenWidth - 50), height: 36))
        nameFileField.layer.cornerRadius = 2
        nameFileField.layer.borderWidth = 1
        nameFileField.textColor = .white
        nameFileField.placeholder = "Enter file name".localized(code)
        nameFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        nameFileField.leftViewMode = .always
        nameFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        view.addSubview(nameFileField)
        
        yHeight = yHeight + 48
        
        let stepFileField = UITextField(frame: CGRect(x: 25, y: yHeight, width: Int(screenWidth - 50), height: 36))
        stepFileField.layer.cornerRadius = 2
        stepFileField.layer.borderWidth = 1
        stepFileField.textColor = .white
        stepFileField.placeholder = "Step".localized(code)
        stepFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        stepFileField.leftViewMode = .always
        stepFileField.keyboardType = .numberPad
        stepFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        view.addSubview(stepFileField)
        
        yHeight = yHeight + 52
        
        let startVBacFileField = UITextField(frame: CGRect(x: 25, y: yHeight, width: Int(screenWidth - 50), height: 36))
        startVBacFileField.layer.cornerRadius = 2
        startVBacFileField.layer.borderWidth = 1
        startVBacFileField.textColor = .white
        startVBacFileField.placeholder = "Initial tank volume".localized(code)
        startVBacFileField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameFileField.frame.height))
        startVBacFileField.leftViewMode = .always
        startVBacFileField.keyboardType = .numberPad
        startVBacFileField.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        view.addSubview(startVBacFileField)
        
        yHeight = yHeight + 52
        
        let nextButton = UIButton(frame: CGRect(x: Int(screenWidth/2+25), y:yHeight, width: Int(screenWidth/2-50), height: 43))
        nextButton.layer.cornerRadius = 20
        nextButton.backgroundColor = UIColor(rgb: 0xCF2121)
        nextButton.setTitle("Continue Next".localized(code), for: UIControl.State.normal)
        view.addSubview(nextButton)
        
        slivButton.addTapGesture {
            self.view.addSubview(startVBacFileField)
            nextButton.removeFromSuperview()
            nextButton.frame = CGRect(x: Int(screenWidth/2+25), y: yHeight, width: Int(screenWidth/2-50), height: 43)
            self.view.addSubview(nextButton)
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.layer.borderWidth = 0
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.backgroundColor = .clear
        }
        zalivButton.addTapGesture {
            startVBacFileField.removeFromSuperview()
            nextButton.removeFromSuperview()
            nextButton.frame = CGRect(x: Int(screenWidth/2+25), y: yHeight-52, width: Int(screenWidth/2-50), height: 43)
            self.view.addSubview(nextButton)
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.layer.borderWidth = 0
            
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.backgroundColor = .clear
        }
    }
}
