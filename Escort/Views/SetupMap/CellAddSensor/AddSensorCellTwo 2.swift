//
//  AddSensorCellTwo.swift
//  Escort
//
//  Created by Володя Зверев on 12.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

class AddSensorCellTwo: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    weak var setupMapTableTextField: UITextField!
    weak var separetor: UIView!
    weak var separetorOne: UIView!
    weak var imageViewSt: UIImageView!
    var slideshow = ImageSlideshow()
    weak var button: dropDownBtn!
    
    weak var imagePicker: ImagePicker!
    weak var viewMainListThree: UIView!
    weak var titleLabelThree: UILabel!
    weak var photoLabel: UILabel!
    weak var setupMapTableTextFieldThree: UITextField!
    weak var imageviewTC: UIImageView!
    weak var referenceImage: UIImageView!
    weak var referenceImage2: UIImageView!

    weak var separetorThree: UIView!
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.frame = CGRect(x: 40, y: 220, width: screenWidth-80, height: 70)
        cv.backgroundColor = .clear
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoALLPlombaFirstTrack[openSensorNumber-1].count == 3 {
            photoALLPlombaFirstTrack[openSensorNumber-1].removeFirst()
        }
        return photoALLPlombaFirstTrack[openSensorNumber-1].count
    }
    func setUpDataSource() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapColectionCell", for: indexPath) as! MapColectionCell
        print("1 index : \(indexPath.row)")
        cell.layer.cornerRadius = 5
