//
//  DeviceDUSettingsController.swift
//  Escort
//
//  Created by Володя Зверев on 19.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class DeviceDUSettingsController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    let blackBoxVC = BlackBoxTHController()
    var viewModel: ViewModelDevice = ViewModelDevice()
    var delegate: DUViewDelegate?
    var delegateAlert: BlackBoxTHDelegate?
    var passwortIsEnter = false
    var numberOfButton: Int = 0

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
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        self.tableView = tableView
    }
    
    @objc func closeAction() {
        popVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: "Settings")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        reloadSettings()
    }
    func reloadSettings() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DuCollectionCell else {return}
        cell.collectionView?.reloadData()
        cell.collectionView?.scrollToItem(at:IndexPath(item: viewModel.detectDuModeInt(intMode: modeLabel), section: 0), at: .right, animated: true)
        tableView.reloadData()
    }
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DuControlAngleCell else {return}
            tableView.contentInset = contentInset
            cell.setButton.contentEdgeInsets = contentInset
            
        } else {
            guard let userInfo = notification.userInfo else { return }
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            tableView.contentInset = contentInset
//            tableView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 80, right: 0)
        }
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .bottom, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createTableView()
        registerCell()
//        view.addSubview(themeBackView3)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        MainLabel.text = "Settings".localized(code)
//        view.addSubview(MainLabel)
//        view.addSubview(backView)
        backView.addTapGesture { self.popVC() }

        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
        tableView.addTapGesture {
            self.navigationController?.view.endEditing(true)
        }
        setupTheme()
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DuControlAngleCell.self, forCellReuseIdentifier: "DuControlAngleCell")
        tableView.register(SettingsReloadCell.self, forCellReuseIdentifier: "SettingsReloadCell")
        tableView.register(SettingsNewPasswordCell.self, forCellReuseIdentifier: "SettingsNewPasswordCell")
        tableView.register(SettingsReloadTLCell.self, forCellReuseIdentifier: "SettingsReloadTLCell")
        tableView.register(DuCollectionCell.self, forCellReuseIdentifier: "DuCollectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(DuCovshCell.self, forCellReuseIdentifier: "DuCovshCell")

    }
}

extension DeviceDUSettingsController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DuCollectionCell", for: indexPath) as! DuCollectionCell
            cell.delegate = self
            return cell
        } else {
            if viewModel.detectDuModeInt(intMode: modeLabel) == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DuControlAngleCell", for: indexPath) as! DuControlAngleCell
                cell.passwordFirstTextField.text = full
                cell.passwordSecondTextField.text = nothing
                cell.delegate = self
                return cell
            } else if viewModel.detectDuModeInt(intMode: modeLabel) == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DuCovshCell", for: indexPath) as! DuCovshCell
                cell.passwordFirstTextField.text = nothing
                cell.passwordSecondTextField.text = zaderV
                cell.passwordThreedTextField.text = zaderVi
                cell.delegate = self
                return cell
            }  else if viewModel.detectDuModeInt(intMode: modeLabel) == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DuControlAngleCell", for: indexPath) as! DuControlAngleCell
//                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
                return cell
            }
        }
    }
    
    @objc func optionSettingsAcction() {
        generator.impactOccurred()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func popToVC() {
        print("popTo")
        for obj in (self.navigationController?.viewControllers)! {
            if obj is DeviceNewSelectController {
                let vc: DeviceNewSelectController =  obj as! DeviceNewSelectController
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
//           navigationController?.popToViewController(DeviceNewSelectController(), animated: true)

    }
}
extension DeviceDUSettingsController: PasswordSetDelegate, UpdateButtomDelegate {
    func updateDevice() {
        numberOfButton = 2
        if mainPassword == "" {
            if newPassword {
                delegateAlert?.newPasswordAlert()
            } else {
                delegateAlert?.passwordAlert()
            }
        } else {
            alertUpdate()
        }

    }
    func alertUpdate() {
        if viewModel.isTL {
            viewAlphaAlways.isHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            reload = 1
//            self.delegate?.buttonReloadDevice()
        } else {
            let alert = UIAlertController(title: "Save the black box data before updating FW?".localized(code), message: "If you update the FW, the black box data will be lost".localized(code), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save data".localized(code), style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                                print("Сохранить данные")
//                                                self.delegate?.pushSaveData()
                                            case .cancel:
                                                print("cancel")
                                            case .destructive:
                                                print("destructive")
                                            @unknown default:
                                                fatalError()
                                            }}))
            alert.addAction(UIAlertAction(title: "Delete and update".localized(code), style: .destructive, handler: { action in
                                            switch action.style{
                                            case .default:
                                                print("default")
                                            case .cancel:
                                                print("cancel")
                                                
                                            case .destructive:
                                                viewAlphaAlways.isHidden = false
                                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                                reload = 13
//                                                self.delegate?.buttonReloadDevice()
                                                reload = 1
//                                                self.delegate?.buttonReloadDevice()
                                            @unknown default:
                                                fatalError()
                                            }}))
            alert.addAction(UIAlertAction(title: "Cancel".localized(code), style: .cancel, handler: { action in
                                            switch action.style{
                                            case .default:
                                                print("Отменить")
                                                self.numberOfButton = 0
                                            case .cancel:
                                                print("cancel")
                                                
                                            case .destructive:
                                                print("destructive")
                                            @unknown default:
                                                fatalError()
                                            }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func sinfDevice() {
        numberOfButton = 1
        if mainPassword == "" {
            if newPassword {
                delegateAlert?.newPasswordAlert()
            } else {
                delegateAlert?.passwordAlert()
            }
        } else {
            reload = 14
            viewAlphaAlways.isHidden = false
//            delegate?.buttonReloadDevice()
        }

    }
    
    func setPassword(bool: Bool) {
        viewAlphaAlways.isHidden = false
        numberOfButton = 0
        if bool {
            reload = 9
//            delegate?.actionSetPassword()
        } else {
            reload = 7
//            delegate?.actionDeletePassword()
        }
        
    }
    
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
}

extension DeviceDUSettingsController: SettingsDUDelegate {
    func buttonSetMode() {
        numberOfButton = 1
        if mainPassword == "" {
            if newPassword {
                delegateAlert?.newPasswordAlert()
            } else {
                delegateAlert?.passwordAlert()
            }
        } else {
            viewAlphaAlways.isHidden = false
            delegate?.buttonSetMode()
        }
    }
    func buttonSetParameters(load: Int) {
        numberOfButton = 2
        if mainPassword == "" {
            if newPassword {
                delegateAlert?.newPasswordAlert()
            } else {
                delegateAlert?.passwordAlert()
            }
        } else {
            viewAlphaAlways.isHidden = false
            delegate?.delegateSetParameters(load: load)
        }
    }
    
    
}
