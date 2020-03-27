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
    var timer = Timer()
    var isFirstApp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        registerTableView()
        downArrow()
        setupTheme()
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
    override func viewWillAppear(_ animated: Bool) {
        tableViewScrollToBottom(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tableView.reloadData()
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if checkToChangeLanguage == 1 {
                self.tableView.reloadData()
                checkToChangeLanguage = 0
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(rgb: 0x005CDF)
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
        fileprivate func downArrow() {
            print(1)
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
