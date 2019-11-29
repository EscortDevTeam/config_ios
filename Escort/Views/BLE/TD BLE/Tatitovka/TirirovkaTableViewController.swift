//
//  TirirovkaTableViewController.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class TirirovkaTableViewController: UIViewController, UIScrollViewDelegate {
    let settings = ["Настройки","Техническая поддежрка","Оценить приложение"]
    weak var tableView: UITableView!
    var items: [String] = [
         "1"
     ]
    var levelnumber: [String] = ["1024"]
    var viewMenu = UIView()
    let dy: Int = screenWidth == 320 ? 0 : 10
    let dIy: Int = screenWidth == 375 ? -15 : 0
    let dIPrusy: Int = screenWidth == 414 ? -12 : 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TirirovkaCellViewController.self, forCellReuseIdentifier: "TirirovkaCellViewController")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PersonTableViewCellTwo")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        viewShow()
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()

    
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "tlBleBack")!)
        img.frame = CGRect(x: screenWidth/2, y: screenHeight/6+40, width: 152, height: 166)
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        let (headerView, backView) = headerSet(title: "Tank calibration".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        view.addSubview(bgImage)
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }

        let menuImage = UIImageView(frame: CGRect(x: Int(screenWidth-21), y: dIy + dy + (hasNotch ? dIPrusy+35 : 45), width: 6, height: 24))
        menuImage.image = #imageLiteral(resourceName: "Group 12")
        view.addSubview(menuImage)
        viewMenu = UIView(frame: CGRect(x: Int(screenWidth)-1, y: dIy + dy + (hasNotch ? dIPrusy+35 : 45) + 38, width: 0, height: 0))
        viewMenu.backgroundColor = UIColor(rgb: 0xF7F7F7)
        let viewAll = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let label = UILabel(frame: CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 47, width: 150, height: 19))
        let label2 = UILabel(frame: CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 74, width: 150, height: 19))
        let label3 = UILabel(frame: CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 101, width: 150, height: 19))
        let label4 = UILabel(frame: CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 128, width: 150, height: 19))
        // create menu
        menuImage.addTapGesture {
            viewAll.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            self.view.addSubview(viewAll)
            self.view.addSubview(self.viewMenu)
            self.view.addSubview(label)
            
            self.view.addSubview(label2)
            self.view.addSubview(label3)
            self.view.addSubview(label4)

            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                self.viewMenu.frame = CGRect(x: Int(screenWidth-173), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 38, width: 172, height: 120)
                self.viewMenu.layer.shadowOffset = CGSize(width: -6.0, height: 6.0)
                self.viewMenu.layer.shadowRadius = 2.0
                self.viewMenu.layer.shadowOpacity = 0.3
            }) { (true) in
            print("Done")
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    label.frame = CGRect(x: Int(screenWidth-152), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 47, width: 150, height: 19)
                    label.text = "Сохранить файл"
                    label.font = UIFont(name:"FuturaPT-Light", size: 16.0)
                })
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    label2.frame = CGRect(x: Int(screenWidth-152), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 74, width: 150, height: 19)
                    label2.text = "Поделиться таблицей"
                    label2.font = UIFont(name:"FuturaPT-Light", size: 16.0)
                })
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                    label3.frame = CGRect(x: Int(screenWidth-152), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 101, width: 150, height: 19)
                    label3.text = "График"
                    label3.font = UIFont(name:"FuturaPT-Light", size: 16.0)
                })
                UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
                    label4.frame = CGRect(x: Int(screenWidth-152), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 128, width: 150, height: 19)
                    label4.text = "Завершить"
                    label4.font = UIFont(name:"FuturaPT-Light", size: 16.0)
                })
            }
        }
        // delete menu
        viewAll.addTapGesture {
            viewAll.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            print("Back")
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                label4.frame = CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 128, width: 150, height: 19)
            })
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                label3.frame = CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 101, width: 150, height: 19)
            })
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                label2.frame = CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 74, width: 150, height: 19)
            })
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
                label.frame = CGRect(x: Int(screenWidth), y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 41, width: 150, height: 19)
            }) { (true) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                    self.viewMenu.frame = CGRect(x: Int(screenWidth)-1, y: self.dIy + self.dy + (hasNotch ? self.dIPrusy+35 : 45) + 38, width: 0, height: 0)
                    label.removeFromSuperview()
                    label2.removeFromSuperview()
                    label3.removeFromSuperview()
                    label4.removeFromSuperview()

                })
            }
        }
        let plusButton = UIImageView(frame: CGRect(x: screenWidth-86, y: screenHeight-86, width: 70, height: 70))
        plusButton.image = #imageLiteral(resourceName: "Group 13")
        view.addSubview(plusButton)
        var i = 2
        plusButton.addTapGesture {
            self.items.insert("\(i)", at: 0)
            i += 1
            self.tableView.reloadData()
        }
    }
}

extension TirirovkaTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0{
                return 0
            } else {
                return self.items.count
            }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCellTwo", for: indexPath)
