//
//  ConnectionSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 Escort All rights reserved.
//
import UIKit
import UIDrawer
import MobileCoreServices
import RxSwift
import RxTheme
import TPPDF

class ConnectionSelectController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let notifications = Notifications()
    
    var timer = Timer()
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    let document = PDFDocument(format: .a4)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewShow()
        let text = "Some text!"
        let spacing: CGFloat = 10.0
        let textElement = PDFSimpleText(text: text, spacing: spacing)
        document.add(textObject: textElement)
        setupTheme()
//        print("\(screenWidth) and \(screenHeight)")
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        rightCount = 0
        timer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            print("timerConnection")
            self.viewShow()
            if checkMenu == true {
                self.viewShow()
                checkMenu = false
            }
        }
        viewShow()
        boolBLE = false
        print("12")
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    lazy var btTitle1: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 36))
        btTitle1.text = "BLUETOOTH"
        btTitle1.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        return btTitle1
    }()
    
    lazy var btTitle2: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 160, y: 16, width: screenWidth, height: 36))
        btTitle2.text = "USB"
        btTitle2.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        return btTitle2
    }()

    
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
        text.text = "Select connection type".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    fileprivate lazy var themeBackView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 20 : 45), width: screenWidth, height: headerHeight-(hasNotch ? 35 : 67) + (iphone5s ? 10 : 0))
        v.layer.cornerRadius = 10
        return v
    }()
    fileprivate lazy var themeBackView2: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (hasNotch ? 35 : 55) + (iphone5s ? 10 : 0))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return v
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0) )
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        activity.center = view.center
//        activity.color = .black
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    fileprivate lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + Int((screenHeight - headerHeight) / 2), width: Int(screenWidth), height: 1))
        separator.alpha = 0.1
        return separator
    }()
    
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
    var imagePicker: ImagePicker!

    func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.addSubview(themeBackView3)

        MainLabel.text = "Select connection type".localized(code)
        
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture{
            self.timer.invalidate()
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cellHeight = Int((screenHeight - headerHeight) / 2)
        let v1 = UIView()
        let btImage1 = UIImageView(image: #imageLiteral(resourceName: "bluetooth_image"))
        btImage1.frame = CGRect(x: 30, y: 0, width: 72, height: 110)
        btImage1.center.y = CGFloat(cellHeight/2)
        btTitle1.center.y = CGFloat(cellHeight/2)
        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)        
        v1.frame = CGRect(x:0, y: Int(headerHeight), width: Int(screenWidth), height: cellHeight)
        
        v1.addTapGesture {
            self.timer.invalidate()
            boolBLE = true
            print("BLE")
            IsBLE = true
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(DeviceSelectController(), animated: true)
        }
        
        view.addSubview(separator)
        // usb
        let v2 = UIButton()
        let btImage2 = UIImageView(image: #imageLiteral(resourceName: "123"))
        btImage2.frame = CGRect(x: 30, y: -20, width: 120, height: 120)

        btImage2.center.y = CGFloat(cellHeight/2)
        btTitle2.center.y = CGFloat(cellHeight/2)
        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight, width: Int(screenWidth), height: cellHeight)
//        v2.addTarget(self, action: #selector(onButtonClick(_:)), for: UIControl.Event.touchUpInside)
        v2.alpha = 0.5
        view.addSubview(v1)
        view.addSubview(v2)
//        v2.addTapGesture {
//            self.notifications.scheduleNotification(notificationType: "Тест", time: 5)
//        }

    }
    @objc private func onButtonClick(_ sender: UIButton) {
        self.timer.invalidate()
        self.navigationController?.pushViewController(LoggingController(), animated: true)
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            btTitle1.theme.textColor = themed{ $0.navigationTintColor }
            btTitle2.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            separator.theme.backgroundColor = themed { $0.navigationTintColor }
            hamburger.theme.tintColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            btTitle1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle2.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            themeBackView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            separator.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            hamburger.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
extension ConnectionSelectController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}
extension ConnectionSelectController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.absoluteString)
        print(sandboxFileURL.path)
        print(dir)
        print(selectedFileURL.absoluteString)
        sandboxFileURLPath = selectedFileURL.absoluteURL
//        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
//            print("Already exists! Do nothing")
//        }
//        else {
//
//            do {
//                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
//
//                print("Copied file!")
//            }
//            catch {
//                print("Error: \(error)")
//            }
//        }
    }
}
extension ConnectionSelectController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.hamburger.image = image
    }
}
