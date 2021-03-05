//
//  DuCollectionCell.swift
//  Escort
//
//  Created by Володя Зверев on 19.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class DuCollectionCell: UITableViewCell {
    
    var collectionView : UICollectionView?
    var content: UIView!
    var viewModel: ViewModelDevice = ViewModelDevice()
    var delegate : SettingsDUDelegate?
    
    var ArrayModeImage: [UIImage]?
    var ArrayModeImageBlack: [UIImage]?
    var ArrayMode: [String]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor.black.cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 10
        self.contentView.addSubview(content)
        self.content = content
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        cv.delegate = self
        cv.dataSource = self
        cv.flashScrollIndicators()
        cv.indicatorStyle = isNight ? .white : .black
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        self.content.addSubview(cv)
        self.collectionView = cv
        
        self.ArrayModeImage = [#imageLiteral(resourceName: "транспорт") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "ковш"), #imageLiteral(resourceName: "отвал")]
        self.ArrayModeImageBlack = [#imageLiteral(resourceName: "транспорт-black") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла-black") , #imageLiteral(resourceName: "ковш-black"), #imageLiteral(resourceName: "Отвал-black")]
        self.ArrayMode = ["Transportation".localized(code),"Horizontal rotation control".localized(code),"Vertical rotation control".localized(code),"Angle control".localized(code),"Bucket".localized(code),"Plow".localized(code)]
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.content!.bottomAnchor.constraint(equalTo: self.collectionView!.bottomAnchor, constant: 25),

            self.collectionView!.heightAnchor.constraint(equalToConstant: 200),
            self.collectionView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            self.collectionView!.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -5),
            self.collectionView!.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 5),

            self.collectionView!.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 15),

//            self.imageUI!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
//            self.imageUI!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            self.imageUI!.heightAnchor.constraint(equalToConstant: 72),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 72),
//            self.imageUI!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        setupTheme()
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            contentView.theme.backgroundColor = themed { $0.backgroundColor }
            content.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        } else {
            contentView.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            content.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        }
    }
    
    @objc func actionSet() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
extension DuCollectionCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("collectionView.frame.width/2.5 : \(collectionView.frame.width/2.5)...\(collectionView.frame.width/2)")
        return CGSize(width: 170, height: 210)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.backgroundColor = .clear
        cell.viewLabel.text = ArrayMode?[indexPath.row]
        cell.viewImage.image = isNight ? ArrayModeImage?[indexPath.row] : ArrayModeImageBlack?[indexPath.row]
        if indexPath.row == 1 {
            cell.lotView.isHidden = false
            cell.lotViewVer.isHidden = true
            cell.viewImage.isHidden = true
        } else if indexPath.row == 2 {
            cell.lotView.isHidden = true
            cell.lotViewVer.isHidden = false
            cell.viewImage.isHidden = true
        } else {
            cell.lotView.isHidden = true
            cell.lotViewVer.isHidden = true
            cell.viewImage.isHidden = false
        }
        cell.lotView.play()
        cell.lotViewVer.play()

        print(")00230")
        cell.addTapGesture {
            self.didSelect(indexPath: indexPath)
        }
//            if actualMode != indexPath.row {
//                self.activityIndicator.startAnimating()
//                self.viewAlpha.addSubview(self.activityIndicator)
//                self.view.addSubview(self.viewAlpha)
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                self.view.isUserInteractionEnabled = false
//                print("indexPath.rowCell: \(indexPath.row)")
//                if indexPath.row == 0 {
//                    modeLabel = "0"
//                }
//                if indexPath.row == 1 {
//                    modeLabel = "5"
//                }
//                if indexPath.row == 2 {
//                    modeLabel = "4"
//                }
//                if indexPath.row == 3 {
//                    modeLabel = "6"
//                }
//                if indexPath.row == 4 {
//                    modeLabel = "9"
//                }
//                if indexPath.row == 5 {
//                    modeLabel = "10"
//                }
//                reload = 21
//                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//                    self.view.isUserInteractionEnabled = true
//                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                    self.viewAlpha.removeFromSuperview()
//                    if checkMode == true {
//                        actualMode = indexPath.row
//                        self.showToast(message: "Mode is set successfully".localized(code), seconds: 2.0)
//                        collectionView.reloadData()
//                        checkMode = false
//                        self.TextFieldH.text = valH
//                        self.TextFieldL.text = valL
//                        self.TextFieldValOtH.text = valH
//                        self.TextFieldOtL.text = valL
//                        self.TextFieldOtZV.text = zaderV
//                        self.TextFieldOtZVi.text = zaderVi
//                        self.TextFieldDelta.text = valL
//                        self.TextFieldVkl.text = zaderV
//                        self.TextFieldVikl.text = zaderVi
//                    } else {
//                        self.showToast(message: "Mode setting failure. Try again".localized(code), seconds: 2.0)
//                    }
//                }
//            }
        //        }
        if viewModel.detectDuModeInt(intMode: modeLabel) == indexPath.row {
            cell.viewLine.isHidden = false
            cell.viewLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        } else {
            cell.viewLine.isHidden = true
            cell.viewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.item == 0 {
            actualMode = 0
            delegate?.buttonSetMode()
        } else if indexPath.item == 1 {
            actualMode = 5
            delegate?.buttonSetMode()
        } else if indexPath.item == 2 {
            actualMode = 4
            delegate?.buttonSetMode()
        } else if indexPath.item == 3 {
            actualMode = 6
            delegate?.buttonSetMode()
        } else if indexPath.item == 4 {
            actualMode = 9
            delegate?.buttonSetMode()
        } else {
            actualMode = 10
            delegate?.buttonSetMode()
        }
    }
    func didSelect(indexPath: IndexPath) {
        if indexPath.item == 0 {
            actualMode = 0
            delegate?.buttonSetMode()
        } else if indexPath.item == 1 {
            actualMode = 5
            delegate?.buttonSetMode()
        } else if indexPath.item == 2 {
            actualMode = 4
            delegate?.buttonSetMode()
        } else if indexPath.item == 3 {
            actualMode = 6
            delegate?.buttonSetMode()
        } else if indexPath.item == 4 {
            actualMode = 9
            delegate?.buttonSetMode()
        } else {
            actualMode = 10
            delegate?.buttonSetMode()
        }
    }
}
