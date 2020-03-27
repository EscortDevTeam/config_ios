//
//  MapCell.swift
//  Escort
//
//  Created by Володя Зверев on 27.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

let slideshow = ImageSlideshow()

class MapCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var imagePicker: ImagePicker!
    let slideshow = ImageSlideshow()

    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    weak var setupMapTableTextField: UITextField!
    weak var imageviewTC: UIImageView!

    weak var separetor: UIView!
    weak var titleRSSI: UILabel!
    weak var referenceImage: UIImageView!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.frame = CGRect(x: 40, y: 90, width: screenWidth-80, height: 70)
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
        if photoALLModel.count == 3 {
            photoALLModel.removeFirst()
        }
        return photoALLModel.count
    }
    func setUpDataSource() {
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapColectionCell", for: indexPath) as! MapColectionCell
        cell.layer.cornerRadius = 5
        cell.imageAdd.image = photoALLModel[indexPath.row]
        if photoALLModel[indexPath.row] == UIImage(named: "Group 29-2") || photoALLModel[indexPath.row] == UIImage(named: "Group 29-2N") {
            cell.imageDelete.isHidden = true
        } else {
            cell.imageDelete.isHidden = false
        }
        cell.imageDelete.addTapGesture {
            photoALLModel.remove(at: indexPath.row)
            if photoALLModel.first != UIImage(named: "Group 29-2") && photoALLModel.first != UIImage(named: "Group 29-2N") {
                UserDefaults.standard.removeObject(forKey: "photoALLModel_\(indexPath.row + 1)")
                photoALLModel.insert(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"), at: 0)
            } else {
                UserDefaults.standard.removeObject(forKey: "photoALLModel_1")
                UserDefaults.standard.removeObject(forKey: "photoALLModel_2")
            }
            self.collectionView.reloadData()
        }
        cell.addTapGesture {
            if indexPath.row == 0 {
                if (photoALLModel.first == UIImage(named: "Group 29-2") || photoALLModel.first == UIImage(named: "Group 29-2N")) && photoALLModel.count < 3 {
                    print("indexPath.row: \(indexPath.row)")
                    var config = YPImagePickerConfiguration()
                    config.library.onlySquare = true
                    let picker = YPImagePicker(configuration: config)
                    picker.didFinishPicking { [unowned picker] items, _ in
                        if let photo = items.singlePhoto {
                            print(photo.fromCamera) // Image source (camera or library)
                            print(photo.image) // Final image selected by the user
                            print(photo.originalImage) // original image selected by the user, unfiltered
                            //                         print(photo.modifiedImage) // Transformed image, can be nil
                            //                         print(photo.exifMeta) // Print exif meta data of original image.
                            if let imageData = photo.image.jpeg(.lowest) {
                                photoALLModel.append(UIImage(data: imageData)!)
                                UserDefaults.standard.set(imageData, forKey: "photoALLModel_\(photoALLModel.count-1)")
                            }
                        }
                        picker.dismiss(animated: true, completion: nil)
                        self.collectionView.reloadData()
                    }
                    self.window?.rootViewController?.present(picker, animated: true, completion: nil)
                } else {
                    if photoALLModel.count == 2 {
                        self.slideshow.setImageInputs([
                            ImageSource(image: photoALLModel[0]),
                            ImageSource(image: photoALLModel[1])
                        ])
                    }
                    self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
                    
                }
            } else if indexPath.row == 1 {
                if photoALLModel.count == 2 && photoALLModel.first == UIImage(named: "Group 29-2") || photoALLModel.first == UIImage(named: "Group 29-2N"){
                    self.slideshow.setImageInputs([
                        ImageSource(image: photoALLModel[1])
                    ])
                } else if photoALLModel.count == 2 && (photoALLModel.first != UIImage(named: "Group 29-2") && photoALLModel.first != UIImage(named: "Group 29-2N")) {
                    self.slideshow.setImageInputs([
                        ImageSource(image: photoALLModel[1]),
                        ImageSource(image: photoALLModel[0])
                    ])
                }
                
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            }
        }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(75), height: CGFloat(60))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func registerCell() {
        collectionView.register(MapColectionCell.self, forCellWithReuseIdentifier: "MapColectionCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        registerCell()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 160))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList
        
        let setupMapTableTextField = UITextField()
        setupMapTableTextField.backgroundColor = .clear
        setupMapTableTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: setupMapTableTextField.frame.height))
        setupMapTableTextField.leftViewMode = .always
        setupMapTableTextField.attributedPlaceholder = NSAttributedString(string: "Volvo", attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        setupMapTableTextField.frame = CGRect(x: 35, y: 40, width: screenWidth / 1.4, height: 46)
        setupMapTableTextField.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        setupMapTableTextField.addTarget(self, action: #selector(self.textFieldDidChangeFirst(_:)),for: UIControl.Event.editingChanged)
        self.contentView.addSubview(setupMapTableTextField)
        self.setupMapTableTextField = setupMapTableTextField

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth/2, height: 20)
        titleLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let separetor = UIView()
        separetor.frame = CGRect(x: 40, y: 75, width: screenWidth/1.4, height: 2)
        separetor.backgroundColor = isNight ? UIColor(rgb: 0x414141): UIColor(rgb: 0xCBCBCB)
        separetor.layer.cornerRadius = 1
        self.contentView.addSubview(separetor)
        self.separetor = separetor
        
        let imageviewTC = UIImageView()
        imageviewTC.frame = CGRect(x: 40, y: 90, width: 80, height: 60)
        imageviewTC.image = isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")
        //        self.contentView.addSubview(imageviewTC)
        self.imageviewTC = imageviewTC
        
        let referenceImage = UIImageView()
        referenceImage.frame = CGRect(x: 40, y: 23, width: 23, height: 23)
        referenceImage.center.x = screenWidth/2.8 + (iphone5s ? 20 : 0)
        referenceImage.image = isNight ? #imageLiteral(resourceName: "справка черная") : #imageLiteral(resourceName: "справка белая")
        self.contentView.addSubview(referenceImage)
        self.referenceImage = referenceImage

        
//        let collectionView = UICollectionView()
//        collectionView.frame = CGRect(x: 40, y: 90, width: screenWidth-80, height: 60)
//        self.contentView.addSubview(collectionView)
//        self.collectionView = collectionView
        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
////        tableView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .yellow
        self.contentView.addSubview(collectionView)
////        tableView.backgroundColor = .clear
//
//        self.collectionView = collectionView

//        self.contentView.addSubview(titleLabel)
//        self.titleLabel = titleLabel
//
//        let levelLabel = UILabel(frame: .zero)
//        levelLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(levelLabel)
//        self.levelLabel = levelLabel

        NSLayoutConstraint.activate([
//            self.contentView.topAnchor.constraint(equalTo: self.collectionView.topAnchor),
//            self.contentView.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
//            self.contentView.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor),
//            self.contentView.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor),
//
//            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor, constant: screenWidth/3.2),
//            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
//            self.contentView.centerXAnchor.constraint(equalTo: self.btnConnet.centerXAnchor, constant: screenWidth/2),
//            self.contentView.centerYAnchor.constraint(equalTo: self.btnConnet.centerYAnchor),
            
//            self.contentView.centerXAnchor.constraint(equalTo: self.levelLabel.centerXAnchor, constant: -screenWidth/4),
//            self.contentView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor),
        ])
        setupTheme()

    }
    @objc func textFieldDidChangeFirst(_ textField: UITextField) {
        print(textField.text!)
        modelTcText = textField.text!
        UserDefaults.standard.set(modelTcText, forKey: "modelTcTextMap")
        
        checkMaxLength(textField: textField, maxLength: 30)
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
//        titleRSSI.theme.textColor = themed { $0.navigationTintColor }
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            setupMapTableTextField.theme.textColor = themed { $0.navigationTintColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            setupMapTableTextField.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        }
    }
}

