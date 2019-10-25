//
//  ViewController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 30.06.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import CoreData

class StartScreenController: UIViewController {

    var a1 = ""
//    let DeviceSelectC = DeviceSelectController()
    let LanguageVC = LanguageSelectController()
    let ConnectionSelectC = ConnectionSelectController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataGetTwo()
        viewShow()
        

    }


    let image = startScreens[Int(arc4random_uniform(UInt32(startScreens.count)))]
    
    fileprivate lazy var backImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: image.image)!)
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    fileprivate lazy var logoImage: UIImageView = {
        let imageLogo = UIImageView(image: UIImage(named: "logo.png")!)
        imageLogo.frame = CGRect(x: image.x, y: image.y, width: image.width, height: image.height)
        return imageLogo
    }()
    
    fileprivate lazy var configText: UILabel = {
        let textConfig = UILabel(frame: CGRect(x: image.x, y: image.y + image.height - 10, width: image.width, height: 60))
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let version = appVersion {
            textConfig.text = configuratorText + version
            textConfig.textColor = image.color
            textConfig.font = UIFont(name:"FuturaPT-Medium", size: 21.0)
        }
        return textConfig
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
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

    private func move() {
        self.activityIndicator.stopAnimating()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            navigationController?.pushViewController(ConnectionSelectC, animated: true)
        } else {
            print("First launch, setting UserDefault.")
            self.navigationController?.pushViewController(LanguageVC, animated: false)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("viewWillDisappear")
    }
    private func viewShow() {
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.move()
        }
        view.addSubview(backImage)
        view.addSubview(logoImage)
        view.addSubview(configText)
        view.addSubview(activityIndicator)
    }
    var dataOk: [String : AnyObject] = [:]

}
