 //
 //  DeviceSelectController.swift
 //  Escort
 //
 //  Created by Pavel Vladimiroff on 02.07.2019.
 //  Copyright © 2019 pavit.design. All rights reserved.
 //
 
import UIKit
import CoreBluetooth
import UIDrawer
import RxSwift
import RxTheme

 class DeviceSelectController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager? = nil
    var peripherals = [CBPeripheral]()
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("ON Bluetooth.")
        }
        else {
//            print("Bluetooth OFF")
//            let alert = UIAlertController(title: "Bluetooth off".localized(code), message: "For further work, you must enable Bluetooth".localized(code), preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//                    self.navigationController?.popViewController(animated: true)
//                    self.view.subviews.forEach({ $0.removeFromSuperview() })
//                    
//                case .cancel:
//                    print("cancel")
//                    
//                case .destructive:
//                    print("destructive")
//                @unknown default:
//                    fatalError()
//                }}))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    let DevicesListC = DevicesListControllerNew()
    let DevicesListTLC = DevicesTLListController()
    let sc = QRScannerViewController()
    let labelA = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        viewShow()
        setupTheme()
        //        RateManager.showRatesController()
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
        activity.color = .black
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    
    fileprivate lazy var themeBackView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 20 : 45), width: screenWidth, height: headerHeight-(hasNotch ? 35 : 67))
        v.layer.cornerRadius = 10
        return v
    }()
    fileprivate lazy var themeBackView2: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (hasNotch ? 35 : 55))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return v
    }()
    
    fileprivate lazy var imageTD: UIImageView = {
        let imageTD = UIImageView(image: #imageLiteral(resourceName: "bleImage"))
        imageTD.image = imageTD.image!.withRenderingMode(.alwaysTemplate)
        imageTD.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return imageTD
    }()
    fileprivate lazy var labelTD: UILabel = {
        let labelTD = UILabel()
        labelTD.textColor = UIColor(rgb: 0x272727)
        labelTD.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelTD.textAlignment = .center
        labelTD.text = "TD BLE"
        labelTD.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelTD
    }()
    fileprivate lazy var imageQR: UIImageView = {
        let imageQR = UIImageView(image: #imageLiteral(resourceName: "qrcodeImage"))
        imageQR.image = imageQR.image!.withRenderingMode(.alwaysTemplate)
        imageQR.frame = CGRect(x: 0, y: 0, width: 61, height: 80)
        return imageQR
    }()
    fileprivate lazy var labelQR: UILabel = {
        let labelQR = UILabel()
        labelQR.textColor = UIColor(rgb: 0x272727)
        labelQR.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelQR.textAlignment = .center
        labelQR.text = "QR-code"
        labelQR.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelQR
    }()
    fileprivate lazy var imageTL: UIImageView = {
        let imageTL = UIImageView(image: #imageLiteral(resourceName: "tlBleBack"))
        imageTL.image = imageTL.image!.withRenderingMode(.alwaysTemplate)
        imageTL.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return imageTL
    }()
    fileprivate lazy var labelTL: UILabel = {
        let labelTL = UILabel()
        labelTL.textColor = UIColor(rgb: 0x272727)
        labelTL.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelTL.textAlignment = .center
        labelTL.text = "TL BLE"
        labelTL.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelTL
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
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-60), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    
    fileprivate lazy var cellLabel: UILabel = {
    let title = UILabel()
    title.textColor = UIColor(rgb: 0x272727)
    title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
    title.textAlignment = .center
    return title

    }()

    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()

    func viewShow() {
        view.addSubview(themeBackView3)

        MainLabel.text = "Type of bluetooth sensor".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
            self.activityIndicator.stopAnimating()
            let hamburgerPlace = UIView()
            var yHamb = screenHeight/22
            if screenWidth == 414 {
                yHamb = screenHeight/20
            }
            if screenHeight >= 750{
                yHamb = screenHeight/16
                if screenWidth == 375 {
                    yHamb = screenHeight/19
                }
            }
            hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
            self.hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
            
            self.view.addSubview(self.hamburger)
            self.view.addSubview(hamburgerPlace)
            
            
            hamburgerPlace.addTapGesture {
                let viewController = MenuControllerDontLanguage()
                viewController.modalPresentationStyle = .custom
                viewController.transitioningDelegate = self
                self.present(viewController, animated: true)
            }
            
            backView.addTapGesture{
                self.navigationController?.popViewController(animated: true)
            }
        
        let cellHeight = 180
        let containerTD = UIView(frame: CGRect(x: 0, y: headerHeight, width: screenWidth/2, height: CGFloat(cellHeight)))
        imageTD.center.x = view.center.x/2
        imageTD.center.y = containerTD.bounds.height/2-20
        containerTD.addSubview(imageTD)
        labelTD.center.x = view.center.x/2
        labelTD.center.y = containerTD.bounds.height/2 + 50
        containerTD.addSubview(labelTD)
        view.addSubview(containerTD)
        
        containerTD.addTapGesture {
            print("TD")
            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
        }
        
        let containerQR = UIView(frame: CGRect(x: screenWidth/2, y: headerHeight, width: screenWidth/2, height: CGFloat(cellHeight)))
        imageQR.center.x = view.center.x/2
        imageQR.center.y = containerQR.bounds.height/2 - 20
        containerQR.addSubview(imageQR)
        labelQR.center.x = view.center.x/2
        labelQR.center.y = containerQR.bounds.height/2 + 50
        containerQR.addSubview(labelQR)
        view.addSubview(containerQR)
        
        containerQR.addTapGesture {
            print("QR")
            let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
            self.navigationController?.pushViewController(homeViewController, animated: true)        }
        
        let separator = UIView(frame: CGRect(x: 15, y: Int(Float(headerHeight)+Float(cellHeight)), width: Int(screenWidth-30), height: 2))
        separator.backgroundColor = UIColor(named: "SeperatorColor")
        view.addSubview(separator)
        
        let containerTL = UIView(frame: CGRect(x: 0, y: Int(headerHeight)+Int(cellHeight), width: Int(screenWidth/2), height: Int(cellHeight)))
        imageTL.center.x = view.center.x/2
        imageTL.center.y = containerTL.bounds.height/2 - 20
        containerTL.addSubview(imageTL)
        labelTL.center.x = view.center.x/2
        
        labelTL.center.y = containerTL.bounds.height/2 + 50
        containerTL.addSubview(labelTL)
        view.addSubview(containerTL)
        
        containerTL.addTapGesture {
            print("TL")
            self.navigationController?.pushViewController(DevicesTLListController(), animated: true)
        }
        
//            var z = 10
//            let data = bleDevices
//            let cellWidth = Int(screenWidth / 2), cellHeight = 180
//            let cellWidthXName = Int(screenWidth / 2)+10

//            for (i, d) in data.enumerated() {
//                let x = i % 2 == 0 ? 0 : cellWidth
//                let xName = i % 2 == 0 ? 0 : cellWidthXName
//                var y = 0
//                if i > 1 {
//                    y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2 + 5)
//                    if x == 0 {
//                        z = 10
//                    }
//                }
//
//                let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
//
//                let img = UIImageView(image: UIImage(named: d.image)!)
//                img.frame = CGRect(x: x+10, y: y+Int(headerHeight), width: 200, height: 130)
//
//                let labelB = self.cellLabel
//                labelB.frame = CGRect(x: xName, y: y + cellHeight+Int(headerHeight)-50, width: cellWidth, height: 20)
//                labelB.text = d.name
//
//
//                let separator = UIView(frame: CGRect(x: z, y: cellHeight, width: Int(screenWidth/2)-10, height: 2))
//                separator.backgroundColor = .red
//                z = 0
//                img.removeFromSuperview()
//                self.view.addSubview(img)
//                self.view.addSubview(labelB)
//
//                container.addSubview(separator)
//
//                container.removeFromSuperview()
//                self.scrollView.addSubview(container)
//                self.scrollView.bringSubviewToFront(container)
//
//                self.scrollView.removeFromSuperview()
//                self.view.addSubview(self.scrollView)
//
//                self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//                self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: headerHeight).isActive = true
//                self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//                self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//
//                if !d.isHide {
//                    container.addTapGesture {
//                        if d.name == "TL BLE" {
//                            self.navigationController?.pushViewController(self.DevicesListTLC, animated: true)
////                            self.view.subviews.forEach({ $0.removeFromSuperview() })
//
//                        }
//                        if d.name == "TD BLE" {
//                            DeviceTypeIndex = i
//                            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
////                            self.view.subviews.forEach({ $0.removeFromSuperview() })
//                        }
//                        if d.name == "QR-CODE" {
//                            DeviceTypeIndex = i
//                            let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
//                            let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
//                            self.navigationController?.pushViewController(homeViewController, animated: true)
////                            self.view.subviews.forEach({ $0.removeFromSuperview() })
//                        }
//                    }
//                }
//            }
            
//            self.scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight/2)
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//                self.t += 1
//            })
    }
    
    fileprivate func setupTheme() {
        view.theme.backgroundColor = themed { $0.backgroundColor }
        themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        hamburger.theme.tintColor = themed{ $0.navigationTintColor }
        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
        cellLabel.theme.textColor = themed{ $0.navigationTintColor }
        imageQR.theme.tintColor = themed{ $0.navigationTintColor }
        imageTL.theme.tintColor = themed{ $0.navigationTintColor }
        imageTD.theme.tintColor = themed{ $0.navigationTintColor }
        labelQR.theme.textColor = themed{ $0.navigationTintColor }
        labelTD.theme.textColor = themed{ $0.navigationTintColor }
        labelTL.theme.textColor = themed{ $0.navigationTintColor }
        backView.theme.tintColor = themed{ $0.navigationTintColor }

    }
 }
 extension DeviceSelectController: UIViewControllerTransitioningDelegate {
     func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)     }
 }
