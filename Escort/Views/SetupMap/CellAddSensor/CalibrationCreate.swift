//
//  CalibrationCreate.swift
//  Escort
//
//  Created by Володя Зверев on 20.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import MobileCoreServices

class CalibrationCreate: UIViewController, UIScrollViewDelegate {

    let generator = UIImpactFeedbackGenerator(style: .light)
    weak var tableView: UITableView!
    var items: [String] = []
    var levelnumber: [String]  = []
    var viewMenu = UIView()
    let dy: Int = screenWidth == 320 ? 0 : 10
    let dIy: Int = screenWidth == 375 ? -15 : 0
    let dIPrusy: Int = screenWidth == 414 ? -12 : 0
//    var timer = Timer()
    var removeView = UIView(frame: CGRect(x: 20, y: screenHeight, width: screenWidth-126, height: 60))
    
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
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-60), height: 40))
        text.text = "Tank calibration".localized(code)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView()
        return headerView
    }()
    fileprivate lazy var headerView1: UIView = {
        let headerView = UIView()
        return headerView
    }()
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -headerHeight+(hasNotch ? 30 : 60)),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
        ])
        self.tableView = tableView
        tableView.backgroundColor = .clear
    }
    override func viewDidDisappear(_ animated: Bool) {
        items = []
        levelnumber = []
        itemsT = []
        levelnumberT = []
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if tarNew == true {
            items.append("100")
            levelnumber.append("1023")
        } else {
            items = itemsT
            levelnumber = levelnumberT
        }
        self.tableView.register(CalibrationCell.self, forCellReuseIdentifier: "CalibrationCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PersonTableViewCellTwo")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        viewShow()
        setupTheme()
    }


    override func viewWillAppear(_ animated: Bool) {
        warning = false
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func textLineCreate(title: String, text: String, x: Int, y: Int) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        
        let lblText = UILabel(frame: CGRect(x: 70, y: 0, width: Int(screenWidth/2), height: 20))
        lblText.text = text
        lblText.textColor = UIColor(rgb: 0xE9E9E9)
        lblText.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        v.addSubview(lblTitle)
        v.addSubview(lblText)
        
        return v
    }
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    fileprivate lazy var menuImage: UIImageView = {
        let menuImage = UIImageView(frame: CGRect(x: Int(screenWidth-50), y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 35, height: 35))
        menuImage.image = #imageLiteral(resourceName: "icons8-ios-50")
        menuImage.image = menuImage.image!.withRenderingMode(.alwaysTemplate)

        return menuImage
    }()
    fileprivate lazy var editImageStep: UIImageView = {
        let pixelstep = stepNumberlLabel.text?.count
        let menuImage = UIImageView(frame: CGRect(x: Int(screenWidth)-75-Int(pixelstep!*10), y: 16, width: 15, height: 15))
        menuImage.image = #imageLiteral(resourceName: "icons8-windows-metro-52")
        menuImage.image = menuImage.image!.withRenderingMode(.alwaysTemplate)

        return menuImage
    }()
    fileprivate lazy var editImageZaliv: UIImageView = {
        let menuImage = UIImageView(frame: CGRect(x: 20 + (sliv ? 40 : 50), y: 16, width: 15, height: 15))
        menuImage.image = #imageLiteral(resourceName: "icons8-windows-metro-52")
        menuImage.image = menuImage.image!.withRenderingMode(.alwaysTemplate)

        return menuImage
    }()
    fileprivate lazy var tempLabel: UILabel = {
        let tempLabel = UILabel(frame: CGRect(x: 20, y: 16, width: 30, height: 19))
        tempLabel.text = "№:"
        tempLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return tempLabel
    }()
    fileprivate lazy var nameNumberLabel: UILabel = {
        let nameNumberLabel = UILabel(frame: CGRect(x: 45, y: 16, width: 90, height: 19))
        nameNumberLabel.text = "\(nameDevice)"
        nameNumberLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return nameNumberLabel
    }()
    fileprivate lazy var levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.frame = CGRect.init(x: 20, y: 49, width: 30, height: 21)
        levelLabel.text = "ID:"
        levelLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return levelLabel
    }()
    fileprivate lazy var idlLabel: UILabel = {
        let idlLabel = UILabel(frame: CGRect(x: 45, y: 50, width: 150, height: 19))
        idlLabel.text = "\(id)"
        idlLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return idlLabel
    }()

    fileprivate lazy var stepNumberlLabel: UILabel = {
        let stepNumberlLabel = UILabel(frame: CGRect(x: screenWidth-45, y: 17, width: 35, height: 19))
        stepNumberlLabel.text = "\(stepTar)"
        stepNumberlLabel.textAlignment = .right
        stepNumberlLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return stepNumberlLabel
    }()
    fileprivate lazy var stabLabel: UILabel = {
        let stabLabel = UILabel()
        stabLabel.frame = CGRect.init(x: 20, y: 45, width: 300, height: 23)
        stabLabel.center.x = screenWidth/4
        stabLabel.textAlignment = .center
        stabLabel.text = "Литры".localized(code)
        stabLabel.font = UIFont(name:"FuturaPT-Medium", size: 22.0)
        return stabLabel
    }()
    
    fileprivate lazy var stabToplivoLabel: UILabel = {
        let stabLabel = UILabel()
        stabLabel.frame = CGRect.init(x: 20, y: 45, width: 300, height: 23)
        stabLabel.center.x = screenWidth/4*3
        stabLabel.textAlignment = .center
        stabLabel.text = "Топливо".localized(code)
        stabLabel.font = UIFont(name:"FuturaPT-Medium", size: 22.0)
        return stabLabel
    }()
    
    fileprivate lazy var stepLabel: UILabel = {
        let pixelstep = stepNumberlLabel.text?.count
        let stepLabel = UILabel()
        stepLabel.frame = CGRect.init(x: Int(screenWidth)-70-Int(pixelstep!*10), y: 16, width: 55, height: 19)
        stepLabel.text = "Step".localized(code) + ":"
        stepLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        stepLabel.textAlignment = .right
        return stepLabel
    }()
    fileprivate lazy var imageTemp: UIImageView = {
        let imageTemp = UIImageView(frame: CGRect(x: 25, y: 13, width: 12, height: 21))
        imageTemp.image = #imageLiteral(resourceName: "tempBlack")
        imageTemp.image = imageTemp.image!.withRenderingMode(.alwaysTemplate)

        return imageTemp
    }()
    fileprivate lazy var tempLabel1: UILabel = {
        let tempLabel = UILabel(frame: CGRect(x: 41, y: 13, width: 30, height: 23))
        tempLabel.text = "\(temp ?? "0")°"
        tempLabel.font = UIFont(name:"FuturaPT-Light", size: 16.0)
        return tempLabel
    }()
    fileprivate lazy var levelLabel1: UILabel = {
        let levelLabel = UILabel()
        levelLabel.frame = CGRect.init(x: 25, y: 42, width: 120, height: 20)
        levelLabel.text = "Level".localized(code) + ": \(level)"
        levelLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return levelLabel
    }()
    fileprivate lazy var stabLabel1: UILabel = {
        let stabLabel = UILabel()
        stabLabel.frame = CGRect.init(x: screenWidth-108, y: 13, width: 93, height: 20)
        stabLabel.text = "Stable".localized(code)
        stabLabel.textColor = UIColor(rgb: 0x00A778)
        stabLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        stabLabel.textAlignment = .right
        return stabLabel
    }()
    fileprivate lazy var calibLabel: UILabel = {
        let calibLabel = UILabel()
        calibLabel.frame = CGRect.init(x: 20, y: 16, width: 80, height: 20)
        calibLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        calibLabel.textAlignment = .left
        return calibLabel
    }()
    private func viewShow() {
        view.addSubview(themeBackView3)
        MainLabel.text = "Tank calibration".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        view.addSubview(bgImage)
        
        backView.addTapGesture{
            self.generator.impactOccurred()
            let alert = UIAlertController(title: "Close".localized(code), message: "You definitely want to complete the calibration?".localized(code), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                          style: .destructive,
                                          handler: {(_: UIAlertAction!) in
                                            self.generator.impactOccurred()
                                            self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }

        view.addSubview(menuImage)
        let menuImagePlace = UIImageView(frame: CGRect(x: Int(screenWidth - 60), y: dIy + dy + (hasNotch ? dIPrusy + 25 : 35) - (iphone5s ? 10 : 0), width: 60, height: 45))
        view.addSubview(menuImagePlace)
        viewMenu = UIView(frame: CGRect(x: Int(screenWidth)-1, y: dIy + dy + (hasNotch ? dIPrusy+35 : 45) + 38, width: 0, height: 0))
        viewMenu.backgroundColor = UIColor(rgb: 0xF7F7F7)
        // create menu
        menuImagePlace.addTapGesture {
            self.generator.impactOccurred()
            let file = "Тарировка \(openSensorNumber) датчика.csv"
            var contents = ""
            for i in 0...self.items.count-1 {
                contents = contents + "\(self.items[i]), \(self.levelnumber[i])\n"
            }
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = dir.appendingPathComponent(file)
            var filesToShare = [Any]()
            
            do {
                //                            try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
                try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                filesToShare.append(fileURL)
                itemsPdf = self.items
                levelnumberPdf = self.levelnumber
                itemsPdfSecond[openSensorNumber-1] = self.items
                levelnumberPdfSecond[openSensorNumber-1] = self.levelnumber
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                print("Error: \(error)")
                self.showToast(message: "Error".localized(code), seconds: 1.0)
                
            }
        }

        let plusButton = UIImageView(frame: CGRect(x: screenWidth-86, y: screenHeight-86, width: 70, height: 70))
        plusButton.image = #imageLiteral(resourceName: "Group 13")
        plusButton.layer.shadowRadius = 4.0
        plusButton.layer.shadowOpacity = 0.6
        plusButton.layer.shadowOffset = CGSize(width: -4.0, height: 4.0)
        view.addSubview(plusButton)
        var i = 2
        plusButton.addTapGesture {
            self.generator.impactOccurred()
            if sliv == true {
                startVTar = Int(self.items[0]) ?? 0
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    self.removeView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth-126, height: 60)
                }) { (true) in
                    self.removeView.removeFromSuperview()
                }
                if startVTar-stepTar >= 0 {
                    self.items.insert("\(Int(self.items[0])!-stepTar)", at: 0)
                    self.levelnumber.insert("1", at: 0)
                } else {
                    if startVTar-stepTar > -stepTar {
                        self.items.insert("\(0)", at: 0)
                        self.levelnumber.insert("1", at: 0)
                    }
                }
                i += 1
            } else {
                startVTar = Int(self.items[0]) ?? 0
                print(self.items[0])
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    self.removeView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth-126, height: 60)
                }) { (true) in
                    self.removeView.removeFromSuperview()
                }
                if startVTar+stepTar >= 0 && startVTar+stepTar <= 4095 {
                    self.items.insert("\(Int(self.items[0])!+stepTar)", at: 0)
                    self.levelnumber.insert("1", at: 0)
                } else {
                    if startVTar+stepTar < 4095+stepTar {
                        self.items.insert("\(4095)", at: 0)
                        self.levelnumber.insert("1", at: 0)
                    }
                }
                i += 1
            }
            let file = "Тарировка \(openSensorNumber) датчика.csv"
            var contents = ""
            for i in 0...self.items.count-1 {
                contents = contents + "\(self.items[i]), \(self.levelnumber[i])\n"
            }
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = dir.appendingPathComponent(file)
            var filesToShare = [Any]()
            do {
                try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                filesToShare.append(fileURL)
                //                    self.showToast(message: "Файл \(textName) сохранен", seconds: 1.0)
            }
            catch {
                print("Error: \(error)")
                //                    self.showToast(message: "Ошибка", seconds: 1.0)
                
            }
            self.tableView.reloadData()

        }