//            cell.backgroundColor = .clear
            //        cell.coverView.image = UIImage(named: "temp")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TirirovkaCellViewController", for: indexPath) as! TirirovkaCellViewController
            let item = self.items[indexPath.item]
            print("indexPath: \(indexPath)")
            let level = self.levelnumber[0]
            cell.titleLabel.text = item
            cell.levelLabel.text = level
            cell.backgroundColor = .clear
            //        cell.coverView.image = UIImage(named: "temp")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 109
        } else {
            return 76
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 109))
            headerView.backgroundColor = UIColor(rgb: 0xEFEFEF)
            
            let tempLabel = UILabel(frame: CGRect(x: 20, y: 16, width: 30, height: 19))
            tempLabel.text = "№:"
            tempLabel.textColor = UIColor(rgb: 0x272727)
            tempLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            headerView.addSubview(tempLabel)
            
            let nameNumberLabel = UILabel(frame: CGRect(x: 45, y: 16, width: 90, height: 19))
            nameNumberLabel.text = "22356"
            nameNumberLabel.textColor = UIColor(rgb: 0x272727)
            nameNumberLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            headerView.addSubview(nameNumberLabel)
            
            let levelLabel = UILabel()
            levelLabel.frame = CGRect.init(x: 20, y: 49, width: 30, height: 21)
            levelLabel.text = "ID:"
            levelLabel.textColor = UIColor(rgb: 0x272727)
            levelLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            headerView.addSubview(levelLabel)
            
            let idlLabel = UILabel(frame: CGRect(x: 45, y: 50, width: 150, height: 19))
            idlLabel.text = "1234567890"
            idlLabel.textColor = UIColor(rgb: 0x272727)
            idlLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            headerView.addSubview(idlLabel)
            
            let stabLabel = UILabel()
            stabLabel.frame = CGRect.init(x: 20, y: 84, width: 300, height: 23)
            stabLabel.text = "Initial tank volume".localized(code) + ": 105"
            stabLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            stabLabel.textColor = UIColor(rgb: 0x272727)
            headerView.addSubview(stabLabel)
            
            let stepNumberlLabel = UILabel(frame: CGRect(x: screenWidth-45, y: 17, width: 35, height: 19))
            stepNumberlLabel.text = "1"
            stepNumberlLabel.textColor = UIColor(rgb: 0x272727)
            stepNumberlLabel.textAlignment = .right
            stepNumberlLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            headerView.addSubview(stepNumberlLabel)
            let pixelstep = stepNumberlLabel.text?.characters.count
            
            let stepLabel = UILabel()
            stepLabel.frame = CGRect.init(x: Int(screenWidth)-70-Int(pixelstep!*10), y: 16, width: 55, height: 19)
            stepLabel.text = "Step".localized(code) + ":"
            stepLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            stepLabel.textColor = UIColor(rgb: 0x272727)
            stepLabel.textAlignment = .right
            headerView.addSubview(stepLabel)
            
            let calibLabel = UILabel()
            calibLabel.frame = CGRect.init(x: screenWidth-90, y: 50, width: 80, height: 20)
            calibLabel.text = "Draining".localized(code)
            calibLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            calibLabel.textColor = UIColor(rgb: 0x00A778)
            calibLabel.textAlignment = .right
            headerView.addSubview(calibLabel)
            
            let seperator = UIView()
            seperator.frame = CGRect(x: 0, y: headerView.frame.height-2, width: screenWidth, height: 2)
            seperator.backgroundColor = UIColor(rgb: 0xCF2121)
            headerView.addSubview(seperator)
            
            return headerView
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 76))
            headerView.backgroundColor = UIColor(rgb: 0xEFEFEF)

            let imageTemp = UIImageView(frame: CGRect(x: 25, y: 13, width: 12, height: 21))
            imageTemp.image = #imageLiteral(resourceName: "tempBlack")
            headerView.addSubview(imageTemp)
            
            let tempLabel = UILabel(frame: CGRect(x: 41, y: 13, width: 30, height: 23))
            tempLabel.text = "27°"
            tempLabel.textColor = UIColor(rgb: 0x272727)
            tempLabel.font = UIFont(name:"FuturaPT-Light", size: 16.0)
            headerView.addSubview(tempLabel)
            
            let levelLabel = UILabel()
            levelLabel.frame = CGRect.init(x: 25, y: 42, width: 120, height: 20)
            levelLabel.text = "Level".localized(code) + ": 1024"
            levelLabel.textColor = UIColor(rgb: 0x272727)
            levelLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            headerView.addSubview(levelLabel)
            
            let stabLabel = UILabel()
            stabLabel.frame = CGRect.init(x: screenWidth-108, y: 13, width: 93, height: 20)
            stabLabel.text = "Не стабилен"
            stabLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            stabLabel.textColor = UIColor(rgb: 0xCF2121)
            stabLabel.textAlignment = .right
            headerView.addSubview(stabLabel)
            
            let calibLabel = UILabel()
            calibLabel.frame = CGRect.init(x: screenWidth-183, y: 42, width: 168, height: 20)
            calibLabel.text = "Требуется калибровка"
            calibLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            calibLabel.textColor = UIColor(rgb: 0xCF2121)
            calibLabel.textAlignment = .right
            headerView.addSubview(calibLabel)
            
            let seperator = UIView()
            seperator.frame = CGRect(x: 0, y: headerView.frame.height-2, width: screenWidth, height: 2)
            seperator.backgroundColor = UIColor(rgb: 0xCF2121)
            headerView.addSubview(seperator)
            
            return headerView
        }
    }
}

extension TirirovkaTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.item]

        let alertController = UIAlertController(title: item, message: "Пустая Ячейка", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
