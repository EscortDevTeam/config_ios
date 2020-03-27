//
//  AddSensorTableView.swift
//  Escort
//
//  Created by Володя Зверев on 12.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import YPImagePicker
import ImageSlideshow
import MobileCoreServices
import UIDrawer

extension AddSensor : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableView {
        case self.tableView:
            return false
        default:
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            print("Ops")
        default:
            print("Ops")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let TrashAction = UIContextualAction()
        switch tableView {
        case self.tableView:
            return UISwipeActionsConfiguration(actions: [TrashAction])
        default:
            return UISwipeActionsConfiguration(actions: [TrashAction])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow = 0
        switch tableView {
        case self.tableView:
            if indexPath.row == 0 {
                heightRow = 60
            } else if indexPath.row == 1 {
                heightRow = 310
            } else if indexPath.row == 2 || indexPath.row == 3 {
                heightRow = 210
            } else if indexPath.row == 4 {
                heightRow = 500
            }  else {
                heightRow = 100
            }
        default:
            print("Ops")
        }
        return CGFloat(heightRow)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case self.tableView:
            numberOfRow = 5
        default:
            print("Ops")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done".localized(code), style: .done, target: self, action: #selector(resetTapped))
        bar.setItems([reset,done], animated: false)
        bar.sizeToFit()
        
        switch tableView {
        case self.tableView:
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSensorCell", for: indexPath) as! AddSensorCell
            cell.backgroundColor = .clear
            cell.titleLabel.text = "Датчик уровня топлива".localized(code)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSensorCellTwo", for: indexPath) as! AddSensorCellTwo
            cell.backgroundColor = .clear
            cell.titleLabel.text = "№ \(openSensorNumber) датчика".localized(code)
            cell.titleLabelThree.text = "№ 1 пломбы".localized(code)
            cell.photoLabel.text = "Фото номера пломбы"
            cell.setupMapTableTextField.inputAccessoryView = bar
            cell.setupMapTableTextFieldThree.inputAccessoryView = bar
            cell.referenceImage.addTapGesture {
                referenceMapInfo = """
                В этом поле требуется указать номер датчика
                
                Пример: 107203
                """
                referenceMapMain = "Номер датчика:"
                self.showReferenceFunc()
            }
            cell.referenceImage2.addTapGesture {
                referenceMapInfo = """
                В этом поле требуется указать номер пломбы, установленного на разъём проводного датчика или защитный кожух BLE
                """
                referenceMapMain = "Номер пломбы №1:"
                self.showReferenceFunc()
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSensorCellThree", for: indexPath) as! AddSensorCellThree
            cell.backgroundColor = .clear
            cell.titleLabel.text = "№ 2 пломба".localized(code)
            cell.photoLabel.text = "Фото номера пломбы"
            cell.setupMapTableTextField.inputAccessoryView = bar
            cell.referenceImage.addTapGesture {
                referenceMapInfo = """
                В этом поле можно указать номер пломбы, установленного на разъём проводного датчика или защитный кожух BLE
                """
                referenceMapMain = "Номер доп. пломбы:"
                self.showReferenceFunc()
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSensorCellFour", for: indexPath) as! AddSensorCellFour
            cell.backgroundColor = .clear
            cell.titleLabel.text = "Дополнительные сведения".localized(code)
            cell.photoLabel.text = "Фото Места установки"
            cell.setupMapTableTextField.inputAccessoryView = bar
            cell.referenceImage.addTapGesture {
                referenceMapInfo = """
                Здесь можно указать любую дополнительную информацию
                
                Пример: скрытая установка антенн или как уничтожить систему.
                """
                referenceMapMain = "Доп. сведения:"
                self.showReferenceFunc()
            }
            cell.referenceImage2.addTapGesture {
                referenceMapInfo = """
                Фотография должна отражать вид формы бака и место установки датчика
                """
                referenceMapMain = "Фото места установки:"
                self.showReferenceFunc()
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSensorCellFive", for: indexPath) as! AddSensorCellFive
            cell.titleLabel.text = "Файл тарировки".localized(code)
            cell.backgroundColor = .clear
            cell.mapHelpButton.addTarget(self, action: #selector(onButtonClick(_:)), for: UIControl.Event.touchUpInside)
            if openSensorNumber == 1 {
                if itemsPdfSecond[0] == [""] {
                    cell.fileEdit.isHidden = true
                    cell.fileLater.isHidden = false
                    cell.fileAdd.isHidden = false
                } else {
                    cell.fileEdit.isHidden = false
                    cell.fileLater.isHidden = true
                    cell.fileAdd.isHidden = true
                }
            } else if openSensorNumber == 2 {
                if itemsPdfSecond[1] == [""] {
                    cell.fileEdit.isHidden = true
                    cell.fileLater.isHidden = false
                    cell.fileAdd.isHidden = false
                } else {
                    cell.fileEdit.isHidden = false
                    cell.fileLater.isHidden = true
                    cell.fileAdd.isHidden = true
                }
            } else if openSensorNumber == 3 {
                if itemsPdfSecond[2] == [""] {
                    cell.fileEdit.isHidden = true
                    cell.fileLater.isHidden = false
                    cell.fileAdd.isHidden = false
                } else {
                    cell.fileEdit.isHidden = false
                    cell.fileLater.isHidden = true
                    cell.fileAdd.isHidden = true
                }
            } else if openSensorNumber == 4 {
                if itemsPdfSecond[3] == [""] {
                    cell.fileEdit.isHidden = true
                    cell.fileLater.isHidden = false
                    cell.fileAdd.isHidden = false
                } else {
                    cell.fileEdit.isHidden = false
                    cell.fileLater.isHidden = true
                    cell.fileAdd.isHidden = true
                }
            }
            cell.fileAdd.addTapGesture {
                self.generator.impactOccurred()
                tarNew = true
                self.alertSliv()
            }
            cell.fileLater.addTapGesture {
                self.generator.impactOccurred()
                let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                self.present(documentPicker, animated: true, completion: nil)
            }
            cell.fileEdit.addTapGesture {
                self.generator.impactOccurred()
                tarNew = false
                itemsT = itemsPdfSecond[openSensorNumber-1]
                levelnumberT = levelnumberPdfSecond[openSensorNumber-1]
                self.navigationController?.pushViewController(CalibrationCreate(), animated: true)
            }
            return cell
        }  else {
            return cell
            }
        default:
            print("Ops")
            return cell
            }
    }
    func alertSliv() {
        let alertController = UIAlertController(title: "Выберите способ".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let slivButton = UIButton(frame: CGRect(x: 20, y: 50, width: view.frame.width/3*2-40, height: 50))
        let zalivButton = UIButton(frame: CGRect(x: 20, y: 110, width: view.frame.width/3*2-40, height: 50))

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
            sliv = true
        }
        zalivButton.addTapGesture {
            self.generator.impactOccurred()
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.layer.borderWidth = 0
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.backgroundColor = .clear
            sliv = false
        }

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Далее".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(CalibrationCreate(), animated: true)
        })
        alertController.view.addSubview(slivButton)
        alertController.view.addSubview(zalivButton)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func resetTapped() {
        self.view.endEditing(true)
    }
    @objc private func onButtonClick(_ sender: UIButton) {
        if photoALLNumberDutLabel[numberSelectSensor] != "" && photoALLNumberDutLabel[numberSelectSensor].count == 6 && photoALLPlombaFirstTrackLabel[numberSelectSensor] != "" && photoALLPlaceSetTrack[numberSelectSensor].count != 1 {
            self.generator.impactOccurred()
            if addORopen {
                self.navigationController?.popViewController(animated: true)
                numberOfRowLvlTopPreLast += 1
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            print(numberOfRowLvlTopPreLast)
        } else {
            showToast(message: "Заполните данные на экране", seconds: 1.0)
        }
    }
}

extension AddSensor: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        sandboxFileURLPath = selectedFileURL.absoluteURL
//        print(sandboxFileURLPath!.path.dropLast(Int((sandboxFileURLPath?.path.count)!)+3))
//        print(sandboxFileURLPath)
//        if chekOpen == true {
//            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
//            sandboxFileURLPath = dir
//            print(sandboxFileURLPath!.path)
//            print(sandboxFileURL.path)
//            self.navigationController?.pushViewController(TarirovkaSettingsViewController(), animated: true)
//        } else {
        do {
            let applicationURLs = FileManager.default.urls(for: .applicationDirectory, in: .allDomainsMask)
            print(applicationURLs)
            print(textName.count)
            let contents = try String(contentsOfFile: selectedFileURL.path)
            print(selectedFileURL.path)
            let cont = contents.split(separator: "\n")
            print(cont.count)
            var checkSliv = 0
            for i in 0...cont.count-1 {
                let rom = cont[i].split(separator: ",")
                let a = rom[1].split(separator: " ")
                if i == 0 {
                    checkSliv = Int(String(rom[0]))!
                }
                if i == 1 {
                    if Int(String(rom[0]))! > checkSliv{
                        sliv = true
                    } else {
                        sliv = false
                    }
                }
                itemsT.append("\(rom[0])")
                levelnumberT.append("\(a[0])")
                print("items: \(rom[0])" + " levelnumber: \(a[0])")
            }
            tarNew = false
            let nameSave = selectedFileURL.path
            let nameSaveMassiv = nameSave.split(separator: "/")
            let nameLast = nameSaveMassiv.last!.split(separator: ".")
            textName = "\(String(describing: nameLast.first!))"
            sliv = true
            self.navigationController?.pushViewController(CalibrationCreate(), animated: true)

            
        }
        catch {
            print("Error: \(error)")
        }
    }
    func alert() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 100, height: 30))
        labelLits.text = "Step".localized(code)
        labelLits.alpha = 0.58
        labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)
        
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always
        
        let labelLevel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 30))
        labelLevel.text = "Initial tank volume".localized(code)
        labelLevel.alpha = 0.58
        labelLevel.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let secondTextField = UITextField(frame: CGRect(x: 20, y: 130, width: view.frame.width/3*2-40, height: 30))
        secondTextField.text = ""
        secondTextField.keyboardType = .numberPad
        secondTextField.layer.cornerRadius = 5
        secondTextField.layer.borderWidth = 1
        secondTextField.layer.borderColor = UIColor(named: "Color")?.cgColor
        secondTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: secondTextField.frame.height))
        secondTextField.leftViewMode = .always
        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(firstTextField.text!)) ?? 0
            startVTar = Int(String(secondTextField.text!)) ?? 0
            self.navigationController?.pushViewController(CalibrationCreate(), animated: true)

        })
        
        
        alertController.view.addSubview(labelLits)
        alertController.view.addSubview(labelLevel)
        alertController.view.addSubview(firstTextField)
        alertController.view.addSubview(secondTextField)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func alertZaliv() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 100, height: 30))
        labelLits.text = "Step".localized(code)
        labelLits.alpha = 0.58
        labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 160)
        
        alertController.view.addConstraint(height)
        
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(firstTextField.text!)) ?? 0
            self.navigationController?.pushViewController(CalibrationCreate(), animated: true)

        })
        
        
        alertController.view.addSubview(labelLits)
        alertController.view.addSubview(firstTextField)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func alertSlivFile() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let slivButton = UIButton(frame: CGRect(x: 20, y: 50, width: view.frame.width/3*2-40, height: 50))
        let zalivButton = UIButton(frame: CGRect(x: 20, y: 110, width: view.frame.width/3*2-40, height: 50))

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
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.layer.borderWidth = 0
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.backgroundColor = .clear
            sliv = true
        }
        zalivButton.addTapGesture {
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.layer.borderWidth = 0
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.backgroundColor = .clear
            sliv = false
        }

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            if sliv == true {
                self.alert()
            } else {
                self.alertZaliv()
            }

        })
        
        
        alertController.view.addSubview(slivButton)
        alertController.view.addSubview(zalivButton)

        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AddSensor {
    fileprivate func showReferenceFunc() {
        self.generator.impactOccurred()
        let viewController = ReferenceController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
}
extension AddSensor: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: 88, modalWidth: 0, cornerRadius: 52)
   }
}
