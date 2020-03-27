//
//  ModelTCTableView.swift
//  Escort
//
//  Created by Володя Зверев on 27.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import YPImagePicker
import ImageSlideshow
import UIDrawer

extension SetupMap : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableView {
        case self.tableViewOneMore:
            if indexPath.row == numberOfRowPreLast - 1 {
                return false
            } else {
                return true
            }
        case self.tableView:
            return false
        case self.tableViewTrack:
            return false
        case self.tableViewLvlTop:
            if indexPath.row == numberOfRowLvlTopPreLast - 1 {
                return false
            } else {
                return true
            }
        default:
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableViewOneMore:
            numberOfRowPreLast -= 1
            if editingStyle == .delete {
                tableView.deleteRows(at: [indexPath], with: .left)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        case self.tableView:
            print("Ops")
        case self.tableViewTrack:
            print("Ops")
        case self.tableViewLvlTop:
            numberOfRowLvlTopPreLast -= 1
            if editingStyle == .delete {
                tableView.deleteRows(at: [indexPath], with: .left)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        default:
            print("Ops")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var TrashAction = UIContextualAction()
        switch tableView {
        case self.tableViewOneMore:
            TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Update action ...")
                self.generator.impactOccurred()
                numberOfRowPreLast -= 1
                photoALLMore.remove(at: indexPath.row)
                photoALLMore.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                tableView.deleteRows(at: [indexPath], with: .left)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tableView.reloadData()
                }
                success(true)
            })
            TrashAction.backgroundColor = .clear
            TrashAction.image =  UIImage(named: "delete")
            return UISwipeActionsConfiguration(actions: [TrashAction])
        case self.tableView:
            print("Ops")
            return UISwipeActionsConfiguration(actions: [TrashAction])
        case self.tableViewTrack:
            print("Ops")
            return UISwipeActionsConfiguration(actions: [TrashAction])
        case self.tableViewLvlTop:
            TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Update action ...")
                self.generator.impactOccurred()
                numberOfRowLvlTopPreLast -= 1
                numberSensorOne.remove(at: indexPath.row)
                numberSensorOne.append("")
                itemsPdfSecond.remove(at: indexPath.row)
                levelnumberPdfSecond.remove(at: indexPath.row)
                itemsPdfSecond.append([""])
                levelnumberPdfSecond.append([""])
                photoALLPlombaFirstTrack.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_1\(indexPath.row)")
                UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_2\(indexPath.row)")
                photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                photoALLPlombaSecondTrack.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_1\(indexPath.row)")
                UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_2\(indexPath.row)")
                photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                photoALLPlaceSetTrack.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_1\(indexPath.row)")
                UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_2\(indexPath.row)")
                photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                
                photoALLNumberDutLabel.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "DUT_\(indexPath.row)")
                photoALLNumberDutLabel.append("")

                photoALLPlombaFirstTrackLabel.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "DUTP_\(indexPath.row)")
                photoALLPlombaFirstTrackLabel.append("")
                
                photoALLPlombaSecondTrackLabel.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "DUTP2_\(indexPath.row)")
                photoALLPlombaSecondTrackLabel.append("")
                
                photoALLPlaceSetTrackLabel.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "DUTDop_\(indexPath.row)")
                photoALLPlaceSetTrackLabel.append("")
                
                DutTrackLabel.remove(at: indexPath.row)
                UserDefaults.standard.removeObject(forKey: "DUTMain_\(indexPath.row)")
                DutTrackLabel.append("ТД - Онлайн")
                

                print("itemsPdfSecond: \(itemsPdfSecond)")
                tableView.deleteRows(at: [indexPath], with: .left)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tableView.reloadData()
                }
                success(true)
            })
            TrashAction.backgroundColor = .clear
            TrashAction.image =  UIImage(named: "delete")
            return UISwipeActionsConfiguration(actions: [TrashAction])
        default:
            print("Ops")
            return UISwipeActionsConfiguration(actions: [TrashAction])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow = 0
        switch tableView {
        case self.tableView:
            if indexPath.row == 0 {
                heightRow = 180
            } else {
                heightRow = 500
            }
        case self.tableViewOneMore:
            if indexPath.row == numberOfRowPreLast-1 {
                heightRow = 200
            } else {
                heightRow = 180
            }
        case self.tableViewTrack:
            if indexPath.row == 0 {
                heightRow = hasNotch ? 40 : 65
            } else if indexPath.row == 1 {
                heightRow = 210
            } else if indexPath.row == 4 {
                heightRow = 140
            } else if indexPath.row == 2 {
                heightRow = 40
            } else if indexPath.row == 3 {
                heightRow = 210
            } else if indexPath.row == 5 {
                heightRow = 400
            }
        case self.tableViewLvlTop:
            if indexPath.row == numberOfRowLvlTopPreLast-1 {
                heightRow = 400
            } else {
                heightRow = 120
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
            numberOfRow = 2
        case self.tableViewTrack:
            numberOfRow = 6
        case self.tableViewOneMore:
            numberOfRow = numberOfRowPreLast
        case self.tableViewLvlTop:
            numberOfRow = numberOfRowLvlTopPreLast
        default:
            print("Ops")
        }
        return numberOfRow
    }
    
    fileprivate func showReferenceFunc() {
        self.generator.impactOccurred()
        let viewController = ReferenceController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    
    fileprivate func hiddenAllForTabModelTrack() {
        self.themeBackView3.isHidden = true
        self.MainLabel.isHidden = true
        self.backView.isHidden = true
        self.hamburger.isHidden = true
        self.progresViewAll.isHidden = true
        self.statusBarRedOne.isHidden = true
        self.statusBarRedTwo.isHidden = true
        self.statusBarRedThree.isHidden = true
        self.statusBarRedFour.isHidden = true
        self.statusBarRedFive.isHidden = true
        self.statusBarRedSix.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch tableView {
        case self.tableView:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            print(indexPath.row)

            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Модель ТС"
                cell.setupMapTableTextField.text = modelTcText
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    В этом поле требуется указать марку и модель транспортного средства , на которое осуществляется монтаж.
                    
                    Пример: manTGA
                    
                    На фотографиях должен быть общий вид ТС.
                    """
                    referenceMapMain = "Модель ТС:"
                    self.showReferenceFunc()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapCellNumberTC", for: indexPath) as! MapCellNumberTC
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Номер ТС"
                cell.setupMapTableTextField.text = numberTcText
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    В этом поле требуется указать государственный регистрационный знак транспортного средства, на которое осуществляется монтаж.
                    
                    На фотографиях должен быть читаемый номер.
                    """
                    referenceMapMain = "Номер ТС:"
                    self.showReferenceFunc()
                }
                return cell
            }
        case self.tableViewOneMore:
            if indexPath.row == numberOfRowPreLast-1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapCellOneMoreAdd", for: indexPath) as! MapCellOneMoreAdd
                cell.backgroundColor = .clear
                cell.titleLabel.isHidden = false
                if indexPath.row == 4 {
                    cell.titleLabel.isHidden = true
                }
                cell.titleLabel.text = "Добавить".localized(code)
                cell.titleLabel.addTapGesture {
                    self.generator.impactOccurred()
                    numberOfRowPreLast += 1
                    tableView.reloadData()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapCellOneMore", for: indexPath) as! MapCellOneMore
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Дополнительные сведения".localized(code)
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    Укажите дополнительную информацию, которая не отражена в стандартных формах карты установки
                    """
                    referenceMapMain = "Доп. сведения:"
                    self.showReferenceFunc()
                }
                return cell
            }
        case self.tableViewTrack:
            print(indexPath.row)
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackZeroCell", for: indexPath) as! MapTrackZeroCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Трекер"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackOneCell", for: indexPath) as! MapTrackOneCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Модель трекера".localized(code)
                cell.photoLabel.text = "Фото наклейки".localized(code)
                cell.setupMapTableTextField.text = modelTrackText
//                cell.modelTrackTextFieldTab.addTapGesture {
//                    self.searchModelTrack.becomeFirstResponder()
//                    self.hiddenAllForTabModelTrack()
//                    UIView.animate(withDuration: 0.5, animations: {
//                        tableView.frame.origin.y = -110
//                        self.searchModelTrack.isHidden = false
//                        self.backViewModelTrack.isHidden = false
//                    }) { (true) in
//                        UIView.animate(withDuration: 0.5, animations: {
//                            tableView.alpha = 0.0
//                            self.searchModelTrack.alpha = 1.0
//                            self.backViewModelTrack.alpha = 1.0
//                        }) { (true) in
//                            tableView.isHidden = true
//                        }
//                    }
//                }
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    В этом поле требуется указать название и модель устанавливаемого ГЛОНАСС/GPS трекера.
                    
                    Пример: Navtelecom SMART
                    
                    На фотографиях должен быть IMEI и серийный номер трекера.
                    """
                    referenceMapMain = "Модель трекера:"
                    self.showReferenceFunc()
                }
                return cell
            } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackFourCell", for: indexPath) as! MapTrackFourCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Фото места установки".localized(code)
                cell.collectionView.reloadData()
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackTwoCell", for: indexPath) as! MapTrackTwoCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Пломба"
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackThreeCell", for: indexPath) as! MapTrackThreeCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Номер пломбы".localized(code)
                cell.photoLabel.text = "Фото пломбы".localized(code)
                cell.setupMapTableTextField.text = plombaTrackText
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    В этом поле требуется указать номер пломбы, установленный на трекер.
                    
                    На фотографиях должен быть читаемый номер пломбы.
                    """
                    referenceMapMain = "Номер пломбы:"
                    self.showReferenceFunc()
                }
                if TCorModel == true {
                    cell.setUpDataSource()
                }
                
                cell.collectionView.addTapGesture {
                   
                }
                return cell
            } else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTrackFiveCell", for: indexPath) as! MapTrackFiveCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "Дополнительные сведения"
                cell.setupMapTableTextField.text = infoTrackText
                cell.referenceImage.addTapGesture {
                    referenceMapInfo = """
                    Здесь можно указать любую дополнительную информацию
                    
                    Пример: скрытая установка антенн или как уничтожить систему.
                    """
                    referenceMapMain = "Доп. сведения:"
                    self.showReferenceFunc()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = ""
                cell.setupMapTableTextField.isHidden = true
                cell.collectionView.isHidden = true
                cell.separetor.isHidden = true
                cell.viewMainList.isHidden = true
                return cell
            }
        case self.tableViewLvlTop:
            if indexPath.row == numberOfRowLvlTopPreLast-1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapLvlTopOneCell", for: indexPath) as! MapLvlTopOneCell
                cell.backgroundColor = .clear
                cell.titleLabel.isHidden = false
                if indexPath.row == 4 {
                    cell.titleLabel.isHidden = true
                }
                cell.titleLabel.text = "Добавить датчик".localized(code)
                cell.titleLabel.addTapGesture {
                    self.generator.impactOccurred()
                    addORopen = true
                    openSensorNumber = indexPath.row + 1
                    numberSelectSensor = indexPath.row
                    self.navigationController?.pushViewController(AddSensor(), animated: true)
                    UserDefaults.standard.set(numberOfRowLvlTopPreLast, forKey: "countDuts")
//                    numberOfRowLvlTopPreLast += 1
//                    tableView.reloadData()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapLvlTopTwoCell", for: indexPath) as! MapLvlTopTwoCell
                cell.backgroundColor = .clear
                cell.titleLabel.text = "№ \(indexPath.row+1) датчика".localized(code)
                cell.photoLabel.text = "№ \(photoALLNumberDutLabel[indexPath.row])"
                cell.openButton.text = "Открыть"
                cell.deleteButton.text = "Удалить"
                
                cell.deleteButton.addTapGesture {
                    self.generator.impactOccurred()
                    numberOfRowLvlTopPreLast -= 1
                    numberSensorOne.remove(at: indexPath.row)
                    numberSensorOne.append("")
                    itemsPdfSecond.remove(at: indexPath.row)
                    levelnumberPdfSecond.remove(at: indexPath.row)
                    itemsPdfSecond.append([""])
                    levelnumberPdfSecond.append([""])
                    photoALLPlombaFirstTrack.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_1\(indexPath.row)")
                    UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_2\(indexPath.row)")
                    photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                    photoALLPlombaSecondTrack.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_1\(indexPath.row)")
                    UserDefaults.standard.removeObject(forKey: "photoALLPlomba2DUT_2\(indexPath.row)")
                    photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                    photoALLPlaceSetTrack.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_1\(indexPath.row)")
                    UserDefaults.standard.removeObject(forKey: "photoALLSetDUT_2\(indexPath.row)")
                    photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
                    
                    photoALLNumberDutLabel.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "DUT_\(indexPath.row)")
                    photoALLNumberDutLabel.append("")

                    photoALLPlombaFirstTrackLabel.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "DUTP_\(indexPath.row)")
                    photoALLPlombaFirstTrackLabel.append("")
                    
                    photoALLPlombaSecondTrackLabel.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "DUTP2_\(indexPath.row)")
                    photoALLPlombaSecondTrackLabel.append("")
                    
                    photoALLPlaceSetTrackLabel.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "DUTDop_\(indexPath.row)")
                    photoALLPlaceSetTrackLabel.append("")
                    
                    DutTrackLabel.remove(at: indexPath.row)
                    UserDefaults.standard.removeObject(forKey: "DUTMain_\(indexPath.row)")
                    DutTrackLabel.append("ТД - Онлайн")
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        tableView.deleteRows(at: [indexPath], with: .left)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            tableView.reloadData()
                        }
                    })
             }
                cell.openButton.addTapGesture {
                    addORopen = false
                    openSensorNumber = indexPath.row + 1
                    self.generator.impactOccurred()
                    numberSelectSensor = indexPath.row
                    self.navigationController?.pushViewController(AddSensor(), animated: true)

                }
                return cell
            }
        default:
            print("Ops")
            return cell
            }
    }
}

extension SetupMap: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: 88, modalWidth: 0, cornerRadius: 52)
   }
}

