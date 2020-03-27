//
//  SetupMapLoadView.swift
//  Escort
//
//  Created by Володя Зверев on 06.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

extension SetupMap {
    
    override func loadView() {
        super.loadView()
        view.addSubview(bgImage)

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.alpha = 0.0
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: hasNotch ? -150 : -180),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: hasNotch ? 60 : 40),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
        ])
        tableView.backgroundColor = .clear
        self.tableView = tableView
        
        let tableView2 = UITableView(frame: .zero, style: .plain)
        tableView2.translatesAutoresizingMaskIntoConstraints = false
        tableView2.separatorStyle = .none
        tableView2.allowsSelection = false
        tableView2.alpha = 0.0
        self.view.addSubview(tableView2)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView2.topAnchor, constant: hasNotch ? -150 : -180),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView2.bottomAnchor, constant: hasNotch ? 60 : 40),
            self.view.leadingAnchor.constraint(equalTo: tableView2.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView2.trailingAnchor, constant: 1),
        ])
        tableView2.backgroundColor = .clear
        self.tableViewOneMore = tableView2
        
        let tableView3 = UITableView(frame: .zero, style: .plain)
        tableView3.translatesAutoresizingMaskIntoConstraints = false
        tableView3.separatorStyle = .none
        tableView3.allowsSelection = false
        tableView3.alpha = 0.0
        self.view.addSubview(tableView3)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView3.topAnchor, constant: hasNotch ? -100 : -100),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView3.bottomAnchor, constant: hasNotch ? 60 : 40),
            self.view.leadingAnchor.constraint(equalTo: tableView3.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView3.trailingAnchor, constant: 1),
        ])
        tableView3.backgroundColor = .clear
        self.tableViewTrack = tableView3
        
        let tableViewLvlTop = UITableView(frame: .zero, style: .plain)
        tableViewLvlTop.translatesAutoresizingMaskIntoConstraints = false
        tableViewLvlTop.separatorStyle = .none
        tableViewLvlTop.allowsSelection = false
        tableViewLvlTop.alpha = 0.0
        self.view.addSubview(tableViewLvlTop)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableViewLvlTop.topAnchor, constant: hasNotch ? -150 : -180),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableViewLvlTop.bottomAnchor, constant: hasNotch ? 60 : 40),
            self.view.leadingAnchor.constraint(equalTo: tableViewLvlTop.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableViewLvlTop.trailingAnchor, constant: 1),
        ])
        tableViewLvlTop.backgroundColor = .clear
        self.tableViewLvlTop = tableViewLvlTop
    }
}
