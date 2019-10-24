//
//  DeviceUsbHelpController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 11.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DeviceUsbHelpController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
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
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "Справка", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        view.addSubview(scrollView)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        let text = UILabel()
        text.text = "Жили-были старик со старухой.\nВот и говорит старик старухе:\n— Поди-ка, старуха, по коробу поскреби, по сусеку помети, не наскребешь ли муки на колобок.\nВзяла старуха крылышко, по коробу поскребла, по сусеку помела и наскребла муки горсти две.\nЗамесила муку на сметане, состряпала колобок, изжарила в масле и на окошко студить положила.\nКолобок полежал, полежал, взял да и покатился — с окна на лавку, с лавки на пол, пó полу к двери, прыг через порог — да в сени, из сеней на крыльцо, с крыльца на двор, со двора за ворота, дальше и дальше.\nКатится Колобок по дороге, навстречу ему Заяц:\n— Колобок, Колобок, я тебя съем!\n— Не ешь меня, Заяц, я тебе песенку спою:\n\nЯ Колобок, Колобок,\nЯ по коробу скребен,\nПо сусеку метен,\nНа сметане мешон\nДа в масле пряжон,\nНа окошке стужон.\nЯ от дедушки ушел,\nЯ от бабушки ушел,\nОт тебя, зайца, подавно уйду!\n\nИ покатился по дороге — только Заяц его и видел!\nКатится Колобок, навстречу ему Волк:\n— Колобок, Колобок, я тебя съем!\n— Не ешь меня, Серый Волк, я тебе песенку спою:\n\nЯ Колобок, Колобок,\nЯ по коробу скребен,\nПо сусеку метен,\nНа сметане мешон\nДа в масле пряжон,\nНа окошке стужон.\nЯ от дедушки ушел,\nЯ от бабушки ушел,\nЯ от зайца ушел,\nОт тебя, волк, подавно уйду!\n\nИ покатился по дороге — только Волк его и видел!\nКатится Колобок, навстречу ему Медведь:\n— Колобок, Колобок, я тебя съем!\n— Где тебе, косолапому, съесть меня!"
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