//        timer =  Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
//            self.tableView.reloadData()
//        }
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            headerView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            headerView1.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            menuImage.theme.tintColor = themed{ $0.navigationTintColor }
            editImageStep.theme.tintColor = themed{ $0.navigationTintColor }
            editImageZaliv.theme.tintColor = themed{ $0.navigationTintColor }
            tempLabel.theme.textColor = themed{ $0.navigationTintColor }
            nameNumberLabel.theme.textColor = themed{ $0.navigationTintColor }
            levelLabel.theme.textColor = themed{ $0.navigationTintColor }
            idlLabel.theme.textColor = themed{ $0.navigationTintColor }
            stepLabel.theme.textColor = themed{ $0.navigationTintColor }
            stabLabel.theme.textColor = themed{ $0.navigationTintColor }
            stabToplivoLabel.theme.textColor = themed{ $0.navigationTintColor }
            stepNumberlLabel.theme.textColor = themed{ $0.navigationTintColor }
            levelLabel1.theme.textColor = themed{ $0.navigationTintColor }
            tempLabel1.theme.textColor = themed{ $0.navigationTintColor }
            imageTemp.theme.tintColor = themed{ $0.navigationTintColor }
            viewMenu.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            editImageStep.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            editImageZaliv.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMenu.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            imageTemp.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            tempLabel1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            levelLabel1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            stabLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            stepLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            idlLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            levelLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            nameNumberLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            tempLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            menuImage.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            headerView1.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            headerView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            stepNumberlLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            stabToplivoLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
     }
}

