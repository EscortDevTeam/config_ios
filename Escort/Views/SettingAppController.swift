//
//  SettingsApp.swift
//  Escort
//
//  Created by Володя Зверев on 05.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

//
//  LanguageSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 01.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class SettingAppController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.removeFromSuperview()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 0, y: dIy + (hasNotch ? dIPrusy+20 : 20) + dy, width: Int(screenWidth), height: 40))
        text.text = "About the program".localized(code)
        text.textAlignment = .center
        text.font = UIFont(name:"BankGothicBT-Medium", size: 30.0)
        return text
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: 5, width: screenWidth/5, height: 20)
        backView.center.x = screenWidth/2
        let back = UIView()
        if isNight {
            back.backgroundColor = .white
        } else {
            back.backgroundColor = .black

        }
        back.layer.cornerRadius = 2
        back.frame = CGRect(x: 8, y: 0 , width: backView.bounds.width-15, height: 4)
        back.center.y = backView.bounds.height/2
        back.center.x = backView.bounds.width/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var version: UILabel = {
        let version = UILabel(frame: CGRect(x: 10, y: headerHeight, width: screenWidth/2, height: 30))
        version.text = "VERSION".localized(code)
        version.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return version
    }()
    fileprivate lazy var versionView: UIView = {
        let versionView = UIView(frame: CGRect(x: 0, y: 35+Int(headerHeight), width: Int(screenWidth), height: 40))
        return versionView
    }()
    fileprivate lazy var versionViewLabel: UILabel = {
        let versionViewLabel = UILabel(frame: CGRect(x: 10, y: 5, width: screenWidth, height: 30))
        versionViewLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return versionViewLabel
    }()
    
    fileprivate lazy var address: UILabel = {
        let address = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + 100, width: Int(screenWidth/2), height: 30))
        address.text = "ADDRESS".localized(code)
        address.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return address
    }()
    fileprivate lazy var addressView: UIView = {
        let addressView = UIView(frame: CGRect(x: 0, y: 135+Int(headerHeight), width: Int(screenWidth), height: 70))
        return addressView
    }()
    fileprivate lazy var addressViewLabel: UILabel = {
        let addressViewLabel = UILabel(frame: CGRect(x: 10, y: 5, width: screenWidth-20, height: 60))
        addressViewLabel.text = "addressMain".localized(code)
        addressViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        addressViewLabel.numberOfLines = 0
        return addressViewLabel
    }()
    
    fileprivate lazy var phone: UILabel = {
        let phone = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + 220, width: Int(screenWidth/2), height: 30))
        phone.text = "TELEPHONES".localized(code)
        phone.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return phone
    }()
    fileprivate lazy var phoneView: UIView = {
        let phoneView = UIView(frame: CGRect(x: 0, y: 255+Int(headerHeight), width: Int(screenWidth), height: 70))
        return phoneView
    }()
    fileprivate lazy var phoneViewLabel: UILabel = {
        let phoneViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth-20, height: 30))
        phoneViewLabel.text = "+7(495)108-68-33 - \("phoneRus".localized(code))"
        phoneViewLabel.addTapGesture {
            self.makeAPhoneCall()
        }
        phoneViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        phoneViewLabel.numberOfLines = 0
        return phoneViewLabel
    }()
    
    fileprivate lazy var phoneViewLabelTwo: UILabel = {
        let phoneViewLabelTwo = UILabel(frame: CGRect(x: 30, y: 35, width: screenWidth-20, height: 30))
        phoneViewLabelTwo.text = "+7(800)777-16-03 - \("phoneRus".localized(code))"
        phoneViewLabelTwo.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        phoneViewLabelTwo.numberOfLines = 0
        return phoneViewLabelTwo
    }()
    fileprivate lazy var email: UILabel = {
        let email = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + 340, width: Int(screenWidth/2), height: 30))
        email.text = "EMAIL".localized(code)
        email.textColor = .white
        email.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return email
    }()
    fileprivate lazy var emailView: UIView = {
        let emailView = UIView(frame: CGRect(x: 0, y: 375+Int(headerHeight), width: Int(screenWidth), height: 40))
        return emailView
    }()
    fileprivate lazy var emailViewLabel: UILabel = {
        let emailViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth-20, height: 30))
        emailViewLabel.text = "mail@fmeter.ru"
        emailViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        emailViewLabel.numberOfLines = 0
        return emailViewLabel
    }()
    fileprivate lazy var site: UILabel = {
        let site = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + 440, width: Int(screenWidth/2), height: 30))
        site.text = "WEBSITE".localized(code)
        site.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return site
    }()
    fileprivate lazy var siteView: UIView = {
        let siteView = UIView(frame: CGRect(x: 0, y: 475+Int(headerHeight), width: Int(screenWidth), height: 40))
        return siteView
    }()
    fileprivate lazy var siteViewLabel: UILabel = {
        let siteViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth/2+20, height: 30))
        siteViewLabel.text = "https://www.fmeter.ru"
        siteViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        siteViewLabel.numberOfLines = 0
        return siteViewLabel
    }()
    
        private func viewShow() {

        view.addSubview(themeBackView3)
            MainLabel.text = "About the program".localized(code)
            view.addSubview(MainLabel)
            view.addSubview(backView)
            
            backView.addTapGesture{
                self.dismiss(animated: true)
            }
            view.addSubview(bgImage)
            
            view.addSubview(version)
            versionView.addSubview(versionViewLabel)
            view.addSubview(versionView)
            
            view.addSubview(address)
            addressView.addSubview(addressViewLabel)
            view.addSubview(addressView)
            
            
            self.view.addSubview(phone)
            let phonelImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            phonelImage.image = #imageLiteral(resourceName: "icons8-телефон-50")
            phonelImage.image = phonelImage.image!.withRenderingMode(.alwaysTemplate)
            if isNight {
                phonelImage.tintColor = .white
            } else {
                phonelImage.tintColor = .black
            }
            phoneView.addSubview(phoneViewLabel)
            phoneView.addSubview(phonelImage)
            
            let phonelImage2 = UIImageView(frame: CGRect(x: 10, y: 43, width: 15, height: 15))
            phonelImage2.image = #imageLiteral(resourceName: "icons8-телефон-50")
            phonelImage2.image = phonelImage2.image!.withRenderingMode(.alwaysTemplate)
            if isNight {
                phonelImage2.tintColor = .white
            } else {
                phonelImage2.tintColor = .black
            }
            phoneViewLabelTwo.addTapGesture {
                self.makeAPhoneCallTwo()
            }
            phoneView.addSubview(phoneViewLabelTwo)
            phoneView.addSubview(phonelImage2)
            
            self.view.addSubview(phoneView)
            
            self.view.addSubview(email)
            let emailImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            emailImage.image = #imageLiteral(resourceName: "icons8-новый-пост-50")
            emailImage.image = emailImage.image!.withRenderingMode(.alwaysTemplate)
            if isNight {
                emailImage.tintColor = .white
            } else {
                emailImage.tintColor = .black
            }
            emailView.addSubview(emailViewLabel)
            emailView.addSubview(emailImage)
            
            self.view.addSubview(emailView)
            self.view.addSubview(site)
            
            let siteImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            siteImage.image = #imageLiteral(resourceName: "icons8-приключения-24")
            siteImage.image = siteImage.image!.withRenderingMode(.alwaysTemplate)
            if isNight {
                siteImage.tintColor = .white
            } else {
                siteImage.tintColor = .black
            }
            siteView.addSubview(siteViewLabel)
            siteView.addSubview(siteImage)
            siteView.addTapGesture {
                let url = URL(string: "https://www.fmeter.ru")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.view.addSubview(siteView)
    }
    func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://+7(495)108-68-33")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    func makeAPhoneCallTwo()  {
        let url: NSURL = URL(string: "TEL://+7(800)777-16-03")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    fileprivate func setupTheme() {
        view.theme.backgroundColor = themed { $0.backgroundColor }
        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        backView.theme.tintColor = themed{ $0.navigationTintColor }
        version.theme.textColor = themed{ $0.navigationTintColor }
        versionView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        versionViewLabel.theme.textColor = themed{ $0.navigationTintColor }
        address.theme.textColor = themed{ $0.navigationTintColor }
        addressView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        addressViewLabel.theme.textColor = themed{ $0.navigationTintColor }
        
        phone.theme.textColor = themed{ $0.navigationTintColor }
        phoneView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        phoneViewLabel.theme.textColor = themed{ $0.navigationTintColor }
        phoneViewLabelTwo.theme.textColor = themed{ $0.navigationTintColor }
        
        email.theme.textColor = themed{ $0.navigationTintColor }
        emailView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        emailViewLabel.theme.textColor = themed{ $0.navigationTintColor }
        
        site.theme.textColor = themed{ $0.navigationTintColor }
        siteView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        siteViewLabel.theme.textColor = themed{ $0.navigationTintColor }
    }
}
