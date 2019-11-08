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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewShow()
    }

    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        view.addSubview(headerSet(title: "..."))
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
//        SharedClass.sharedInstance.addTapGesture(view: scrollView, target: self, action: #selector(handleGesture))
    }

    private func move() {
        print("move")
        navigationController?.pushViewController(ConnectionSelectC, animated: true)
    }
}
