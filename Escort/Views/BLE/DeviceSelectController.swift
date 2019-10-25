 //
//  DeviceSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceSelectController: UIViewController, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
        print(data)
        code = data
        updateLangues(code: data)
        viewShowMenu()
    }
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC

    let DevicesListC = DevicesListController()
    
    func updateLangues(code: String){
        popUpVC.parsedData = parsedData
        DevicesListC.parsedData = parsedData
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
    var t = 0
    override func viewDidAppear(_ animated: Bool) {
        popUpVC.delegate = self
        if t != 0{
            rightCount = 0
            viewShow()
            updateLangues(code: code)
        }
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
        let (headerView, backView) = headerSet(title:"\(typeBLE)", showBack: true)
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
                self.addChild(self.popUpVC) // 2
                self.popUpVC.view.frame = self.view.frame  // 3
                self.view.addSubview(self.popUpVC.view) // 4
//            popUpVC.didMove(toParent: self) // 5
            print("Успешно")
        }
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
            self.view.subviews.forEach({ $0.removeFromSuperview() })

        }
        
        let data = bleDevices
//    if t == 0 {

        let cellWidth = Int(screenWidth / 2), cellHeight = 180
        
        for (i, d) in data.enumerated() {
            let x = i % 2 == 0 ? 0 : cellWidth
            var y = 0
            if i > 1 {
                y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2)
            }
            
            let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
            
            let img = UIImageView(image: UIImage(named: d.image)!)
            img.frame = CGRect(x: x+40, y: y+110, width: 125, height: 93)
            
            let title = UILabel(frame: CGRect(x: 5, y: 130, width: cellWidth, height: 20))
            title.text = d.name
            title.textColor = UIColor(rgb: 0x272727)
            title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
            title.textAlignment = .center
            
            let separator = UIView(frame: CGRect(x: 10, y: cellHeight, width: Int(screenWidth-20), height: 1))
            separator.backgroundColor = .red
            
            img.removeFromSuperview()
            self.view.addSubview(img)
            container.addSubview(title)
            
            
            if i % 2 == 0 && i != data.count-2 {
                separator.removeFromSuperview()
                container.addSubview(separator)
            }
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
                    DeviceTypeIndex = i
                    self.navigationController?.pushViewController(self.DevicesListC, animated: true)
                    self.view.subviews.forEach({ $0.removeFromSuperview() })

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
            let (headerView, backView) = headerSet(title:"\(typeBLE)", showBack: true)
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
                    self.addChild(self.popUpVC) // 2
                    self.popUpVC.view.frame = self.view.frame  // 3
                    self.view.addSubview(self.popUpVC.view) // 4
    //            popUpVC.didMove(toParent: self) // 5
                print("Успешно")
            }
            
            backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
                self.view.subviews.forEach({ $0.removeFromSuperview() })

            }
            
            let data = bleDevices
    //    if t == 0 {

            let cellWidth = Int(screenWidth / 2), cellHeight = 180
            
            for (i, d) in data.enumerated() {
                let x = i % 2 == 0 ? 0 : cellWidth
                var y = 0
                if i > 1 {
                    y = (i % 2 == 0 ? i : i - 1) * (cellHeight / 2)
                }
                
                let container = UIView(frame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
                
                let img = UIImageView(image: UIImage(named: d.image)!)
                img.frame = CGRect(x: x+40, y: y+110, width: 125, height: 93)
                
                let title = UILabel(frame: CGRect(x: 5, y: 130, width: cellWidth, height: 20))
                title.text = d.name
                title.textColor = UIColor(rgb: 0x272727)
                title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
                title.textAlignment = .center
                
                let separator = UIView(frame: CGRect(x: 10, y: cellHeight, width: Int(screenWidth-20), height: 1))
                separator.backgroundColor = .red
                
                img.removeFromSuperview()
                self.view.addSubview(img)
                container.addSubview(title)
                
                
                if i % 2 == 0 && i != data.count-2 {
                    separator.removeFromSuperview()
                    container.addSubview(separator)
                }
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
                        DeviceTypeIndex = i
                        self.navigationController?.pushViewController(self.DevicesListC, animated: true)
                        self.view.subviews.forEach({ $0.removeFromSuperview() })

                    }
                }
            }
            
            self.scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight/2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.t += 1
            })
        
        }
}