//        let a = photoALLPlombaFirstTrack[0]
        cell.imageAdd.image = photoALLPlombaFirstTrack[openSensorNumber-1][indexPath.row]
        if photoALLPlombaFirstTrack[openSensorNumber-1][indexPath.row] == UIImage(named: "Group 29-2") || photoALLPlombaFirstTrack[openSensorNumber-1][indexPath.row] == UIImage(named: "Group 29-2N") {
            cell.imageDelete.isHidden = true
        } else {
            cell.imageDelete.isHidden = false
        }
        cell.imageDelete.addTapGesture {
            photoALLPlombaFirstTrack[openSensorNumber-1].remove(at: indexPath.row)
             if photoALLPlombaFirstTrack[openSensorNumber-1].first != UIImage(named: "Group 29-2") && photoALLPlombaFirstTrack[openSensorNumber-1].first != UIImage(named: "Group 29-2N") {
                 UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_\(indexPath.row + 1)\(openSensorNumber-1)")
                photoALLPlombaFirstTrack[openSensorNumber-1].insert(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"), at: 0)
             } else {
                 UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_1\(openSensorNumber-1)")
                 UserDefaults.standard.removeObject(forKey: "photoALLPlombaDUT_2\(openSensorNumber-1)")
             }
            self.collectionView.reloadData()
        }
        cell.addTapGesture {
            if indexPath.row == 0 {
                if (photoALLPlombaFirstTrack[openSensorNumber-1].first == UIImage(named: "Group 29-2") || photoALLPlombaFirstTrack[openSensorNumber-1].first == UIImage(named: "Group 29-2N")) && photoALLPlombaFirstTrack[openSensorNumber-1].count < 3 {
                    print("indexPath.row: \(indexPath.row)")
                    let picker = YPImagePicker()
                    picker.didFinishPicking { [unowned picker] items, _ in
                        if let photo = items.singlePhoto {
                            colectionNumber = 2
                            print(photo.fromCamera) // Image source (camera or library)
                            print(photo.image) // Final image selected by the user
                            print(photo.originalImage) // original image selected by the user, unfiltered
                            //                         print(photo.modifiedImage) // Transformed image, can be nil
                            //                         print(photo.exifMeta) // Print exif meta data of original image.
                            if let imageData = photo.image.jpeg(.lowest) {
                                photoALLPlombaFirstTrack[openSensorNumber-1].append(UIImage(data: imageData)!)
                                UserDefaults.standard.set(imageData, forKey: "photoALLPlombaDUT_\(photoALLPlombaFirstTrack[openSensorNumber-1].count-1)\(openSensorNumber-1)")

                            }
                        }
                        picker.dismiss(animated: true, completion: nil)
                        self.collectionView.reloadData()
                    }
                    self.window?.rootViewController?.present(picker, animated: true, completion: nil)
                } else {
                    if photoALLPlombaFirstTrack[openSensorNumber-1].count == 2 {
                        self.slideshow.setImageInputs([
                            ImageSource(image: photoALLPlombaFirstTrack[openSensorNumber-1][0]),
                            ImageSource(image: photoALLPlombaFirstTrack[openSensorNumber-1][1])
                        ])
                    }
                    self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
                    
                }
            } else if indexPath.row == 1 {
                if photoALLPlombaFirstTrack[openSensorNumber-1].count == 2  && (photoALLPlombaFirstTrack[openSensorNumber-1].first == UIImage(named: "Group 29-2") || photoALLPlombaFirstTrack[openSensorNumber-1].first == UIImage(named: "Group 29-2N")) {
                    self.slideshow.setImageInputs([
                        ImageSource(image: photoALLPlombaFirstTrack[openSensorNumber-1][1])
                    ])
                } else if photoALLPlombaFirstTrack[openSensorNumber-1].count == 2 && (photoALLPlombaFirstTrack[openSensorNumber-1].first != UIImage(named: "Group 29-2") && photoALLPlombaFirstTrack[openSensorNumber-1].first != UIImage(named: "Group 29-2N")) {
                    self.slideshow.setImageInputs([
                        ImageSource(image: photoALLPlombaFirstTrack[openSensorNumber-1][1]),
                        ImageSource(image: photoALLPlombaFirstTrack[openSensorNumber-1][0])
                    ])
                }
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            }
        }
        return cell
        
    }
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       //        let cellHeight = (collectionView.bounds.size.height - 30) / 3
       //        let cellWidth = (collectionView.bounds.size.width - 20) / 4
               return CGSize(width: CGFloat(75), height: CGFloat(60))
           }
           
           override func awakeFromNib() {
               super.awakeFromNib()
               // Initialization code
           }
           func registerCell() {
               collectionView.register(MapColectionCell.self, forCellWithReuseIdentifier: "MapColectionCell")
       //        collectionView.register(MapColectionCell.self, forCellWithReuseIdentifier: "MapColectionCell")
           }
           
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {

        registerCell()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 80))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList
        
        let viewMainListThree = UIView(frame: CGRect(x: 30, y: 110, width: screenWidth-60, height: 190))
        viewMainListThree.layer.shadowRadius = 3.0
        viewMainListThree.layer.shadowOpacity = 0.2
        viewMainListThree.layer.cornerRadius = 5
        viewMainListThree.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainListThree)
        self.viewMainListThree = viewMainListThree
        
        let setupMapTableTextField = UITextField()
        setupMapTableTextField.backgroundColor = .clear
        setupMapTableTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: setupMapTableTextField.frame.height))
        setupMapTableTextField.leftViewMode = .always
        setupMapTableTextField.keyboardType = .numberPad
        setupMapTableTextField.attributedPlaceholder = NSAttributedString(string: "№ 234965", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTableTextField.frame = CGRect(x: screenWidth/2, y: 40, width: screenWidth / 3 - 30, height: 46)
        setupMapTableTextField.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
//        if addORopen == false {
            setupMapTableTextField.text = "\(photoALLNumberDutLabel[numberSelectSensor])"
//        }
        self.contentView.addSubview(setupMapTableTextField)
        self.setupMapTableTextField = setupMapTableTextField
        self.setupMapTableTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),for: UIControl.Event.editingChanged)

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth/2, height: 20)
        titleLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        
        let separetor = UIView()
        separetor.frame = CGRect(x: screenWidth/2, y: 75, width: screenWidth/3 - 30, height: 2)
        separetor.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        separetor.layer.cornerRadius = 1
        self.contentView.addSubview(separetor)
        self.separetor = separetor
        
        let setupMapTableTextFieldThree = UITextField()
        setupMapTableTextFieldThree.backgroundColor = .clear
        setupMapTableTextFieldThree.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: setupMapTableTextFieldThree.frame.height))
        setupMapTableTextFieldThree.leftViewMode = .always
        setupMapTableTextFieldThree.keyboardType = .numberPad
        setupMapTableTextFieldThree.attributedPlaceholder = NSAttributedString(string: "123456789", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTableTextFieldThree.frame = CGRect(x: 35, y: 140, width: screenWidth / 1.4, height: 46)
        setupMapTableTextFieldThree.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        setupMapTableTextFieldThree.addTarget(self, action: #selector(textFieldDidChangeTwo(_:)),for: UIControl.Event.editingChanged)
        setupMapTableTextFieldThree.text = "\(photoALLPlombaFirstTrackLabel[numberSelectSensor])"
        self.contentView.addSubview(setupMapTableTextFieldThree)
        self.setupMapTableTextFieldThree = setupMapTableTextFieldThree
        
        let titleLabelThree = UILabel()
        titleLabelThree.frame = CGRect(x: 40, y: 125, width: screenWidth/2, height: 20)
        titleLabelThree.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        self.contentView.addSubview(titleLabelThree)
        self.titleLabelThree = titleLabelThree
        
        let photoLabel = UILabel()
        photoLabel.frame = CGRect(x: 40, y: 190, width: screenWidth/2, height: 20)
        photoLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        self.contentView.addSubview(photoLabel)
        self.photoLabel = photoLabel
        
        let separetorThree = UIView()
        separetorThree.frame = CGRect(x: 40, y: 175, width: screenWidth/1.4, height: 2)
        separetorThree.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        separetorThree.layer.cornerRadius = 1
        self.contentView.addSubview(separetorThree)
        self.separetorThree = separetorThree
        
        let imageviewTC = UIImageView()
        imageviewTC.frame = CGRect(x: 40, y: 190, width: 80, height: 60)
        imageviewTC.image = isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")
        self.imageviewTC = imageviewTC

        self.contentView.addSubview(collectionView)
        let referenceImage = UIImageView()
        referenceImage.frame = CGRect(x: screenWidth/2 + screenWidth/3 - 20, y: 50, width: 23, height: 23)
        referenceImage.image = isNight ? #imageLiteral(resourceName: "справка черная") : #imageLiteral(resourceName: "справка белая")
        self.contentView.addSubview(referenceImage)
        self.referenceImage = referenceImage
        
        let referenceImage2 = UIImageView()
        referenceImage2.frame = CGRect(x: 120, y: 123, width: 23, height: 23)
        referenceImage2.center.x = 145
        referenceImage2.image = isNight ? #imageLiteral(resourceName: "справка черная") : #imageLiteral(resourceName: "справка белая")
        self.contentView.addSubview(referenceImage2)
        self.referenceImage2 = referenceImage2
        
        let button = dropDownBtn.init(frame: CGRect(x: 40, y: 50, width: screenWidth/3, height: 30))
        button.setTitle(DutTrackLabel[openSensorNumber-1], for: .normal)
        button.setTitleColor(isNight ? UIColor(rgb: 0xFFFFFF) :  UIColor(rgb: 0x1F2222), for: .normal)
        button.dropView.dropDownOptions = ["ТД - 100", "ТД - 150", "ТД - 500", "ТД - 600", "ТД - Онлайн", "ТД - BLE"]
        self.contentView.addSubview(button)
        self.button = button
        
        let separetorOne = UIView()
        separetorOne.frame = CGRect(x: 50, y: 75, width: screenWidth/3 - 10, height: 2)
        separetorOne.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        separetorOne.layer.cornerRadius = 1
        self.contentView.addSubview(separetorOne)
        self.separetorOne = separetorOne
        
        let imageViewSt = UIImageView()
        imageViewSt.frame = CGRect(x: screenWidth/3 + 30, y: 60, width: 15, height: 8)
        imageViewSt.image = #imageLiteral(resourceName: "Vector-14")
        self.contentView.addSubview(imageViewSt)
        self.imageviewTC = imageViewSt

        setupTheme()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let string = textField.text {
                photoALLNumberDutLabel[numberSelectSensor] = string
                UserDefaults.standard.set(photoALLNumberDutLabel[numberSelectSensor], forKey: "DUT_\(numberSelectSensor)")
        }
        checkMaxLength(textField: textField, maxLength: 6)
    }
    @objc func textFieldDidChangeTwo(_ textField: UITextField) {
        if let string = textField.text {
            photoALLPlombaFirstTrackLabel[numberSelectSensor] = string
            UserDefaults.standard.set(photoALLPlombaFirstTrackLabel[numberSelectSensor], forKey: "DUTP_\(numberSelectSensor)")

        }
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
            
            titleLabelThree.theme.textColor = themed { $0.navigationTintColor }
            viewMainListThree.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            setupMapTableTextFieldThree.theme.textColor = themed { $0.navigationTintColor }
            photoLabel.theme.textColor = themed { $0.navigationTintColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            setupMapTableTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            photoLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            setupMapTableTextFieldThree.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainListThree.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            titleLabelThree.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}

