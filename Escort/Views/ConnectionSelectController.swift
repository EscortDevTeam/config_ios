//
//  ConnectionSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//
import UIKit
import AJMessage
import ImpressiveNotifications

var rightCount = 0

class ConnectionSelectController: UIViewController, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
//        print(data)
//        code = "en"
        updateLangues(code: code)
        viewShow()
    }
    
    
    
    var typeConnect: String = "Выберите тип подключения"
    let DeviceSelectCUSB = DeviceSelectControllerUSB()
    let DeviceSelectC = DeviceSelectController()
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC
    
    var menuVC: ContainerViewController!
//    var timer = Timer()
    func updateLangues(code: String){
            popUpVC.parsedData = parsedData
            if let name0 = parsedData["1"] {
                        let dict = name0 as? [String: Any]
                        switch code {
                        case "ru":
                            if let name1 = dict!["title_ru"]{
                                print(name1 as! NSString)
                                typeConnect = name1 as! String
                            }
                            print(code)
                        case "en":
                            if let name1 = dict!["title_en"]{
                                print(name1 as! NSString)
                                typeConnect = name1 as! String
                            }
                            print(code)
                        case "pr":
                            if let name1 = dict!["title_pr"]{
                                print(name1 as! NSString)
                                typeConnect = name1 as! String
                            }
                            print(code)
                        case "es":
                            if let name1 = dict!["title_es"]{
                                print(name1 as! NSString)
                                typeConnect = name1 as! String
                            }
                            print(code)
                        default:
                            print("")
                        }
                    }
            if let name0 = parsedData["132"] {
                let dict = name0 as? [String: Any]
                switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        langu = name1 as! String
                    }
                    print(code)
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        langu = name1 as! String
                    }
                    print(code)
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        langu = name1 as! String
                    }
                    print(code)
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        langu = name1 as! String
                    }
                    print(code)
                default:
                    print("")
                }
            }
            if let name0 = parsedData["2"] {
                let dict = name0 as? [String: Any]
                switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        typeBLE = name1 as! String
                    }
                    print(code)
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        typeBLE = name1 as! String
                    }
                    print(code)
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        typeBLE = name1 as! String
                    }
                    print(code)
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        typeBLE = name1 as! String
                    }
                    print(code)
                default:
                    print("")
                }
            }
            if let name0 = parsedData["8"] {
                DeviceSelectCUSB.code = code
                DeviceSelectCUSB.parsedData = parsedData
                let dict = name0 as? [String: Any]
                switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        typeUSB = name1 as! String
                    }
                    print(code)
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        typeUSB = name1 as! String
                    }
                    print(code)
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        typeUSB = name1 as! String
                    }
                    print(code)
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        typeUSB = name1 as! String
                    }
                    print(code)
                default:
                    print("")
                }
            }
        }
    func dataGetTwo() {
        let urlString = "https://api.fmeter.ru/site/api/1234563213131231231123341112"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    print("parsedData: \(parsedData)")
                    let currentConditions = parsedData["version"]! as! NSString
                    print(currentConditions)
                    if let name0 = parsedData["0"] {
                        let dict = name0 as? [String: Any]
                        print(dict!)
                        if let name0screen = dict!["screen"]{
                            print(name0screen as! Int)
                        }
                        if let name0en = dict!["title_en"]{
                            print(name0en as! NSString)
                        }
                        if let name0es = dict!["title_es"]{
                            print(name0es as! NSString)
                        }
                        if let name0pr = dict!["title_pr"]{
                            print(name0pr as! NSString)
                        }
                        if let name0ru = dict!["title_ru"]{
                            print(name0ru as! NSString)
                        }
                    }
                    if let name0 = parsedData["2"] {
                        let dict = name0 as? [String: Any]
                        print(dict!)
                        if let name0screen = dict!["screen"]{
                            print(name0screen as! Int)
                        }
                        if let name0en = dict!["title_en"]{
                            print(name0en as! NSString)
                        }
                        if let name0es = dict!["title_es"]{
                            print(name0es as! NSString)
                        }
                        if let name0pr = dict!["title_pr"]{
                            print(name0pr as! NSString)
                        }
                        if let name0ru = dict!["title_ru"]{
                            print(name0ru as! NSString)
                        }
                    }
                    if let name0 = parsedData["1"] {
                        let dict = name0 as? [String: Any]
                        print(dict!)
                        if let name0screen = dict!["screen"]{
                            print(name0screen as! Int)
                        }
                        if let name0en = dict!["title_en"]{
                            print(name0en as! NSString)
                        }
                        if let name0es = dict!["title_es"]{
                            print(name0es as! NSString)
                        }
                        if let name0pr = dict!["title_pr"]{
                            print(name0pr as! NSString)
                        }
                        if let name0ru = dict!["title_ru"]{
                            print(name0ru as! NSString)
                            let nameORU = (name0ru as! NSString) as String
                            print(nameORU)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataGetTwo()
        updateLangues(code: code)
        viewShow()
        //        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
//    @objc func timerAction(){
//            viewShow()
//        print(12)
//        }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        popUpVC.delegate = self
        rightCount = 0
        updateLangues(code: code)
        viewShow()
        boolBLE = false
        print("12")
    }
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
        var h = 0
        view.addSubview(headerSet(title: "\(typeConnect)"))
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        let hamburgerPlace = UIView()
                var yHamb = screenHeight/22
                if screenHeight >= 750{
                    yHamb = screenHeight/18
                }
                hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
                hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
                view.addSubview(hamburger)
                view.addSubview(hamburgerPlace)
                hamburgerPlace.addTapGesture {
                    
                    self.popUpVC.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
                    self.addChild(self.popUpVC) // 2
                    self.popUpVC.view.frame = self.view.frame  // 3
                    self.view.addSubview(self.popUpVC.view) // 4
                    self.popUpVC.didMove(toParent: self)
                    print("Успешно")

                    
                }

        let cellHeight = Int((screenHeight - headerHeight) / 2)

        // bluetooth

        var con = connections[0]
        let v1 = UIView()
        let btImage1 = UIImageView(image: UIImage(named: con.image)!)
        btImage1.frame = CGRect(x: 30, y: 0, width: 72, height: 110)
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 36))
        btTitle1.text = con.name
        btTitle1.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 32.0)

        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)

        h = (cellHeight - Int(btImage1.frame.height)) / 2
        v1.frame = CGRect(x:0, y: Int(headerHeight) + h, width: Int(screenWidth), height: cellHeight-h)
        v1.addTapGesture{
            boolBLE = true
            print("BLE")

            IsBLE = true
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.pushViewController(self.DeviceSelectC, animated: true)
            }

        }

        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + cellHeight, width: Int(screenWidth), height: 1))
        separator.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.09)
        view.addSubview(separator)

        // usb

        con = connections[1]
        let v2 = UIView()
        let btImage2 = UIImageView(image: UIImage(named: con.image)!)
        btImage2.frame = CGRect(x: 30, y: 0, width: 173, height: 59)
        let btTitle2 = UILabel(frame: CGRect(x: 220, y: 16, width: screenWidth, height: 36))
        btTitle2.text = con.name
        btTitle2.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        
        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        
        h = (cellHeight - Int(btImage2.frame.height)) / 2

        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight + h, width: Int(screenWidth), height: cellHeight-h)
        v2.addTapGesture{
            print("Провод")
            boolBLE = false
            IsBLE = false
            self.navigationController?.pushViewController(self.DeviceSelectCUSB, animated: true)
        }

        view.addSubview(v1)
        view.addSubview(v2)
    }
}
