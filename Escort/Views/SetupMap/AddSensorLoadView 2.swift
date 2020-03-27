//
//  AddSensorLoadView.swift
//  Escort
//
//  Created by Володя Зверев on 12.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

extension AddSensor {
    override func loadView() {
        super.loadView()
//        view.addSubview(bgImage)
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.alpha = 1.0
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: hasNotch ? -50 : -30),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: hasNotch ? 0 : 0),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
        ])
        tableView.backgroundColor = .clear
        self.tableView = tableView
    }
}
