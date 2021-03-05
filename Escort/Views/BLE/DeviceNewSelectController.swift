//
//  DeviceNewSelectController.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class DeviceNewSelectController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    let viewModel: ViewModelDevice = ViewModelDevice()
    let tlListDevicesVC = DevicesTLListController()
    let duListVC = DevicesDUController()

    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        self.tableView = tableView
    }

    @objc func qrAction() {
        self.generator.impactOccurred()
        let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: "Type of bluetooth sensor")
        let img = UIImage(named: isNight ? "ic_qr_code" : "ic_qr_code-white")!.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: img,
                                          style: UIBarButtonItem.Style.plain,
                                              target: self,
                                              action: #selector(qrAction))
        navigationItem.rightBarButtonItem = rightButton

        if checkUpdate == "Update" {
            checkUpdate = nil
            self.dfuModeBack()
        }
        tableView.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setupTheme()
    }
    @objc func popTo() {
        self.generator.impactOccurred()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createTableView()
        registerCell()

        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(viewAlphaAlways)
        setupTheme()
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeviceSelectCell.self, forCellReuseIdentifier: "DeviceSelectCell")
    }
    
    
}

extension DeviceNewSelectController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceSelectCell", for: indexPath) as! DeviceSelectCell
        cell.label.text = "\(viewModel.devicesName[indexPath.row].name)".localized(code) + " "
        cell.labelNext.text = "\(viewModel.devicesName[indexPath.row].nameNext)".localized(code)
        cell.imageUI.image = viewModel.devicesName[indexPath.row].image
        cell.imageUI.image = cell.imageUI.image!.withRenderingMode(.alwaysTemplate)
        cell.imageUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        return cell
    }
    
    @objc func optionSettingsAcction() {
        generator.impactOccurred()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devicesName.count
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? DeviceSelectCell
            cell!.content.layer.shadowOpacity = 0.7
            cell!.content.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? DeviceSelectCell
            cell!.content.layer.shadowOpacity = 0.1
            cell!.content.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(duListVC, animated: true)

        } else if indexPath.row == 2 {
            tlListDevicesVC.isTL = true
            self.navigationController?.pushViewController(tlListDevicesVC, animated: true)
        } else if indexPath.row == 3 {
            tlListDevicesVC.isTL = false
            self.navigationController?.pushViewController(tlListDevicesVC, animated: true)
        } else if indexPath.row == 4 {
            let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}
extension DeviceNewSelectController: DfuModeDelegate {
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        }
    }
    func dfuModeBack() {
        print("update")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
        newViewController.modalPresentationStyle = .fullScreen
        let nav = self.navigationController
        nav?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        nav?.pushViewController(newViewController, animated: true)
    }
}
