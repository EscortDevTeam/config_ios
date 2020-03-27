//
//  SetupMap.swift
//  Escort
//
//  Created by Володя Зверев on 26.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import YPImagePicker
import ImageSlideshow

extension SetupMap {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(numberSensorOne)
        tableViewLvlTop?.reloadData()
        tableViewTrack?.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        slideshow.setImageInputs([
            ImageSource(image: UIImage(named: "3")!),
            ImageSource(image: UIImage(named: "4")!)
            ])
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        viewShow()
        setupTheme()
        registerTableView()

        referenceTapFIO()
        referenceTapZakaz()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let string = textField.text {
            let st1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !st1.isEmpty { // Prints number of words.
                if st1.components(separatedBy: " ").count >= 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreen.alpha = 1.0
                        if self.successGreenSecond.alpha == 1.0 {
                            self.mapHelpButton.isEnabled = true
                        }
                    })
                }else {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreen.alpha = 0.0
                        self.mapHelpButton.isEnabled = false
                    })
                }
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.successGreen.alpha = 0.0
                    self.mapHelpButton.isEnabled = false
                })
                
            }
        }
        checkMaxLength(textField: textField, maxLength: 50)
    }
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        if let string = textField.text {
            let st1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !st1.isEmpty { // Prints number of words.
                if st1.components(separatedBy: " ").count >= 2 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreenSecond.alpha = 1.0
                        if self.successGreen.alpha == 1.0 {
                            self.mapHelpButton.isEnabled = true
                        }
                    })
                }else {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreenSecond.alpha = 0.0
                        self.mapHelpButton.isEnabled = false
                    })
                }
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.successGreenSecond.alpha = 0.0
                    self.mapHelpButton.isEnabled = false
                })
                
            }
        }
        checkMaxLength(textField: textField, maxLength: 30)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func closeMap() {
        self.progresViewAll.isHidden = true
        self.statusBarRedOne.isHidden = true
        self.statusBarRedTwo.isHidden = true
        self.statusBarRedThree.isHidden = true
        self.statusBarRedFour.isHidden = true
        self.statusBarRedFive.isHidden = true
        self.statusBarRedSix.isHidden = true
        self.mapHelp.isHidden = true
        self.viewRedLines.isHidden = true
        self.mapHelpTwo.isHidden = true
        self.viewGrayLines.isHidden = true
        self.viewGrayLinesSecond.isHidden = true
        self.mapHelpThree.isHidden = true
        self.mapHelpLabel.isHidden = true
        self.mapHelpButton.isHidden = true
        self.setupMapTextField.isHidden = true
        self.setupMapTextFieldSecond.isHidden = true
        self.setupMapText.isHidden = true
        let  vc =  self.navigationController?.viewControllers.filter({$0 is StartAppMenuController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    fileprivate func viewShow() {
        view.addSubview(themeBackView3)

        MainLabel.text = "Карта установки".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        view.addSubview(backViewModelTrack)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        let hamburgerPlace = UIView()
        var yHamb = screenHeight/22
        if screenWidth == 414 {
            yHamb = screenHeight/20
        }
        if screenHeight >= 750{
            yHamb = screenHeight/16
            if screenWidth == 375 {
                yHamb = screenHeight/19
            }
        }
        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb - (iphone5s ? 5 : 0), width: 40, height: 40)
        hamburger.frame = CGRect(x: screenWidth-45, y: yHamb - (iphone5s ? 2 : 0), width: 25, height: 25)
        view.addSubview(hamburger)
        view.addSubview(hamburgerPlace)
        
        hamburgerPlace.addTapGesture {
            self.generator.impactOccurred()
            let alert = UIAlertController(title: "Close".localized(code), message: "Вы уверены что хотите завершить карту установки?".localized(code), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                self.generator.impactOccurred()
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                          style: .destructive,
                                          handler: {(_: UIAlertAction!) in
                                            self.generator.impactOccurred()
                                            self.closeMap()
            }))
            self.present(alert, animated: true, completion: nil)

        }
//---соты картинка
 // -- Status bar
        view.addSubview(progresViewAll)
        view.addSubview(statusBarRedOne)
        view.addSubview(statusBarRedTwo)
//        a = a + Int(screenWidth-CGFloat(x*2)-CGFloat(5*countStatus))/countStatus + 5
        view.addSubview(statusBarRedThree)
        view.addSubview(statusBarRedFour)
        view.addSubview(statusBarRedFive)
        view.addSubview(statusBarRedSix)
        
        view.addSubview(mapHelp)
        view.addSubview(viewRedLines)
        view.addSubview(mapHelpTwo)
        view.addSubview(viewGrayLines)
        view.addSubview(viewGrayLinesSecond)
        view.addSubview(mapHelpThree)
        view.addSubview(mapHelpLabel)
        view.addSubview(mapHelpButton)
        clickButtonNext()
//---Second View
        //MARK: ФИО запись в перменную
        
        let FioData = UserDefaults.standard.string(forKey: "FioMap")
        if let FioDataString = FioData {
            setupMapTextField.text = FioDataString
        } else {
            setupMapTextField.text = ""
        }
        view.addSubview(setupMapTextField)

        let ZakazData = UserDefaults.standard.string(forKey: "ZakazMap")
        if let ZakazDataString = ZakazData {
            setupMapTextFieldSecond.text = ZakazDataString
        } else {
            setupMapTextFieldSecond.text = ""
        }
        
        let modelTcTextData = UserDefaults.standard.string(forKey: "modelTcTextMap")
        if let modelTcTextDataString = modelTcTextData {
            modelTcText = modelTcTextDataString
        } else {
            modelTcText = ""
        }
        
        let numberTcTextData = UserDefaults.standard.string(forKey: "numberTcTextMap")
        if let numberTcTextDataString = numberTcTextData {
            numberTcText = numberTcTextDataString
        } else {
            numberTcText = ""
        }
        
        let modelTrackTextData = UserDefaults.standard.string(forKey: "modelTrackTextMap")
        if let modelTrackTextDataString = modelTrackTextData {
            modelTrackText = modelTrackTextDataString
        } else {
            modelTrackText = ""
        }
        
        let plombaTrackTextData = UserDefaults.standard.string(forKey: "plombaTrackTextMap")
        if let plombaTrackTextDataString = plombaTrackTextData {
            plombaTrackText = plombaTrackTextDataString
        } else {
            plombaTrackText = ""
        }
        
        let infoTrackTextData = UserDefaults.standard.string(forKey: "infoTrackTextMap")
        if let infoTrackTextDataString = infoTrackTextData {
            infoTrackText = infoTrackTextDataString
        } else {
            infoTrackText = ""
        }
        
        view.addSubview(setupMapTextFieldSecond)
        view.addSubview(setupMapText)
        view.addSubview(referenceImageFIO)
        view.addSubview(referenceImageZakaz)
        view.addSubview(setupMapTextSecond)
        view.addSubview(successGreen)
        view.addSubview(successGreenSecond)
        view.addSubview(setupMapTextSuccess)
        tableView.isHidden = true
        tableViewOneMore.isHidden = true
        tableViewTrack.isHidden = true
        tableViewLvlTop.isHidden = true

        tableView.endEditing(true)
        tableViewTrack.endEditing(true)
        tableViewOneMore.endEditing(true)
        view.addSubview(searchModelTrack)
        view.addSubview(SupportTell)

//        view.addSubview(PhotoAll)
        PhotoAll.addTapGesture {
//            self.imagePicker.present(from: self.themeBackView3)

        }
        photoALLModel.removeAll()
        photoALLNumber.removeAll()
        photoALLTrack.removeAll()
        photoALLPlomba.removeAll()
        photoALLPlace.removeAll()
        
        photoALLPlombaFirstTrack.removeAll()
        photoALLPlombaSecondTrack.removeAll()
        photoALLPlaceSetTrack.removeAll()
        
        photoALLNumberDutLabel.removeAll()
        photoALLNumberDutLabel.append("")
        photoALLNumberDutLabel.append("")
        photoALLNumberDutLabel.append("")
        photoALLNumberDutLabel.append("")

        DutTrackLabel.removeAll()
        DutTrackLabel.append("")
        DutTrackLabel.append("")
        DutTrackLabel.append("")
        DutTrackLabel.append("")
        
        photoALLPlombaFirstTrackLabel.removeAll()
        photoALLPlombaFirstTrackLabel.append("")
        photoALLPlombaFirstTrackLabel.append("")
        photoALLPlombaFirstTrackLabel.append("")
        photoALLPlombaFirstTrackLabel.append("")
        
        photoALLPlombaSecondTrackLabel.removeAll()
        photoALLPlombaSecondTrackLabel.append("")
        photoALLPlombaSecondTrackLabel.append("")
        photoALLPlombaSecondTrackLabel.append("")
        photoALLPlombaSecondTrackLabel.append("")
        
        photoALLPlaceSetTrackLabel.removeAll()
        photoALLPlaceSetTrackLabel.append("")
        photoALLPlaceSetTrackLabel.append("")
        photoALLPlaceSetTrackLabel.append("")
        photoALLPlaceSetTrackLabel.append("")
        
        photoALLPlaceChech = nil
        photoALLMore.removeAll()
        
        photoALLModel.append(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"))
        photoALLNumber.append(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"))
        photoALLTrack.append(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"))
        photoALLPlomba.append(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"))
        photoALLPlace.append(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"))
        photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaFirstTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        
        photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlombaSecondTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        
        photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLPlaceSetTrack.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        
        photoALLMore.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLMore.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLMore.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])
        photoALLMore.append([isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")])

        let imgData = UserDefaults.standard.data(forKey: "photoALLModel_1")
        let imgData2 = UserDefaults.standard.data(forKey: "photoALLModel_2")

        if imgData != nil {
            photoALLModel.append(UIImage(data: imgData!)!)
        }
        if imgData2 != nil {
            photoALLModel.append(UIImage(data: imgData2!)!)
        }
        
        let imgDataN = UserDefaults.standard.data(forKey: "photoALLNumber_1")
        let imgDataN2 = UserDefaults.standard.data(forKey: "photoALLNumber_2")
        
        if imgDataN != nil {
            photoALLNumber.append(UIImage(data: imgDataN!)!)
        }
        if imgDataN2 != nil {
            photoALLNumber.append(UIImage(data: imgDataN2!)!)
        }
        
        let imgDataModelTrack = UserDefaults.standard.data(forKey: "photoALLTrack_1")
        let imgDataModelTrack2 = UserDefaults.standard.data(forKey: "photoALLTrack_2")
        
        if imgDataModelTrack != nil {
            photoALLTrack.append(UIImage(data: imgDataModelTrack!)!)
        }
        if imgDataModelTrack2 != nil {
            photoALLTrack.append(UIImage(data: imgDataModelTrack2!)!)
        }
        
        let imgDataPlomba = UserDefaults.standard.data(forKey: "photoALLPlomba_1")
        let imgDataPlomba2 = UserDefaults.standard.data(forKey: "photoALLPlomba_2")
        
        if imgDataPlomba != nil {
            photoALLPlomba.append(UIImage(data: imgDataPlomba!)!)
        }
        if imgDataPlomba2 != nil {
            photoALLPlomba.append(UIImage(data: imgDataPlomba2!)!)
        }
        let imgDataPlace = UserDefaults.standard.data(forKey: "photoALLPlace_1")
        let imgDataPlace2 = UserDefaults.standard.data(forKey: "photoALLPlace_2")
        let imgDataPlace3 = UserDefaults.standard.data(forKey: "photoALLPlace_3")
        let imgDataPlace4 = UserDefaults.standard.data(forKey: "photoALLPlace_4")

        if imgDataPlace != nil {
            photoALLPlace.append(UIImage(data: imgDataPlace!)!)
            photoALLPlaceChech = photoALLPlace[1]
        }
        if imgDataPlace2 != nil {
            photoALLPlace.append(UIImage(data: imgDataPlace2!)!)
        }
        if imgDataPlace3 != nil {
            photoALLPlace.append(UIImage(data: imgDataPlace3!)!)
        }
        if imgDataPlace4 != nil {
            photoALLPlace.append(UIImage(data: imgDataPlace4!)!)
        }
        
        let imgDataPlombaDUT1 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_10")
        let imgDataPlombaDUT12 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_20")
        let imgDataPlombaDUT2 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_11")
        let imgDataPlombaDUT22 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_21")
        let imgDataPlombaDUT3 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_12")
        let imgDataPlombaDUT32 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_22")
        let imgDataPlombaDUT4 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_13")
        let imgDataPlombaDUT42 = UserDefaults.standard.data(forKey: "photoALLPlombaDUT_23")
        
        if imgDataPlombaDUT1 != nil {
            photoALLPlombaFirstTrack[0].append(UIImage(data: imgDataPlombaDUT1!)!)
        }
        if imgDataPlombaDUT12 != nil {
            photoALLPlombaFirstTrack[0].append(UIImage(data: imgDataPlombaDUT12!)!)
        }
        if imgDataPlombaDUT2 != nil {
            photoALLPlombaFirstTrack[1].append(UIImage(data: imgDataPlombaDUT2!)!)
        }
        if imgDataPlombaDUT22 != nil {
            photoALLPlombaFirstTrack[1].append(UIImage(data: imgDataPlombaDUT22!)!)
        }
        if imgDataPlombaDUT3 != nil {
            photoALLPlombaFirstTrack[2].append(UIImage(data: imgDataPlombaDUT3!)!)
        }
        if imgDataPlombaDUT32 != nil {
            photoALLPlombaFirstTrack[2].append(UIImage(data: imgDataPlombaDUT32!)!)
        }
        if imgDataPlombaDUT4 != nil {
            photoALLPlombaFirstTrack[3].append(UIImage(data: imgDataPlombaDUT4!)!)
        }
        if imgDataPlombaDUT42 != nil {
            photoALLPlombaFirstTrack[3].append(UIImage(data: imgDataPlombaDUT42!)!)
        }
        
        let imgDataPlomba2DUT1 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_10")
        let imgDataPlomba2DUT12 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_20")
        let imgDataPlomba2DUT2 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_11")
        let imgDataPlomba2DUT22 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_21")
        let imgDataPlomba2DUT3 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_12")
        let imgDataPlomba2DUT32 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_22")
        let imgDataPlomba2DUT4 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_13")
        let imgDataPlomba2DUT42 = UserDefaults.standard.data(forKey: "photoALLPlomba2DUT_23")
        
        if imgDataPlomba2DUT1 != nil {
            photoALLPlombaSecondTrack[0].append(UIImage(data: imgDataPlomba2DUT1!)!)
        }
        if imgDataPlomba2DUT12 != nil {
            photoALLPlombaSecondTrack[0].append(UIImage(data: imgDataPlomba2DUT12!)!)
        }
        if imgDataPlomba2DUT2 != nil {
            photoALLPlombaSecondTrack[1].append(UIImage(data: imgDataPlomba2DUT2!)!)
        }
        if imgDataPlomba2DUT22 != nil {
            photoALLPlombaSecondTrack[1].append(UIImage(data: imgDataPlomba2DUT22!)!)
        }
        if imgDataPlomba2DUT3 != nil {
            photoALLPlombaSecondTrack[2].append(UIImage(data: imgDataPlomba2DUT3!)!)
        }
        if imgDataPlomba2DUT32 != nil {
            photoALLPlombaSecondTrack[2].append(UIImage(data: imgDataPlomba2DUT32!)!)
        }
        if imgDataPlomba2DUT4 != nil {
            photoALLPlombaSecondTrack[3].append(UIImage(data: imgDataPlomba2DUT4!)!)
        }
        if imgDataPlomba2DUT42 != nil {
            photoALLPlombaSecondTrack[3].append(UIImage(data: imgDataPlomba2DUT42!)!)
        }
        
        let imgDataSetDUT1 = UserDefaults.standard.data(forKey: "photoALLSetDUT_10")
        let imgDataSetDUT12 = UserDefaults.standard.data(forKey: "photoALLSetDUT_20")
        let imgDataSetDUT2 = UserDefaults.standard.data(forKey: "photoALLSetDUT_11")
        let imgDataSetDUT22 = UserDefaults.standard.data(forKey: "photoALLSetDUT_21")
        let imgDataSetDUT3 = UserDefaults.standard.data(forKey: "photoALLSetDUT_12")
        let imgDataSetDUT32 = UserDefaults.standard.data(forKey: "photoALLSetDUT_22")
        let imgDataSetDUT4 = UserDefaults.standard.data(forKey: "photoALLSetDUT_13")
        let imgDataSetDUT42 = UserDefaults.standard.data(forKey: "photoALLSetDUT_23")
        
        if imgDataSetDUT1 != nil {
            photoALLPlaceSetTrack[0].append(UIImage(data: imgDataSetDUT1!)!)
        }
        if imgDataSetDUT12 != nil {
            photoALLPlaceSetTrack[0].append(UIImage(data: imgDataSetDUT12!)!)
        }
        if imgDataSetDUT2 != nil {
            photoALLPlaceSetTrack[1].append(UIImage(data: imgDataSetDUT2!)!)
        }
        if imgDataSetDUT22 != nil {
            photoALLPlaceSetTrack[1].append(UIImage(data: imgDataSetDUT22!)!)
        }
        if imgDataSetDUT3 != nil {
            photoALLPlaceSetTrack[2].append(UIImage(data: imgDataSetDUT3!)!)
        }
        if imgDataSetDUT32 != nil {
            photoALLPlaceSetTrack[2].append(UIImage(data: imgDataSetDUT32!)!)
        }
        if imgDataSetDUT4 != nil {
            photoALLPlaceSetTrack[3].append(UIImage(data: imgDataSetDUT4!)!)
        }
        if imgDataSetDUT42 != nil {
            photoALLPlaceSetTrack[3].append(UIImage(data: imgDataSetDUT42!)!)
        }
        
        let DutNameTextData = UserDefaults.standard.string(forKey: "DUT_0")
        if let DutNameTextDataString = DutNameTextData {
            photoALLNumberDutLabel[0] = DutNameTextDataString
        } else {
            photoALLNumberDutLabel[0] = ""
        }
        let DutNameTextData1 = UserDefaults.standard.string(forKey: "DUT_1")
        if let DutNameTextDataString1 = DutNameTextData1 {
            photoALLNumberDutLabel[1] = DutNameTextDataString1
        } else {
            photoALLNumberDutLabel[1] = ""
        }
        let DutNameTextData2 = UserDefaults.standard.string(forKey: "DUT_2")
        if let DutNameTextDataString2 = DutNameTextData2 {
            photoALLNumberDutLabel[2] = DutNameTextDataString2
        } else {
            photoALLNumberDutLabel[2] = ""
        }
        let DutNameTextData3 = UserDefaults.standard.string(forKey: "DUT_3")
        if let DutNameTextDataString3 = DutNameTextData3 {
            photoALLNumberDutLabel[3] = DutNameTextDataString3
        } else {
            photoALLNumberDutLabel[3] = ""
        }
        
        let DutTrackLabelTextData = UserDefaults.standard.string(forKey: "DUTMain_0")
        if let DutTrackLabelTextDataString = DutTrackLabelTextData {
            DutTrackLabel[0] = DutTrackLabelTextDataString
        } else {
            DutTrackLabel[0] = "ТД - Онлайн"
        }
        let DutTrackLabelTextData1 = UserDefaults.standard.string(forKey: "DUTMain_1")
        if let DutTrackLabelTextDataString1 = DutTrackLabelTextData1 {
            DutTrackLabel[1] = DutTrackLabelTextDataString1
        } else {
            DutTrackLabel[1] = "ТД - Онлайн"
        }
        let DutTrackLabelTextData2 = UserDefaults.standard.string(forKey: "DUTMain_2")
        if let DutTrackLabelTextDataString2 = DutTrackLabelTextData2 {
            DutTrackLabel[2] = DutTrackLabelTextDataString2
        } else {
            DutTrackLabel[2] = "ТД - Онлайн"
        }
        let DutTrackLabelTextData3 = UserDefaults.standard.string(forKey: "DUTMain_3")
        if let DutTrackLabelTextDataString3 = DutTrackLabelTextData3 {
            DutTrackLabel[3] = DutTrackLabelTextDataString3
        } else {
            DutTrackLabel[3] = "ТД - Онлайн"
        }
        
        let DutPlombaTextData = UserDefaults.standard.string(forKey: "DUTP_0")
        if let DutPlombaTextDataString = DutPlombaTextData {
            photoALLPlombaFirstTrackLabel[0] = DutPlombaTextDataString
        } else {
            photoALLPlombaFirstTrackLabel[0] = ""
        }
        let DutPlombaTextData1 = UserDefaults.standard.string(forKey: "DUTP_1")
        if let DutPlombaTextDataString1 = DutPlombaTextData1 {
            photoALLPlombaFirstTrackLabel[1] = DutPlombaTextDataString1
        } else {
            photoALLPlombaFirstTrackLabel[1] = ""
        }
        let DutPlombaTextData2 = UserDefaults.standard.string(forKey: "DUTP_2")
        if let DutPlombaTextDataString2 = DutPlombaTextData2 {
            photoALLPlombaFirstTrackLabel[2] = DutPlombaTextDataString2
        } else {
            photoALLPlombaFirstTrackLabel[2] = ""
        }
        let DutPlombaTextData3 = UserDefaults.standard.string(forKey: "DUTP_3")
        if let DutPlombaTextDataString3 = DutPlombaTextData3 {
            photoALLPlombaFirstTrackLabel[3] = DutPlombaTextDataString3
        } else {
            photoALLPlombaFirstTrackLabel[3] = ""
        }
        
        let DutPlomba2TextData = UserDefaults.standard.string(forKey: "DUTP2_0")
        if let DutPlomba2TextDataString = DutPlomba2TextData {
            photoALLPlombaSecondTrackLabel[0] = DutPlomba2TextDataString
        } else {
            photoALLPlombaSecondTrackLabel[0] = ""
        }
        let DutPlomba2TextData2 = UserDefaults.standard.string(forKey: "DUTP2_1")
        if let DutPlomba2TextDataString2 = DutPlomba2TextData2 {
            photoALLPlombaSecondTrackLabel[1] = DutPlomba2TextDataString2
        } else {
            photoALLPlombaSecondTrackLabel[1] = ""
        }
        let DutPlomba2TextData3 = UserDefaults.standard.string(forKey: "DUTP2_2")
        if let DutPlomba2TextDataString3 = DutPlomba2TextData3 {
            photoALLPlombaSecondTrackLabel[2] = DutPlomba2TextDataString3
        } else {
            photoALLPlombaSecondTrackLabel[2] = ""
        }
        let DutPlomba2TextData4 = UserDefaults.standard.string(forKey: "DUTP2_3")
        if let DutPlomba2TextDataString4 = DutPlomba2TextData4 {
            photoALLPlombaSecondTrackLabel[3] = DutPlomba2TextDataString4
        } else {
            photoALLPlombaSecondTrackLabel[3] = ""
        }
        
        let DutDopTextData = UserDefaults.standard.string(forKey: "DUTDop_0")
        if let DutDopTextDataString = DutDopTextData {
            photoALLPlaceSetTrackLabel[0] = DutDopTextDataString
        } else {
            photoALLPlaceSetTrackLabel[0] = ""
        }
        let DutDopTextData2 = UserDefaults.standard.string(forKey: "DUTDop_1")
        if let DutDopTextDataString2 = DutDopTextData2 {
            photoALLPlaceSetTrackLabel[1] = DutDopTextDataString2
        } else {
            photoALLPlaceSetTrackLabel[1] = ""
        }
        let DutDopTextData3 = UserDefaults.standard.string(forKey: "DUTDop_2")
        if let DutDopTextDataString3 = DutDopTextData3 {
            photoALLPlaceSetTrackLabel[2] = DutDopTextDataString3
        } else {
            photoALLPlaceSetTrackLabel[2] = ""
        }
        let DutDopTextData4 = UserDefaults.standard.string(forKey: "DUTDop_3")
        if let DutDopTextDataString4 = DutDopTextData4 {
            photoALLPlaceSetTrackLabel[3] = DutDopTextDataString4
        } else {
            photoALLPlaceSetTrackLabel[3] = ""
        }
        
        let countDuts = UserDefaults.standard.integer(forKey: "countDuts")
        if countDuts != 0 {
            numberOfRowLvlTopPreLast = countDuts
        } else {
            numberOfRowLvlTopPreLast = 1
        }
        
        deleteKeyboard() // --- Delete Keyboard
    }
    
    func deleteKeyboard() {
        tableView.addTapGesture {
             self.tableView.endEditing(true)
         }
        tableViewOneMore.addTapGesture {
             self.tableViewOneMore.endEditing(true)
         }
        tableViewTrack.addTapGesture {
             self.tableViewTrack.endEditing(true)
         }
    }
    
    func referenceTapFIO() {
        referenceImageFIO.addTapGesture {
            referenceMapInfo = """
            В этом поле требуется указать ФИО непосредственного исполнительного монтажа ( то есть ваше ).
            
            Пример: Щеглов Василий Николаевич.
            """
            referenceMapMain = "ФИО исполнителя:"
            self.showReferenceFunc()
        }
    }
    func referenceTapZakaz() {
        referenceImageZakaz.addTapGesture {
            referenceMapInfo = """
            В этом поле требуется указать юридическую форму и название компании заказчика монтажа.
            
            Пример: ЗАО Гибрид.
            """
            referenceMapMain = "Заказчик:"
            self.showReferenceFunc()
        }
    }
    fileprivate func showReferenceFunc() {
        self.generator.impactOccurred()
        let viewController = ReferenceController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    
    fileprivate func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")
        self.tableView.register(MapCellNumberTC.self, forCellReuseIdentifier: "MapCellNumberTC")
        
        self.tableViewOneMore.dataSource = self
        self.tableViewOneMore.delegate = self
        self.tableViewOneMore.register(MapCellOneMore.self, forCellReuseIdentifier: "MapCellOneMore")
        self.tableViewOneMore.register(MapCellOneMoreAdd.self, forCellReuseIdentifier: "MapCellOneMoreAdd")
        
        self.tableViewTrack.dataSource = self
        self.tableViewTrack.delegate = self
        self.tableViewTrack.register(MapTrackZeroCell.self, forCellReuseIdentifier: "MapTrackZeroCell")
        self.tableViewTrack.register(MapTrackOneCell.self, forCellReuseIdentifier: "MapTrackOneCell")
        self.tableViewTrack.register(MapTrackTwoCell.self, forCellReuseIdentifier: "MapTrackTwoCell")
        self.tableViewTrack.register(MapTrackThreeCell.self, forCellReuseIdentifier: "MapTrackThreeCell")
        self.tableViewTrack.register(MapTrackFourCell.self, forCellReuseIdentifier: "MapTrackFourCell")
        self.tableViewTrack.register(MapTrackFiveCell.self, forCellReuseIdentifier: "MapTrackFiveCell")
        
        self.tableViewLvlTop.dataSource = self
        self.tableViewLvlTop.delegate = self
        self.tableViewLvlTop.register(MapLvlTopOneCell.self, forCellReuseIdentifier: "MapLvlTopOneCell")
        self.tableViewLvlTop.register(MapLvlTopTwoCell.self, forCellReuseIdentifier: "MapLvlTopTwoCell")
    }

}

