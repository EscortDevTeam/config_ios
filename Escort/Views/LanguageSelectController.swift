//
//  LanguageSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 01.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class LanguageSelectController: UIViewController {
    
    let ConnectionSelectC = ConnectionSelectController()
    var selectLanguage = "Выберите язык"
    
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
        viewShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewShow()
    }
    
    func updateLangues(){
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
                self.ConnectionSelectC.typeConnect = name0en as! String
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
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        view.addSubview(headerSet(title: "\(selectLanguage)"))
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        let v = UIView()
        for (i, lng) in languages.enumerated() {
            let container = UIView(frame: CGRect(x: 0, y: i * 120, width: Int(screenWidth), height: 120))
            let img = UIImageView(image: UIImage(named: lng.image)!)
            img.frame = CGRect(x: 20, y: 40, width: 70, height: 47)
            let title = UILabel(frame: CGRect(x: 120, y: 46, width: screenWidth, height: 36))
            title.text = lng.name
            title.textColor = UIColor(rgb: 0x272727)
            title.font = UIFont(name:"FuturaPT-Light", size: 32.0)
            
            let separator = UIView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: 1))
            separator.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.09)
            container.addSubview(img)
            container.addSubview(title)
            if i != languages.count-1 {
                container.addSubview(separator)
            }
            v.addSubview(container)
        }
        scrollView.addSubview(v)
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: languages.count * 120)
        SharedClass.sharedInstance.addTapGesture(view: scrollView, target: self, action: #selector(handleGesture))
    }
    
    @objc func handleGesture(gesture: UITapGestureRecognizer) -> Void {
        let i: Int = Int(gesture.location(in: gesture.view).y) / 120
        if i > languages.count-1 { return }
        // set language
        let selectedLanguage = languages[i]
        code = selectedLanguage.code
        if let name0 = parsedData["1"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    self.ConnectionSelectC.typeConnect = name1 as! String
                }
                print("code: \(code)")
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    self.ConnectionSelectC.typeConnect = name1 as! String
                    print("code: \(code)")
                }
                print(code)
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    self.ConnectionSelectC.typeConnect = name1 as! String
                }
                print(code)
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    ConnectionSelectC.typeConnect = name1 as! String
                }
                print(code)
            default:
                print("")
            }
        }
        move()
    }
    
    private func move() {
        print("move")
        navigationController?.pushViewController(ConnectionSelectC, animated: true)
    }
}
