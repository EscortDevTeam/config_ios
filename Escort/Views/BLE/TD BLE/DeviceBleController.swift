//
//  DeviceBleController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import RxSwift
import RxTheme

protocol MainDelegate: class {
    func buttonT()
}
class DeviceBleController: UIViewController, MainDelegate {
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var timer = Timer()
    var count = 0
    var timerTrue = 0
    let generator = UIImpactFeedbackGenerator(style: .light)
    let viewController = MenuControllerTD()
    let menuImagePlace = UIImageView(frame: CGRect(x: Int(screenWidth-21*2), y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 40, height: 40))

    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuImage.alpha = 0.0
        viewController.delegate = self
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShow()
        setupTheme()
    }
    @objc func refresh(sender:AnyObject) {
        repeatData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        QRCODE = ""
        attributedTitle = NSAttributedString(string: "Wait".localized(code), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        item = 0
        police = false
        if timerTrue == 0 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timerTrue = 1
        }
        
        if reloadBack == 1{
            self.navigationController?.popViewController(animated: true)
            timerTrue = 0
            reloadBack = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if countNot == 0 {
                if passNotif == 1 {
                    passwordHave = true
                    self.showToast(message: "Sensor is password-protected".localized(code), seconds: 3.0)
                } else {
                    passwordHave = false
                }
                countNot = 1
            }
        }
    }
    
    func buttonT() {
        print("Password ENTER")
        self.navigationController?.pushViewController(LoggingController(), animated: true)
    }
    
    @objc func timerAction(){
        repeatData()
        count += 1
        print("count: \(count)")
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    fileprivate lazy var scaleView: UIView = {
        let scaleView = UIView(frame: CGRect(x: Int(screenWidth-72), y: Int(screenHeight/2+190), width: 14, height: -2))
        scaleView.backgroundColor = UIColor(rgb: 0x00A778)
        return scaleView
    }()
    
    fileprivate lazy var bgImageBattary: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Battary.png")!)
        img.frame = CGRect(x:screenWidth-60 - (iphone5s ? 80 : 0), y: screenHeight / 5 - 31, width: 32, height: 14)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageBattary1: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth - 58 - (iphone5s ? 80 : 0), y: screenHeight / 5 - 29, width: 8, height: 10))
        return img
    }()
    fileprivate lazy var bgImageBattary2: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth - 50 - (iphone5s ? 80 : 0), y: screenHeight / 5 - 29, width: 8, height: 10))
        return img
    }()
    fileprivate lazy var bgImageBattary3: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth - 42 - (iphone5s ? 80 : 0), y: screenHeight / 5 - 29, width: 9, height: 10))
        return img
    }()
    
    fileprivate lazy var bgImageSignal: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal1.png")!)
        img.frame = CGRect(x: 30, y: screenHeight/5-22, width: 4, height: 5)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageSignal2: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal2.png")!)
        img.frame = CGRect(x: 35, y: screenHeight/5-24, width: 4, height: 7)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageSignal3: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal3.png")!)
        img.frame = CGRect(x: 40, y: screenHeight/5-26, width: 4, height: 9)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "sensor-ble"))
        img.frame = CGRect(x: screenWidth-130, y: screenHeight/6+10, width: 123, height: 391)
        img.center.y = self.view.center.y
        img.image = img.image!.withRenderingMode(.alwaysTemplate)

        return img
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var textLineCreateName: UILabel = {
        let deviceName = UILabel(frame: CGRect(x: 30, y: Int(screenHeight/4) - (iphone5s ? 20 : 0), width: Int(screenWidth), height: 78))
        deviceName.text = "№ \(nameDevice)\nFW: \(VV)"
        deviceName.textColor = UIColor(rgb: 0xE9E9E9)
        deviceName.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        deviceName.numberOfLines = 0
        return deviceName
    }()
    
    fileprivate lazy var textLineCreateTemp: UIImageView = {
        let degreeIcon = UIImageView(image: UIImage(named: "temp")!)
        degreeIcon.frame = CGRect(x: 130, y: Int(screenHeight/4) + 12 - (iphone5s ? 20 : 0), width: 18, height: 31)
        degreeIcon.image = degreeIcon.image!.withRenderingMode(.alwaysTemplate)

        return degreeIcon
    }()
    fileprivate lazy var textLineCreateTempText: UILabel = {
        let degreeName = UILabel(frame: CGRect(x: 154, y: Int(screenHeight/4) + 15 - (iphone5s ? 20 : 0), width: 40, height: 31))
        degreeName.textColor = UIColor(rgb: 0xDADADA)
        degreeName.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        return degreeName
    }()

    fileprivate lazy var textLineCreateLevel: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 2.5), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateRssi: UILabel = {        
        let lblTitle = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 2.5) + (hasNotch ? 50 : 90), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateVbat: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 2) + (hasNotch ? 50 : 90), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateID: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 1.67) + (hasNotch ? 50 : 90), width: Int(screenWidth-60), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var statusName: UILabel = {
        let statusName = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 1.67)  + (hasNotch ? 100 : 140) - (iphone5s ? 40 : 0), width: Int(screenWidth), height: 60))
        statusName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return statusName
    }()
    fileprivate lazy var lbl4: UILabel = {
        let lbl4 = UILabel(frame: CGRect(x: 30, y: Int(screenHeight / 1.67) + (hasNotch ? 130 : 180) - (iphone5s ? 40 : 0), width: Int(screenWidth), height: 60))
        lbl4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lbl4
    }()
    
    fileprivate lazy var textLineCreateCopy: UIImageView = {
        let copyView = UIImageView()
        copyView.frame = CGRect(x: Int(screenWidth/2+53) - (iphone5s ? 20 : 0), y: Int(screenHeight / 1.67) + (hasNotch ? 50 : 90), width: 13, height: 16)
        return copyView
    }()
    fileprivate lazy var menuImage: UIImageView = {
        let menuImage = UIImageView(frame: CGRect(x: Int(screenWidth-21), y: dIy + dy + (hasNotch ? dIPrusy+35 : 45) - (iphone5s ? 10 : 0), width: 6, height: 24))
        menuImage.image = #imageLiteral(resourceName: "Group 12")
        menuImage.alpha = 0.0
        menuImage.image = menuImage.image!.withRenderingMode(.alwaysTemplate)

        return menuImage
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
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
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
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    fileprivate lazy var footer: UIView = {
    let footer = UIView(frame: CGRect(x: 0, y: screenHeight - 90, width: screenWidth, height: 90))
        footer.layer.shadowRadius = 3.0
        footer.layer.shadowOpacity = 0.2
        footer.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        return footer
    }()
    fileprivate lazy var cellSettingAddName: UILabel = {
        let cellSettingAddName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellSettingAddName.text = "Additional Features".localized(code)
        cellSettingAddName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingAddName.textAlignment = .center
        return cellSettingAddName
    }()
    fileprivate lazy var cellSettingName: UILabel = {
        let cellSettingName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellSettingName.text = "Settings".localized(code)
        cellSettingName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingName.textAlignment = .center
        return cellSettingName
    }()
    fileprivate lazy var cellHelpName: UILabel = {
        let cellHelpName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellHelpName.text = "Tank calibration".localized(code)
        cellHelpName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellHelpName.textAlignment = .center
        return cellHelpName
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    fileprivate lazy var cellSettingSeparetor: UIView = {
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 90))
        cellSettingSeparetor.alpha = 0.1
        return cellSettingSeparetor
    }()
    fileprivate lazy var cellSettingSeparetorTwo: UIView = {
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 90))
        cellSettingSeparetor.alpha = 0.1
        return cellSettingSeparetor
    }()
    
    private func viewShow() {
        view.addSubview(themeBackView3)
        MainLabel.text = "TD BLE".localized(code)
        view.addSubview(MainLabel)
        
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.viewShowMain()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        warning = true
    }
    override func viewWillAppear(_ animated: Bool) {
        cheakStartLogging = false
        reload = 0
        warning = false
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.activityIndicator.stopAnimating()
            self.viewAlpha.removeFromSuperview()
            self.refreshControl.endRefreshing()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true

        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        timerTrue = 0
        timer.invalidate()
        nameDevice = ""
        VV = ""
        level = ""
        RSSIMain = ""
        vatt = ""
        id = ""
        temp = nil
        viewShowMain()
    }
    private func viewShowMain() {
        
        view.addSubview(backView)
        
        self.activityIndicator.stopAnimating()
    
        view.isUserInteractionEnabled = true
        
        backView.addTapGesture{
            self.timerTrue = 0
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.timer.invalidate()
            nameDevice = ""
            temp = nil
            self.navigationController?.popViewController(animated: true)
        }
        menuImagePlace.addTapGesture {
            self.transitionSettingsApp()
        }
        
        view.addSubview(bgImage)
        view.addSubview(sensorImage)
        view.addSubview(bgImageBattary)
        view.addSubview(bgImageBattary1)
        view.addSubview(bgImageBattary2)
        view.addSubview(bgImageBattary3)
        
        
        view.addSubview(bgImageSignal)
        view.addSubview(bgImageSignal2)
        view.addSubview(bgImageSignal3)

        var y = 100
        let deltaY = 50
        
        textLineCreateName.text = "№ \(nameDevice)\nFW: \(VV)"
        view.addSubview(textLineCreateName)
        
        view.addSubview(textLineCreateTemp)
        textLineCreateTempText.text = "\(temp ?? "0")°"
        view.addSubview(textLineCreateTempText)
        
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight-20).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight))
        
        
        y = Int(screenHeight / 5)
        
        textLineCreateLevel.text = "Level:  \(level)"
        view.addSubview(textLineCreateLevel)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateRssi.text = "RSSI:    \(RSSIMain)"
        view.addSubview(textLineCreateRssi)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateVbat.text = "Vbat:    \(vatt)V"
        view.addSubview(textLineCreateVbat)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateID.text = "ID:        \(id)"
        view.addSubview(textLineCreateID)
        if isNight {
            textLineCreateCopy.image = #imageLiteral(resourceName: "copy")
        } else {
            textLineCreateCopy.image = #imageLiteral(resourceName: "Group-2")
        }
        view.addSubview(textLineCreateCopy)
        let copyViewMain = UIView(frame: CGRect(x: Int(screenWidth/2+53)-10 - (iphone5s ? 20 : 0), y: y + Int(screenHeight/5)-10, width: 35, height: 35))
        copyViewMain.backgroundColor = .clear
        view.addSubview(copyViewMain)
        
        copyViewMain.addTapGesture {
            UIPasteboard.general.string = id
            let alert = UIAlertController(title: "Сopied to clipboard".localized(code), message: "\(id)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
        if temp != nil {
            statusName.text = "Connected".localized(code)
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected".localized(code)
            statusName.textColor = UIColor(rgb: 0xCF2121)
            item = 0
        }

        let cntMain1: Int = Int(cnt1)!
        cnt1 = cnt2
        let cntMain2: Int = Int(cnt2)!
        let abc:Double = Double(abs(cntMain1-cntMain2))/Double(cntMain1/100)
        print("abc: \(abc)")
        if abc > 1 {
            itemColor = 0
            lbl4.text = "Not stable".localized(code)
            statusDeviceY = "Not stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 1
        } else {
            itemColor = 1
            lbl4.text = "Stable".localized(code)
            statusDeviceY = "Stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0x00A778)
        }
        
        view.addSubview(statusName)
        view.addSubview(lbl4)
        
        // tabs
        
        
        let footerCellWidth = Int(screenWidth/3), footerCellHeight = 90
        
        let cellSetting = UIView(frame: CGRect(x: 0, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingIcon = UIImageView(image: UIImage(named: isNight ? "settings" : "settings-black")!)
        cellSettingIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingIcon.center = CGPoint(x: cellSetting.frame.size.width / 2, y: cellSetting.frame.size.height / 2 - 15)
        cellSetting.addSubview(cellSettingIcon)
        

        cellSetting.addSubview(cellSettingName)

        cellSetting.addTapGesture {
            if temp != nil {
                self.navigationController?.pushViewController(DeviceBleSettingsController(), animated: true)
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        let cellSettingAdd = UIView(frame: CGRect(x: footerCellWidth, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingAddIcon = UIImageView(image: UIImage(named: isNight ? "settings-add" : "settings-add-black")!)
        cellSettingAddIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingAddIcon.center = CGPoint(x: cellSettingAdd.frame.size.width / 2, y: cellSettingAdd.frame.size.height / 2 - 15)
        cellSettingAdd.addSubview(cellSettingAddIcon)
        
        cellSettingAdd.addSubview(cellSettingAddName)
        
        cellSettingAdd.addSubview(cellSettingSeparetor)
        
        cellSettingAdd.addTapGesture {
            if temp != nil {
                self.navigationController?.pushViewController(DeviceBleSettingsAddController(), animated: true)
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        let cellHelp = UIView(frame: CGRect(x: footerCellWidth*2, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellHelpIcon = UIImageView(image: UIImage(named: isNight ? "tarirovka" : "tar-black")!)
        cellHelpIcon.frame = CGRect(x: 0, y: 0, width: 32, height: 47)
        cellHelpIcon.center = CGPoint(x: cellHelp.frame.size.width / 2, y: cellHelp.frame.size.height / 2 - 15)
        cellHelp.addSubview(cellHelpIcon)
        
        cellHelp.addSubview(cellHelpName)
        
        cellHelp.addSubview(cellSettingSeparetorTwo)
        
        cellHelp.addTapGesture {
            if temp != nil {
                //                self.navigationController?.pushViewController(TarirovkaStartViewControllet(), animated: true)
                self.navigationController?.pushViewController(TarirovkaStartViewControllet(), animated: true)
                
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        
        footer.addSubview(cellSetting)
        footer.addSubview(cellSettingAdd)
        footer.addSubview(cellHelp)
        
        view.addSubview(footer)
        var myInt = (level as NSString).doubleValue * (-1) / 13 - 1
        if level == "7000" {
            lbl4.text = "Water/dirt/metal shavings in tubes".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            myInt = -4095 / 13 - 1
        }
        if level == "6500" {
            lbl4.text = "Lost contact with tubes".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            myInt = -4095 / 13 - 1
        }
        scaleView.frame.size = CGSize(width: 14, height: Int(myInt))
        view.addSubview(scaleView)
        let lineView = UIView(frame: CGRect(x: 0, y: screenHeight/4+80 - (iphone5s ? 20 : 0), width: 207, height: 1))
        lineView.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(lineView)
        
    }
    func repeatData() {
        textLineCreateName.text = "№ \(nameDevice)\nFW: \(VV)"
        textLineCreateTempText.text = "\(temp ?? "0")°"
        textLineCreateLevel.text = "Level:\t" + "\(iphone5s ? "" : "\t")" + "\(level)"
        textLineCreateRssi.text = "RSSI:\t" + "\(iphone5s ? "" : "\t")" + "\(RSSIMain)"
        textLineCreateVbat.text = "Vbat:\t" + "\(iphone5s ? "" : "\t")" + "\(vatt)V"
        textLineCreateID.text = "ID:\t" + "\(iphone5s ? "" : "\t\t")" + "\(id)"
        let vatDouble = Double(vatt)
        bgImageBattary1.isHidden = true
        bgImageBattary2.isHidden = true
        bgImageBattary3.isHidden = true
        if vatDouble != nil {
            if 3.4 <= vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = false
                bgImageBattary3.isHidden = false
            }
            if 3.0 <= vatDouble! && 3.4 > vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = false
                bgImageBattary3.isHidden = true

            }
            if 2.0 <= vatDouble! && 3.0 > vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = true
                bgImageBattary3.isHidden = true
            }
            if 2.0 > vatDouble!{
                bgImageBattary1.isHidden = true
                bgImageBattary2.isHidden = true
                bgImageBattary3.isHidden = true
            }
        }
        if Int(RSSIMain) ?? -100 >= -60 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = false
            bgImageSignal3.isHidden = false
        }
        if Int(RSSIMain) ?? -100 <= -61 && Int(RSSIMain) ?? -100 >= -85 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = false
            bgImageSignal3.isHidden = true
        }
        if Int(RSSIMain) ?? -100 <= -86 && Int(RSSIMain) ?? -100 >= -110 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = true
            bgImageSignal3.isHidden = true
        }
        if isNight {
            textLineCreateCopy.image = #imageLiteral(resourceName: "copy")
        } else {
            textLineCreateCopy.image = #imageLiteral(resourceName: "Group-2")
        }
        
        let cntMain1: Int = Int(cnt1)!
        cnt1 = cnt2
        let cntMain2: Int = Int(cnt2)!
        let abc:Double = Double(abs(cntMain1-cntMain2))/Double(cntMain1/100)
        print("abc: \(abc)")
        if abc > 1 {
            itemColor = 0
            lbl4.text = "Not stable".localized(code)
            statusDeviceY = "Not stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 1
        } else {
            itemColor = 1
            lbl4.text = "Stable".localized(code)
            statusDeviceY = "Stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0x00A778)
        }
        
        var myInt = (level as NSString).doubleValue * (-1) / 13 - 1
        if level == "7000" {
            lbl4.text = "Water/dirt/metal shavings in tubes".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            myInt = -4095 / 13 - 1
        }
        if level == "6500" {
            lbl4.text = "Lost contact with tubes".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            myInt = -4095 / 13 - 1
        }
        scaleView.frame = CGRect(x: Int(screenWidth-72), y: Int(screenHeight/2+190), width: 14, height: Int(myInt))
        
        if temp != nil {
            statusName.text = "Connected".localized(code)
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected".localized(code)
            statusName.textColor = UIColor(rgb: 0xCF2121)
            itemColor = 0
            lbl4.text = "Not stable".localized(code)
            statusDeviceY = "Not stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 0
        }
//        var y = Int(screenHeight / 1.67) + 100
//        if screenHeight == 812.0{
//            y = y - 15
//        }
//        statusName.frame.origin = CGPoint(x: 30, y: y)
//        y = Int(screenHeight / 1.67) + 100 + (hasNotch ? 30 : 40)
        if menuImage.alpha == 0.0 {
            if cheackVersionDevice(version: versionDevice) {
                menuImage.alpha = 1.0
                view.addSubview(menuImage)
                view.addSubview(menuImagePlace)
            } else {
                menuImage.alpha = 0.0
                menuImage.removeFromSuperview()
                menuImagePlace.removeFromSuperview()
            }
        }
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            footer.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            cellSettingName.theme.textColor = themed{ $0.navigationTintColor }
            cellSettingAddName.theme.textColor = themed{ $0.navigationTintColor }
            cellHelpName.theme.textColor = themed{ $0.navigationTintColor }
            hamburger.theme.tintColor = themed{ $0.navigationTintColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            textLineCreateLevel.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateRssi.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateVbat.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateID.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateTempText.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateTemp.theme.tintColor = themed{ $0.navigationTintColor }
            textLineCreateName.theme.textColor = themed{ $0.navigationTintColor }
            sensorImage.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal2.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal3.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageBattary.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageBattary1.theme.backgroundColor = themed{ $0.navigationTintColor }
            bgImageBattary2.theme.backgroundColor = themed{ $0.navigationTintColor }
            bgImageBattary3.theme.backgroundColor = themed{ $0.navigationTintColor }
            cellSettingSeparetorTwo.theme.backgroundColor = themed{ $0.navigationTintColor }
            cellSettingSeparetor.theme.backgroundColor = themed{ $0.navigationTintColor }
            menuImage.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            hamburger.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingAddName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellHelpName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateLevel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateRssi.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateVbat.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateID.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateTempText.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateTemp.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            sensorImage.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal2.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal3.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary1.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary2.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary3.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingSeparetorTwo.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingSeparetor.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            footer.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            menuImage.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
    fileprivate func transitionSettingsApp() {
        self.generator.impactOccurred()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
}

extension DeviceBleController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}
