//
//  DeviceBleHelpController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceBleHelpController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    private func viewShow() {
        warning = false

        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "Reference".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight+60).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let textMain = UILabel(frame: CGRect(x: 20, y: headerHeight+10, width: screenWidth-40, height: 20))
        textMain.text = "Reference".localized(code)
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.textColor = UIColor(rgb: 0xE9E9E9)
        textMain.frame.origin.x = 20

        view.addSubview(textMain)
        let lineMain = UIView(frame: CGRect(x: 20, y: headerHeight+50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(lineMain)
        let text = UILabel()
        text.text = "Info".localized(code)
//        text.text = "Посадил дед репку и говорит:\n\n— Расти, расти, репка, сладка! Расти, расти, репка, крепка!\n\nВыросла репка сладка, крепка, большая-пребольшая.\n\nПошел дед репку рвать: тянет-потянет, вытянуть не может.\n\nПозвал дед бабку.\n\nБабка за дедку,\nДедка за репку —\nТянут-потянут, вытянуть не могут.\n\nПозвала бабка внучку.\n\nВнучка за бабку,\nБабка за дедку,\nДедка за репку —\nТянут-потянут, вытянуть не могут.\n\nПозвала внучка Жучку.\n\nЖучка за внучку,\nВнучка за бабку,\nБабка за дедку,\nДедка за репку —\nТянут-потянут, вытянуть не могут.\n\nПозвала Жучка кошку.\n\nКошка за Жучку,\nЖучка за внучку,\nВнучка за бабку,\nБабка за дедку,\nДедка за репку —\nТянут-потянут, вытянуть не могут.\n\nПозвала кошка мышку.\n\nМышка за кошку,\nКошка за Жучку,\nЖучка за внучку,\nВнучка за бабку,\nБабка за дедку,\nДедка за репку —\nТянут-потянут — и вытянули репку\n"
        text.textColor = UIColor(rgb: 0xE9E9E9)
        text.lineBreakMode = .byWordWrapping
        text.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        text.numberOfLines = 0
        text.frame.origin.x = 20
        text.frame.size.width = screenWidth-40
        text.sizeToFit()
        scrollView.addSubview(text)
        
        scrollView.contentSize = CGSize(width: screenWidth, height: text.frame.height)
    }
}