extension CalibrationCreate: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalibrationCell", for: indexPath) as! CalibrationCell
        if indexPath.section == 0 {
            let item = items[indexPath.item]
            print("indexPath: \(indexPath)")
//            let level = self.levelnumber
            cell.titleLabel.text = "\(item)"
            cell.levelLabel.text = levelnumber[indexPath.item]
            cell.backgroundColor = .clear
            //        cell.coverView.image = UIImage(named: "temp")
            if indexPath.item == (items.count-1) {
                let file = "Тарировка \(openSensorNumber) датчика.csv"
                var contents = ""
                for i in 0...self.items.count-1 {
                    contents = contents + "\(self.items[i]), \(self.levelnumber[i])\n"
                }
                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                let fileURL = dir.appendingPathComponent(file)
                var filesToShare = [Any]()
                do {
                    try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                    filesToShare.append(fileURL)
//                    self.showToast(message: "Файл \(textName) сохранен", seconds: 1.0)
                }
                catch {
                    print("Error: \(error)")
//                    self.showToast(message: "Ошибка", seconds: 1.0)

                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if items.count > 1 {
            if editingStyle == .delete {
                print(items)
                let tableViewDel = items[indexPath.item]
                let tableViewDel2 = levelnumber[indexPath.item]
                
                let labelDelete = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
                labelDelete.center.y = 30
                labelDelete.text = "Deleted".localized(code)
                labelDelete.textColor = UIColor(rgb: 0xEFEFEF)
                labelDelete.font = UIFont(name:"FuturaPT-Light", size: 18.0)
                removeView.addSubview(labelDelete)
                
                let labelDeleteB = UILabel(frame: CGRect(x: screenWidth/2, y: 0, width: 100, height: 30))
                labelDeleteB.center.y = 30
                labelDeleteB.center.x = screenWidth/2 - (iphone5s ? 30 : 0)
                labelDeleteB.text = "Cancel".localized(code)
                labelDeleteB.textAlignment = .right
                labelDeleteB.textColor = UIColor(rgb: 0xCF2121)
                labelDeleteB.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
                removeView.addSubview(labelDeleteB)
                
                items.remove(at: indexPath.item)
                levelnumber.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .fade)
                removeView.backgroundColor = UIColor(rgb: 0x00A778)
                removeView.layer.cornerRadius = 20
                removeView.layer.shadowRadius = 4.0
                removeView.layer.shadowOpacity = 0.6
                removeView.layer.shadowOffset = CGSize(width: -4.0, height: 4.0)
                view.addSubview(removeView)
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    self.removeView.frame = CGRect(x: 20, y: screenHeight-86, width: screenWidth-126, height: 60)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                        self.removeView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth-126, height: 60)
                    }) { (true) in
                        self.removeView.removeFromSuperview()
                    }
                }
                removeView.addTapGesture {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                        self.removeView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth-126, height: 60)
                        self.items.insert("\(tableViewDel)", at: indexPath.item)
                        self.levelnumber.insert("\(tableViewDel2)", at: indexPath.item)
                        self.tableView.reloadData()
                        
                    }) { (true) in
                        self.removeView.removeFromSuperview()
                    }
                }
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 76)
        
