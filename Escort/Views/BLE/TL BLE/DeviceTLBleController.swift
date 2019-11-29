//
//  DeviceTLBleController.swift
//  Escort
//
//  Created by Володя Зверев on 11.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import ImpressiveNotifications

class DeviceTLBleController: UIViewController {
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var timer = Timer()
    var count = 0
    var timerTrue = 0
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShow()
    }
    @objc func refresh(sender:AnyObject) {
        viewShowMain()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        attributedTitle = NSAttributedString(string: "Wait".localized(code), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        item = 0
        police = false
        viewShow()
        if timerTrue == 0 {
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timerTrue = 1
        }
        
        if reloadBack == 1{
            self.navigationController?.popViewController(animated: true)
            timerTrue = 0
            reloadBack = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            if countNot == 0 {
                if passNotif == 1 {
                    passwordHave = true
                    INNotifications.show(type: .danger, data: INNotificationData(title: "Attention".localized(code), description: "Sensor is not password-protected".localized(code), image: UIImage(named: "danger"), delay: 5.0, completionHandler: {
                    }
                    ),customStyle: INNotificationStyle(cornerRadius: 10, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 50, height: 50)))
                } else {
                    passwordHave = false
                }
                countNot = 1
            }
        }
    }
    @objc func timerAction(){
        viewShowMain()
        count += 1
        print("count: \(count)")
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    fileprivate lazy var bgImageBattary: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Battary.png")!)
        img.frame = CGRect(x:screenWidth-60, y: screenHeight/6-31, width: 32, height: 14)
        return img
    }()
    fileprivate lazy var bgImageSignal: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Path")!)
        img.frame = CGRect(x: 40.24, y: headerHeight + 19.59, width: 7.51, height: 5.41)
        
        return img
    }()
    fileprivate lazy var bgImageSignal2: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Path-2")!)
        img.frame = CGRect(x: 36, y: headerHeight + 14.33, width: 14.8, height: 4.69)
        return img
    }()
    fileprivate lazy var bgImageSignal3: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Path-3")!)
        img.frame = CGRect(x: 33, y: headerHeight + 9, width: 22, height: 6.06)
        return img
    }()
    
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "tlBleBack")!)
        img.frame = CGRect(x: screenWidth/2, y: screenHeight/5+40, width: 152, height: 166)
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
        activity.color = .white
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
        let (headerView, backView) = headerSet(title: "TL BLE", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.view.isUserInteractionEnabled = false
        
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.viewShowMain()
            self.viewAlpha.removeFromSuperview()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        warning = true
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timerTrue = 0
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        self.timer.invalidate()
        nameDevice = ""
        temp = nil
    }
    private func viewShowMain() {
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "TL BLE", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        //                viewAlpha.addSubview(activityIndicator)
        //                view.addSubview(viewAlpha)
        
        self.view.isUserInteractionEnabled = true
        
        backView!.addTapGesture{
            self.timerTrue = 0
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.timer.invalidate()
            nameDevice = ""
            temp = nil
            self.navigationController?.popViewController(animated: true)
        }
        let battaryView = UIView(frame: CGRect(x:screenWidth-58, y: screenHeight/6-29, width: 8, height: 10))
        battaryView.backgroundColor = .white
        let battaryViewTwo = UIView(frame: CGRect(x:screenWidth-50, y: screenHeight/6-29, width: 8, height: 10))
        battaryViewTwo.backgroundColor = .white
        let battaryViewFull = UIView(frame: CGRect(x:screenWidth-42, y: screenHeight/6-29, width: 9, height: 10))
        battaryViewFull.backgroundColor = .white
        view.addSubview(bgImage)
        view.addSubview(sensorImage)
        view.addSubview(bgImageBattary)
        
        let vatDouble = Double(vatt)
        if vatDouble != nil {
            if 3.4 <= vatDouble!{
                view.addSubview(battaryView)
                view.addSubview(battaryViewTwo)
                view.addSubview(battaryViewFull)
            }
            if 3.0 <= vatDouble! && 3.4 > vatDouble!{
                view.addSubview(battaryView)
                view.addSubview(battaryViewTwo)
            }
            if 2.0 <= vatDouble! && 3.0 > vatDouble!{
                view.addSubview(battaryView)
            }
        }
        
        if Int(RSSIMain)! >= -60 {
            view.addSubview(bgImageSignal)
            view.addSubview(bgImageSignal2)
            view.addSubview(bgImageSignal3)
        }
        if Int(RSSIMain)! <= -61 && Int(RSSIMain)! >= -85 {
            view.addSubview(bgImageSignal)
            view.addSubview(bgImageSignal2)
        }
        if Int(RSSIMain)! <= -86 && Int(RSSIMain)! >= -110 {
            view.addSubview(bgImageSignal)
        }
        var y = 100
        let x = 30, deltaY = 50
        
        let deviceName = UILabel(frame: CGRect(x: x, y: Int(screenHeight/5), width: Int(screenWidth), height: 78))
        deviceName.text = "№ \(nameDevice)\nFW: \(VV)"
        deviceName.textColor = UIColor(rgb: 0xE9E9E9)
        deviceName.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        deviceName.numberOfLines = 0
        
        view.addSubview(deviceName)
        
        let degree = UIView(frame: CGRect(x: x, y: Int(screenHeight/3), width: 100, height: 31))
        let degreeIcon = UIImageView(image: UIImage(named: "temp")!)
        degreeIcon.frame = CGRect(x: 20, y: 0, width: 18, height: 31)
        degree.addSubview(degreeIcon)
        let degreeName = UILabel(frame: CGRect(x: 70, y: 3, width: 40, height: 31))
        degreeName.text = "\(temp ?? "0")°"
        degreeName.textColor = UIColor(rgb: 0xDADADA)
        degreeName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        degree.addSubview(degreeName)
        view.addSubview(degree)
        
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight-20).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight))
        
        
        y = Int(screenHeight / 4) - 20
        
        view.addSubview(textLineCreate(title: "Level".localized(code), text: "\(level) Lux", x: x, y: y + Int(screenHeight/5)))
        y = y + deltaY + (hasNotch ? 0 : 30)
        view.addSubview(textLineCreate(title: "RSSI", text: "\(RSSIMain)", x: x, y: y + Int(screenHeight/5)))
        y = y + deltaY + (hasNotch ? 0 : 30)
        view.addSubview(textLineCreate(title: "Vbat", text: "\(vatt)V", x: x, y: y + Int(screenHeight/5)))
        y = y + deltaY + (hasNotch ? 0 : 30)
        view.addSubview(textLineCreate(title: "ID", text: "\(id)", x: x, y: y + Int(screenHeight/5)))
        let copyView = UIImageView(image: UIImage(named: "copy.png")!)
        copyView.frame = CGRect(x: Int(screenWidth/2+53), y: y + Int(screenHeight/5), width: 13, height: 16)
        view.addSubview(copyView)
        let copyViewMain = UIView(frame: CGRect(x: Int(screenWidth/2+53)-10, y: y + Int(screenHeight/5)-10, width: 35, height: 35))
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
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
//        y = y + deltaY
        
        let copyView2 = UIImageView(image: UIImage(named: "copy.png")!)
        copyView2.frame = CGRect(x: Int(screenWidth/2+53), y: y + Int(screenHeight/6), width: 13, height: 16)
        let copyViewMain2 = UIView(frame: CGRect(x: Int(screenWidth/2+53)-10, y: y + Int(screenHeight/5)-10, width: 35, height: 35))
        copyViewMain2.backgroundColor = .clear
        
        y = y + deltaY
        
        let statusName = UILabel(frame: CGRect(x: x, y: y + Int(screenHeight/5), width: Int(screenWidth), height: 60))
        if temp != nil {
            statusName.text = "Connected".localized(code)
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected".localized(code)
            statusName.textColor = UIColor(rgb: 0xCF2121)
            item = 0
        }
        let lbl4 = UILabel(frame: CGRect(x: x, y: y + Int(screenHeight/5) + (hasNotch ? 30 : 40), width: Int(screenWidth), height: 60))
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
            lbl4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            item = 1
        } else {
            itemColor = 1
            lbl4.text = "Stable".localized(code)
            statusDeviceY = "Stable".localized(code)
            lbl4.textColor = UIColor(rgb: 0x00A778)
            lbl4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        }
        //        } else {
        //            statusName.text = "Disconnected"
        //            statusName.textColor = UIColor(rgb: 0xCF2121)
        //        }
        statusName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        view.addSubview(statusName)
        view.addSubview(lbl4)
        
        // tabs
        
        let footer = UIView(frame: CGRect(x: 0, y: screenHeight - 90, width: screenWidth, height: 90))
        footer.backgroundColor = UIColor(rgb: 0xEAEAEB)
        
        let footerCellWidth = Int(screenWidth/2), footerCellHeight = 90
        
        let cellSetting = UIView(frame: CGRect(x: 0, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingIcon = UIImageView(image: UIImage(named: "settings.png")!)
        cellSettingIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingIcon.center = CGPoint(x: cellSetting.frame.size.width / 2, y: cellSetting.frame.size.height / 2 - 15)

        cellSetting.addSubview(cellSettingIcon)

        let cellSettingName = UILabel(frame: CGRect(x: 0, y: 55, width: footerCellWidth, height: 20))
        cellSettingName.text = "Settings".localized(code)
        cellSettingName.textColor = UIColor(rgb: 0x000000)
        cellSettingName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingName.textAlignment = .center
        cellSetting.addSubview(cellSettingName)
        
        cellSetting.addTapGesture {
            self.navigationController?.pushViewController(DeviceBLETLSettings(), animated: true)
        }
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: footerCellHeight))
        cellSettingSeparetor.backgroundColor = .black
        cellSettingSeparetor.alpha = 0.1
        let cellHelp = UIView(frame: CGRect(x: footerCellWidth, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellHelpIcon = UIImageView(image: UIImage(named: "help.png")!)
        cellHelpIcon.frame = CGRect(x: 1, y: 0, width: 47, height: 47)
        cellHelpIcon.center = CGPoint(x: cellHelp.frame.size.width / 2, y: cellHelp.frame.size.height / 2 - 15)
        cellHelp.addSubview(cellHelpIcon)
        cellHelp.addSubview(cellSettingSeparetor)

        
        let cellHelpName = UILabel(frame: CGRect(x: 0, y: 55, width: footerCellWidth, height: 20))
        cellHelpName.text = "Reference".localized(code)
        cellHelpName.textColor = UIColor(rgb: 0x000000)
        cellHelpName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellHelpName.textAlignment = .center
        cellHelp.addSubview(cellHelpName)
        
        cellHelp.addTapGesture {
            self.navigationController?.pushViewController(DeviceBleHelpController(), animated: true)
        }
        
        footer.addSubview(cellSetting)
        footer.addSubview(cellHelp)
        
        view.addSubview(footer)

        let lineView = UIView(frame: CGRect(x: 0, y: screenHeight/5+80, width: 140, height: 1))
        lineView.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(lineView)
        
    }
}
