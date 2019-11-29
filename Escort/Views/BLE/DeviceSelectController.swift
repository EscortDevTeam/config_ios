 //
 //  DeviceSelectController.swift
 //  Escort
 //
 //  Created by Pavel Vladimiroff on 02.07.2019.
 //  Copyright © 2019 pavit.design. All rights reserved.
 //
 
 import UIKit
 import CoreBluetooth

 class DeviceSelectController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, SecondVCDelegate {
    var manager:CBCentralManager? = nil
    var peripherals = [CBPeripheral]()
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("ON Bluetooth.")
        }
        else {
            print("Bluetooth OFF")
            let alert = UIAlertController(title: "Bluetooth off".localized(code), message: "For further work, you must enable Bluetooth".localized(code), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.navigationController?.popViewController(animated: true)
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func secondVC_BackClicked(data: String) {
        print(data)
        code = data
        viewShowMenu()
    }
    
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC
    let popUpVCNext = UIStoryboard(name: "MainSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupViewController
    let DevicesListC = DevicesListController()
    let DevicesListTLC = DevicesTLListController()
    let sc = QRScannerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        viewShow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    var t = 0
    override func viewDidAppear(_ animated: Bool) {
        popUpVCNext.delegate = self
        if t != 0{
            rightCount = 0
            viewShow()
        }
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.removeFromSuperview()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.color = .black
        activity.startAnimating()
        return activity
    }()
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewShowTwo()
        }
    }
    private func viewShowTwo() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        let (headerView, backView) = headerSet(title:"Type of bluetooth sensor".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.activityIndicator.stopAnimating()
            let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
            let hamburgerPlace = UIView()
            var yHamb = screenHeight/22
            if screenHeight >= 750{
                yHamb = screenHeight/18
            }
            hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
            hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
            
            self.view.addSubview(hamburger)
            self.view.addSubview(hamburgerPlace)
            
            
            hamburgerPlace.addTapGesture {
                self.addChild(self.popUpVCNext) // 2
                self.popUpVCNext.view.frame = self.view.frame  // 3
                self.view.addSubview(self.popUpVCNext.view) // 4
                print("Успешно")
            }
            
            backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
                self.view.subviews.forEach({ $0.removeFromSuperview() })
                
            }
            var z = 10
            let data = bleDevices
            let cellWidth = Int(screenWidth / 2), cellHeight = 180
            let cellWidthXName = Int(screenWidth / 2)+10

            for (i, d) in data.enumerated() {
                let x = i % 2 == 0 ? 0 : cellWidth
                let xName = i % 2 == 0 ? 0 : cellWidthXName
                var y = 0
                if i > 1 {
                    y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2 + 5)
                    if x == 0 {
                        z = 10
                    }
                }
                
                let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
                
                let img = UIImageView(image: UIImage(named: d.image)!)
                img.frame = CGRect(x: x+10, y: y+Int(headerHeight), width: 200, height: 130)
                
                let title = UILabel(frame: CGRect(x: xName, y: y + cellHeight+Int(headerHeight)-50, width: cellWidth, height: 20))
                title.text = d.name
                title.textColor = UIColor(rgb: 0x272727)
                title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
                title.textAlignment = .center

                let separator = UIView(frame: CGRect(x: z, y: cellHeight, width: Int(screenWidth/2)-10, height: 2))
                separator.backgroundColor = .red
                z = 0
                img.removeFromSuperview()
                self.view.addSubview(img)
                self.view.addSubview(title)
                
                container.addSubview(separator)

//                if i % 2 == 0 && i != data.count-2 {
//                    separator.removeFromSuperview()
//                    self.view.addSubview(separator)
//                }
                container.removeFromSuperview()
                self.scrollView.addSubview(container)
                self.scrollView.bringSubviewToFront(container)
                
                self.scrollView.removeFromSuperview()
                self.view.addSubview(self.scrollView)
                
                self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: headerHeight).isActive = true
                self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                
                if !d.isHide {
                    container.addTapGesture {
                        if d.name == "TL BLE" {
                            self.navigationController?.pushViewController(self.DevicesListTLC, animated: true)
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                            
                        }
                        if d.name == "TD BLE" {
                            DeviceTypeIndex = i
                            self.navigationController?.pushViewController(self.DevicesListC, animated: true)
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                        }
                        if d.name == "QR-CODE" {
                            DeviceTypeIndex = i
                            let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
                            let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
                            self.navigationController?.pushViewController(homeViewController, animated: true)
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
                        }
                    }
                }
            }
            
            self.scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight/2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.t += 1
            })
        }
    }
    private func viewShowMenu() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        let (headerView, backView) = headerSet(title: "Type of bluetooth sensor".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        let hamburgerPlace = UIView()
        var yHamb = screenHeight/22
        if screenHeight >= 750{
            yHamb = screenHeight/18
        }
        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
        hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
        
        self.view.addSubview(hamburger)
        self.view.addSubview(hamburgerPlace)
        
        
        hamburgerPlace.addTapGesture {
            self.addChild(self.popUpVCNext) // 2
            self.popUpVCNext.view.frame = self.view.frame  // 3
            self.view.addSubview(self.popUpVCNext.view) // 4
            print("Успешно")
        }
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            
        }
        var z = 10
        let data = bleDevices
        let cellWidth = Int(screenWidth / 2), cellHeight = 180
        let cellWidthXName = Int(screenWidth / 2)+10
        
        for (i, d) in data.enumerated() {
            let x = i % 2 == 0 ? 0 : cellWidth
            let xName = i % 2 == 0 ? 0 : cellWidthXName
            var y = 0
            if i > 1 {
                y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2)
            }
            
            let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
            
            let img = UIImageView(image: UIImage(named: d.image)!)
            img.frame = CGRect(x: x+10, y: y+Int(headerHeight), width: 200, height: 130)
            
            let title = UILabel(frame: CGRect(x: xName, y: cellHeight+Int(headerHeight)-50, width: cellWidth, height: 20))
            title.text = d.name
            title.textColor = UIColor(rgb: 0x272727)
            title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
            title.textAlignment = .center
            
            let separator = UIView(frame: CGRect(x: z, y: cellHeight, width: Int(screenWidth/2)-10, height: 2))
            separator.backgroundColor = .red
            z = 0
            img.removeFromSuperview()
            self.view.addSubview(img)
            self.view.addSubview(title)
            
            container.addSubview(separator)
            
//                if i % 2 == 0 && i != data.count-2 {
//                    separator.removeFromSuperview()
//                    self.view.addSubview(separator)
//                }
            container.removeFromSuperview()
            self.scrollView.addSubview(container)
            self.scrollView.bringSubviewToFront(container)
            
            self.scrollView.removeFromSuperview()
            self.view.addSubview(self.scrollView)
            
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: headerHeight).isActive = true
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            
            if !d.isHide {
                container.addTapGesture {
                    if d.name == "TL BLE" {
                        self.navigationController?.pushViewController(self.DevicesListTLC, animated: true)
                        self.view.subviews.forEach({ $0.removeFromSuperview() })
                        
                    }
                    if d.name == "TD BLE" {
                        DeviceTypeIndex = i
                        self.navigationController?.pushViewController(self.DevicesListC, animated: true)
                        self.view.subviews.forEach({ $0.removeFromSuperview() })
                    }
                    if d.name == "QR-CODE" {
                        DeviceTypeIndex = i
                        let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
                        let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        self.view.subviews.forEach({ $0.removeFromSuperview() })
                    }
                }
            }
        }
            
        self.scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight/2)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.t += 1
        })
        
    }
 }
