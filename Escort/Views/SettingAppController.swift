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
        
    func updateLangues(code: String){
        if let name0 = parsedData["47"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    wait = name1 as! String
                }
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    wait = name1 as! String
                }
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    wait = name1 as! String
                }
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    wait = name1 as! String
                }
            default:
                print("")
            }
        }
        
        if let name0 = parsedData["132"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    langu = name1 as! String
                }
            case "en":
                if let name1 = dict!["title_en"]{
                    langu = name1 as! String
                }
            case "pr":
                if let name1 = dict!["title_pr"]{
                    langu = name1 as! String
                }
            case "es":
                if let name1 = dict!["title_es"]{
                    langu = name1 as! String
                }
            default:
                print("")
            }
        }
        if let name0 = parsedData["9"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            default:
                print("")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        updateLangues(code: code)
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewShowTwo()
        }
    }
    private func viewShowTwo() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.addSubview(bgImage)
        let (headerView, backView) = headerSet(title:"About the program".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.activityIndicator.stopAnimating()
            backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
                self.view.subviews.forEach({ $0.removeFromSuperview() })
            }
            var y = 35
            let version = UILabel(frame: CGRect(x: 10, y: headerHeight, width: screenWidth/2, height: 30))
            version.text = "ВЕРСИЯ"
            version.textColor = .white
            version.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            self.view.addSubview(version)
            
            let versionView = UIView(frame: CGRect(x: 0, y: y+Int(headerHeight), width: Int(screenWidth), height: 40))
            versionView.backgroundColor = .black
            
            let versionViewLabel = UILabel(frame: CGRect(x: 10, y: 5, width: screenWidth, height: 30))
            versionViewLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            versionViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            versionView.addSubview(versionViewLabel)
            versionViewLabel.textColor = .white

            self.view.addSubview(versionView)
            
            y = y + 100
            var headerCell = 100
            let address = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + headerCell, width: Int(screenWidth/2), height: 30))
            address.text = "АДРЕС"
            address.textColor = .white
            address.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            self.view.addSubview(address)
            
            let addressView = UIView(frame: CGRect(x: 0, y: y+Int(headerHeight), width: Int(screenWidth), height: 70))
            addressView.backgroundColor = .black
            
            let addressViewLabel = UILabel(frame: CGRect(x: 10, y: 5, width: screenWidth-20, height: 60))
            addressViewLabel.text = "420127, Россия, Казань, Респ. Татарстан, yлица Дементьева, 2Б корпус 4"
            addressViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            addressViewLabel.numberOfLines = 0
            addressViewLabel.textColor = .white
            addressView.addSubview(addressViewLabel)
            
            self.view.addSubview(addressView)
            
            y = y + 120
            headerCell = headerCell + 120
            
            let phone = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + headerCell, width: Int(screenWidth/2), height: 30))
            phone.text = "Телефоны"
            phone.textColor = .white
            phone.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            self.view.addSubview(phone)
            
            let phoneView = UIView(frame: CGRect(x: 0, y: y+Int(headerHeight), width: Int(screenWidth), height: 70))
            phoneView.backgroundColor = .black
            let phonelImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            phonelImage.image = #imageLiteral(resourceName: "icons8-телефон-50")
            let phoneViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth-20, height: 30))
            phoneViewLabel.text = "+7(495)108-68-33 - по России - бесплатно"
            phoneViewLabel.addTapGesture {
                self.makeAPhoneCall()
            }
            phoneViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            phoneViewLabel.numberOfLines = 0
            phoneViewLabel.textColor = .white
            phoneView.addSubview(phoneViewLabel)
            phoneView.addSubview(phonelImage)

            let phonelImage2 = UIImageView(frame: CGRect(x: 10, y: 43, width: 15, height: 15))
            phonelImage2.image = #imageLiteral(resourceName: "icons8-телефон-50")
            let phoneViewLabelTwo = UILabel(frame: CGRect(x: 30, y: 35, width: screenWidth-20, height: 30))
            phoneViewLabelTwo.text = "+7(800)777-16-03 - по России - бесплатно"
            phoneViewLabelTwo.addTapGesture {
                self.makeAPhoneCallTwo()
            }
            phoneViewLabelTwo.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            phoneViewLabelTwo.numberOfLines = 0
            phoneViewLabelTwo.textColor = .white
            phoneView.addSubview(phoneViewLabelTwo)
            phoneView.addSubview(phonelImage2)

            self.view.addSubview(phoneView)
            
            y = y + 120
            headerCell = headerCell + 120
            let email = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + headerCell, width: Int(screenWidth/2), height: 30))
            email.text = "ЭЛЕКТРОННАЯ ПОЧТА"
            email.textColor = .white
            email.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            self.view.addSubview(email)
            
            let emailView = UIView(frame: CGRect(x: 0, y: y+Int(headerHeight), width: Int(screenWidth), height: 40))
            emailView.backgroundColor = .black
            let emailImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            emailImage.image = #imageLiteral(resourceName: "icons8-новый-пост-50")
            let emailViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth-20, height: 30))
            emailViewLabel.text = "mail@fmeter.ru"
            emailViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            emailViewLabel.numberOfLines = 0
            emailViewLabel.textColor = .white
            emailView.addSubview(emailViewLabel)
            emailView.addSubview(emailImage)

            self.view.addSubview(emailView)
            
            y = y + 100
            headerCell = headerCell + 100
            
            let site = UILabel(frame: CGRect(x: 10, y: Int(headerHeight) + headerCell, width: Int(screenWidth/2), height: 30))
            site.text = "САЙТ"
            site.textColor = .white
            site.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            self.view.addSubview(site)
            
            let siteView = UIView(frame: CGRect(x: 0, y: y+Int(headerHeight), width: Int(screenWidth), height: 40))
            siteView.backgroundColor = .black
            let siteImage = UIImageView(frame: CGRect(x: 10, y: 13, width: 15, height: 15))
            siteImage.image = #imageLiteral(resourceName: "icons8-приключения-24")
            let siteViewLabel = UILabel(frame: CGRect(x: 30, y: 5, width: screenWidth/2+20, height: 30))
            siteViewLabel.text = "https://www.fmeter.ru/"
            siteViewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            siteViewLabel.numberOfLines = 0
            siteViewLabel.textColor = .white
            siteView.addSubview(siteViewLabel)
            siteView.addSubview(siteImage)
            siteView.addTapGesture {
                let url = URL(string: "https://www.fmeter.ru")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.view.addSubview(siteView)
        }
    }
    func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://+7(495)108-68-33")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    func makeAPhoneCallTwo()  {
        let url: NSURL = URL(string: "TEL://+7(800)777-16-03")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}
