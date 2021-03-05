//
//  StartAppMenuController.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class StartAppMenuController: UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    var isFirstApp = true
    let deviceNewSelectVC = DeviceNewSelectController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
            
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2

        registerTableView()
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: " ")
        navigationController?.navigationBar.isHidden = true
//        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: "МЕНЮ")
//        navigationController?.navigationBar.backIndicatorImage = nil
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = nil
    }
    func tableViewScrollToBottom(animated: Bool) {
        if isFirstApp == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.scrollToRow(at: IndexPath(row: 4, section: 0),
                                           at: UITableView.ScrollPosition.top,
                                           animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                               at: UITableView.ScrollPosition.top,
                                               animated: true)
                    self.view.isUserInteractionEnabled = true
                }
            }
            self.isFirstApp = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tableView.reloadData()
    }

    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.5, 0.35]
       return gradientLayer
    }()
    func createGradientLayer() {
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [isNight ? UIColor(rgb: 0x1F2222).cgColor : UIColor(rgb: 0xEDF0F4).cgColor, isNight ? UIColor(rgb: 0x535352).cgColor : UIColor(rgb: 0xEDF0F4).cgColor]
     
    }
    override func loadView() {
        super.loadView()
        createGradientLayer()
        self.view.layer.addSublayer(gradientLayer)
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: hasNotch ? 0 : -40),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
        ])
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        self.tableView = tableView
        
    }
    
    func setupTheme() {
//        view.theme.backgroundColor = themed { $0.backgroundColor }
//        btTitle1.theme.textColor = themed{ $0.navigationTintColor }
//        btTitle2.theme.textColor = themed{ $0.navigationTintColor }
//        themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
//        separator.theme.backgroundColor = themed { $0.navigationTintColor }
//        hamburger.theme.tintColor = themed{ $0.navigationTintColor }
//        backView.theme.tintColor = themed{ $0.navigationTintColor }

    }
}
