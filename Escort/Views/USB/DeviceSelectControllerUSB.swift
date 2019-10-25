//
//  DeviceSelectControllerUSB.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 14/08/2019.
//  Copyright © 2019 pavit.design. All rights reserved.

import UIKit

class DeviceSelectControllerUSB: UIViewController {
    var parsedData:[String : AnyObject] = [:]
    var code = "ru"
    let DeviceListCUSB = DevicesListUsbController()

    func updateLangues(){
                    if let name0 = parsedData["9"] {
                        let dict = name0 as? [String: Any]
                        switch code {
                        case "ru":
                            if let name1 = dict!["title_ru"]{
                                print(name1 as! NSString)
                                self.DeviceListCUSB.openDevices = name1 as! String
                            }
                            print(code)
                        case "en":
                            if let name1 = dict!["title_en"]{
                                print(name1 as! NSString)
                                self.DeviceListCUSB.openDevices = name1 as! String
                            }
                            print(code)
                        case "pr":
                            if let name1 = dict!["title_pr"]{
                                print(name1 as! NSString)
                                self.DeviceListCUSB.openDevices = name1 as! String
                            }
                            print(code)
                        case "es":
                            if let name1 = dict!["title_es"]{
                                print(name1 as! NSString)
                                self.DeviceListCUSB.openDevices = name1 as! String
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
        updateLangues()
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left

        view.addGestureRecognizer(rightSwipe)
    }
    override func viewDidAppear(_ animated: Bool) {
        rightCount = 0
    }
        @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            if sender.state == .ended {
                switch sender.direction {
                case .right:
                if rightCount == 0 {
                    print("Right")
                    let popUpVC = UIStoryboard(name: "MainSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupViewController // 1
                    self.addChild(popUpVC) // 2
                    popUpVC.view.frame = self.view.frame  // 3
                    self.view.addSubview(popUpVC.view) // 4
                    popUpVC.didMove(toParent: self) // 5
                    rightCount += 1
                }
                default: break
                }
                    
            }
        }

    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private func viewShow() {
        view.backgroundColor = .white
        let (headerView, backView) = headerSet(title:"\(typeUSB)", showBack: true)
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

//            view.addSubview(hamburger)
//            view.addSubview(hamburgerPlace)
        
                
            hamburgerPlace.addTapGesture {
            let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC // 1
            self.addChild(popUpVC) // 2
            popUpVC.view.frame = self.view.frame  // 3
            self.view.addSubview(popUpVC.view) // 4
            popUpVC.didMove(toParent: self) // 5
            print("Успешно")
        }
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)

        }

        let data = boolBLE ? bleDevices : usbDevices
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        let cellWidth = Int(screenWidth / 2), cellHeight = 180
        
        for (i, d) in data.enumerated() {
            let x = i % 2 == 0 ? 0 : cellWidth
            var y = 0
            if i > 1 {
                y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2)
            }

            let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
            
            let img = UIImageView(image: UIImage(named: d.image)!)
            img.frame = CGRect(x: (cellWidth - 125) / 2, y: 20, width: 125, height: 93)
            
            let title = UILabel(frame: CGRect(x: 0, y: 130, width: cellWidth, height: 20))
            title.text = d.name
            title.textColor = UIColor(rgb: 0x272727)
            title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
            title.textAlignment = .center
            
            let separator = UIView(frame: CGRect(x: 10, y: cellHeight, width: Int(screenWidth-20), height: 1))
            separator.backgroundColor = .red
            
            container.addSubview(img)
            container.addSubview(title)
            
            if i % 2 == 0 && i != data.count-2 {
                container.addSubview(separator)
            }
            scrollView.addSubview(container)
            scrollView.bringSubviewToFront(container)

            if !d.isHide {
                container.addTapGesture {
                    DeviceTypeIndex = i
                    self.navigationController?.pushViewController(self.DeviceListCUSB, animated: true)
                }
            }
        }
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight/2)
    }
}
