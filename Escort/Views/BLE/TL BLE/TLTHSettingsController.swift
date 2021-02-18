//
//  TLTHSettingsController.swift
//  Escort
//
//  Created by Володя Зверев on 08.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class TLTHSettingsController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    let blackBoxVC = BlackBoxTHController()
    var viewModel: ViewModelDevice = ViewModelDevice()
    var delegate: PasswordDelegate?
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
        MainLabel.text = "Settings".localized(code)
        tableView.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createTableView()
        registerCell()
        view.addSubview(themeBackView3)

        MainLabel.text = "Settings".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture { self.popVC() }

        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: themeBackView3.bottomAnchor, constant: 20 ),
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
        tableView.register(SettingsPasswordCell.self, forCellReuseIdentifier: "SettingsPasswordCell")
        tableView.register(SettingsReloadCell.self, forCellReuseIdentifier: "SettingsReloadCell")
        tableView.register(SettingsNewPasswordCell.self, forCellReuseIdentifier: "SettingsNewPasswordCell")
        tableView.register(SettingsReloadTLCell.self, forCellReuseIdentifier: "SettingsReloadTLCell")

    }
}

extension TLTHSettingsController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if newPassword {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsNewPasswordCell", for: indexPath) as! SettingsNewPasswordCell
                cell.delegate = self
                cell.mainLabel.text = "Password for changing settings".localized(code)
                cell.setButton.setTitle("Set".localized(code), for: .normal)
                cell.passwordFirstTextField.text = mainPassword
                cell.passwordFirstLabel.text = "Password".localized(code)
                cell.passwordSecondLabel.text = "Password".localized(code)
                cell.passwordSecondTextField.text = mainPassword
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsPasswordCell", for: indexPath) as! SettingsPasswordCell
                cell.passwordTextField.text = mainPassword
                cell.delegate = self
                cell.passwordLabel.text = "Password".localized(code)
                cell.mainLabel.text = "Password for changing settings".localized(code)
                if mainPassword == "" {
                    cell.passwordTextField.layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
                    cell.passwordTextField.isEnabled = true
                    cell.setButton.setTitle("Enter".localized(code), for: .normal)
                } else {
                    cell.passwordTextField.isEnabled = false
                    cell.passwordTextField.layer.borderColor =  UIColor(rgb: 0x00A778).cgColor
                    cell.setButton.setTitle("Remove".localized(code), for: .normal)
                }
                return cell
            }
        } else {
            if viewModel.isTL {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsReloadTLCell", for: indexPath) as! SettingsReloadTLCell
                cell.setButton.setTitle("FW update".localized(code), for: .normal)
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsReloadCell", for: indexPath) as! SettingsReloadCell
                cell.setButton.setTitle("FW update".localized(code), for: .normal)
                cell.sinfButton.setTitle("Synchronize time".localized(code), for: .normal)
                cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
extension TLTHSettingsController: PasswordSetDelegate, UpdateButtomDelegate {
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
            self.delegate?.buttonReloadDevice()
        } else {
            let alert = UIAlertController(title: "Save the black box data before updating FW?".localized(code), message: "If you update the FW, the black box data will be lost".localized(code), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save data".localized(code), style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                                print("Сохранить данные")
                                                self.delegate?.pushSaveData()
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
                                                self.delegate?.buttonReloadDevice()
                                                reload = 1
                                                self.delegate?.buttonReloadDevice()
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
            delegate?.buttonReloadDevice()
        }

    }
    
    func setPassword(bool: Bool) {
        viewAlphaAlways.isHidden = false
        numberOfButton = 0
        if bool {
            reload = 9
            delegate?.actionSetPassword()
        } else {
            reload = 7
            delegate?.actionDeletePassword()
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
