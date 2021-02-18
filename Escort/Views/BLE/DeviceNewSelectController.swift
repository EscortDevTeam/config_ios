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
    
    private lazy var qrButton: UIButton = {
        let qrButton = UIButton()
        qrButton.setImage(UIImage(named: "ic_qr_code"), for: .normal)
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.addTarget(self, action: #selector(qrAction), for: .touchUpInside)
        return qrButton
    }()

    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()

    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
//        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        self.tableView = tableView
    }
    
    @objc func closeAction() {
        popVC()
    }
    @objc func qrAction() {
        self.generator.impactOccurred()
        let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkUpdate == "Update" {
            checkUpdate = nil
            self.dfuModeBack()
        }
        MainLabel.text = "Type of bluetooth sensor".localized(code)
        super.viewWillAppear(true)
        tableView.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createTableView()
        registerCell()
        view.addSubview(themeBackView3)

        MainLabel.text = "Type of bluetooth sensor".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture { self.popVC() }
        view.addSubview(qrButton)

        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: themeBackView3.bottomAnchor, constant: 20 ),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            qrButton.widthAnchor.constraint(equalToConstant: 24),
            qrButton.heightAnchor.constraint(equalToConstant: 24),
            qrButton.bottomAnchor.constraint(equalTo: themeBackView3.bottomAnchor, constant: -5),
            qrButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)

        ])
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(viewAlphaAlways)
        setupTheme()
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
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
//        selectItem = indexPath.row
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = .fromRight
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        for obj in (self.navigationController?.viewControllers)! {
//            if obj is AccountEnterController {
//                let vc: AccountEnterController =  obj as! AccountEnterController
//                vc.tagSelectProfile = indexPath.row
//                vc.pushAccountProfile = true
//                self.navigationController?.popToViewController(vc, animated: true)
//                break
//            }
//        }
//
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(DevicesDUController(), animated: true)

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
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
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