//            headerView.addSubview(tempLabel)
            nameNumberLabel.text = "\(nameDevice)"

//            headerView.addSubview(nameNumberLabel)
            
//            headerView.addSubview(levelLabel)
            idlLabel.text = "\(id)"

            headerView.addSubview(idlLabel)
//            stabLabel.text = "Initial tank volume".localized(code) + ": \(String(describing: items.last!))"
//            if sliv == true {
            headerView.addSubview(stabLabel)
            headerView.addSubview(stabToplivoLabel)
//            } else {
//                stabLabel.removeFromSuperview()
//            }
            
            stepNumberlLabel.text = "\(stepTar)"

            headerView.addSubview(stepNumberlLabel)
            let pixelstep = stepNumberlLabel.text?.count

            stepLabel.frame = CGRect.init(x: Int(screenWidth)-70-Int(pixelstep!*10), y: 16, width: 55, height: 19)
            editImageStep.frame = CGRect.init(x: Int(screenWidth)-75-Int(pixelstep!*10), y: 16, width: 15, height: 15)
            
            editImageZaliv.frame = CGRect(x: 20 + (sliv ? 40 : 50), y: 16, width: 15, height: 15)

            headerView.addSubview(editImageZaliv)
            
            headerView.addSubview(stepLabel)
            headerView.addSubview(editImageStep)

            let stepLabelPlace = UIView(frame: CGRect(x: Int(screenWidth)-80-Int(pixelstep!*10), y: 10, width: Int(screenWidth)-80-Int(pixelstep!*10), height: 35))
            headerView.addSubview(stepLabelPlace)
            
            stepLabelPlace.addTapGesture {
                let alert = UIAlertController(title: "Make changes".localized(code), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized(code), style: .cancel, handler: nil))

                alert.addTextField(configurationHandler: { textField in
                    textField.keyboardType = .numberPad
                    textField.text = "\(stepTar)"
                })

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

                    if let txtField = alert.textFields?.first, let text = txtField.text {
                        if let IntText = Int(text) {
                            stepTar = IntText
                            self.tableView.reloadData()
                        } else {
                            self.showToast(message: "Incorrect value entered".localized(code), seconds: 2.0)
                        }
                    }
                }))

                self.present(alert, animated: true)
            }

            if sliv == true {
                calibLabel.text = "Draining".localized(code)
                calibLabel.textColor = UIColor(rgb: 0x00A778)
            } else {
                calibLabel.text = "Filing".localized(code)
                calibLabel.textColor = UIColor(rgb: 0xCF2121)
            }
            headerView.addSubview(calibLabel)
            calibLabel.addTapGesture {
                self.alertSliv()
            }
            editImageZaliv.addTapGesture {
                self.alertSliv()
            }
            let seperator = UIView()
            seperator.frame = CGRect(x: 0, y: headerView.frame.height-2, width: screenWidth, height: 2)
            seperator.backgroundColor = UIColor(rgb: 0xCF2121)
            headerView.addSubview(seperator)
            
            return headerView
        } else {
            headerView1.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 76)
            headerView1.addSubview(imageTemp)
            
            tempLabel1.text = "\(temp ?? "0")°"
            headerView1.addSubview(tempLabel1)
            
            levelLabel1.text = "Level".localized(code) + ": \(level)"
            headerView1.addSubview(levelLabel1)
            
            stabLabel1.text = "Stable".localized(code)
            headerView1.addSubview(stabLabel1)
            
            let seperator = UIView()
            seperator.frame = CGRect(x: 0, y: headerView1.frame.height-2, width: screenWidth, height: 2)
            seperator.backgroundColor = UIColor(rgb: 0xCF2121)
            headerView1.addSubview(seperator)
            
            return headerView1
        }
    }
    func alertSliv() {
        let alertController = UIAlertController(title: "Выберите способ".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let slivButton = UIButton(frame: CGRect(x: 20, y: 50, width: view.frame.width / 3 * 2 - 40 + (iphone5s ? 50 : 0), height: 50))
        let zalivButton = UIButton(frame: CGRect(x: 20, y: 110, width: view.frame.width / 3 * 2 - 40 + (iphone5s ? 50 : 0), height: 50))

        if sliv == true {
            slivButton.layer.cornerRadius = 20
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
            slivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
            
            zalivButton.layer.cornerRadius = 20
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
            zalivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
        } else {
            zalivButton.layer.cornerRadius = 20
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
            zalivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
            
            slivButton.layer.cornerRadius = 20
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
            slivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
        }
        slivButton.addTapGesture {
            self.generator.impactOccurred()
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.layer.borderWidth = 0
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.backgroundColor = .clear
        }
        zalivButton.addTapGesture {
            self.generator.impactOccurred()
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.layer.borderWidth = 0
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.backgroundColor = .clear
        }

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Изменить".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            self.generator.impactOccurred()
            if slivButton.backgroundColor == UIColor(rgb: 0xCF2121) {
                sliv = true
            } else {
                sliv = false
            }
            self.tableView.reloadData()
        })
        alertController.view.addSubview(slivButton)
        alertController.view.addSubview(zalivButton)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CalibrationCreate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let alertController = UIAlertController(title: "Make changes".localized(code), message: "Liters".localized(code) + " and ".localized(code) + "Level".localized(code), preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField()
        alertController.addTextField()

        alertController.textFields![0].text = self.items[indexPath.item]
        alertController.textFields![0].keyboardType = .numberPad
        alertController.textFields![0].leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: alertController.textFields![0].frame.height))
        alertController.textFields![0].leftViewMode = .always
        alertController.textFields![0].keyboardAppearance = isNight ? .dark : .light
        alertController.textFields![0].autocorrectionType = .default

        alertController.textFields![1].text =  self.levelnumber[indexPath.item]
        alertController.textFields![1].keyboardType = .numberPad
        alertController.textFields![1].leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: alertController.textFields![1].frame.height))
        alertController.textFields![1].leftViewMode = .always
        alertController.textFields![1].keyboardAppearance = isNight ? .dark : .light
        alertController.textFields![1].autocorrectionType = .default
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            self.items[indexPath.item] = alertController.textFields![0].text ?? ""
            startVTar = Int(self.items[0]) ?? 0
            self.levelnumber[indexPath.item] = alertController.textFields![1].text ?? ""
            self.tableView.reloadData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
