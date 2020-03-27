//
//  MapTrackFourCell.swift
//  Escort
//
//  Created by Володя Зверев on 06.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import ImageSlideshow
import YPImagePicker

class MapTrackFourCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var imagePicker: ImagePicker!

    weak var viewMainList: UIView!
    weak var titleLabel: UILabel!
    let slideshow = ImageSlideshow()

    weak var imageviewTC: UIImageView!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.frame = CGRect(x: 40, y: 50, width: screenWidth-80, height: 70)
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
        if photoALLPlace.count == 5 {
            photoALLPlace.removeFirst()
        }
        return photoALLPlace.count
    }
    func setUpDataSource() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionPhotoPlaceCell", for: indexPath) as! MapCollectionPhotoPlaceCell
        print("1 index : \(indexPath.row)")
        cell.layer.cornerRadius = 5
        cell.imageAdd.image = photoALLPlace[indexPath.row]
        if (photoALLPlace[indexPath.row] == UIImage(named: "Group 29-2") || photoALLPlace[indexPath.row] == UIImage(named: "Group 29-2N")) || photoALLPlace[indexPath.row] == photoALLPlaceChech {
            cell.imageDelete.isHidden = true
        } else {
            cell.imageDelete.isHidden = false
        }
        cell.imageDelete.addTapGesture {
            photoALLPlace.remove(at: indexPath.row)
            if photoALLPlace.first != UIImage(named: "Group 29-2") && photoALLPlace.first != UIImage(named: "Group 29-2N") {
                UserDefaults.standard.removeObject(forKey: "photoALLPlace_\(indexPath.row + 1)")
                photoALLPlace.insert(isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2"), at: 0)
            } else {
                print("place: \(indexPath.row))")
                UserDefaults.standard.removeObject(forKey: "photoALLPlace_\(indexPath.row)")
//                UserDefaults.standard.removeObject(forKey: "photoALLPlace_3")
            }
            self.collectionView.reloadData()
        }
        cell.addTapGesture {
            if indexPath.row == 0 {
                if (photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N")) && photoALLPlace.count == 1 {
                    let picker = TabGesController()
                    picker.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController?.present(picker, animated: true)
                } else if photoALLPlace[1] == photoALLPlaceChech && photoALLPlace.count < 5 {
                    print("indexPath.row: \(indexPath.row)")
                    let picker = YPImagePicker()
                    picker.didFinishPicking { [unowned picker] items, _ in
                        if let photo = items.singlePhoto {
                            colectionNumber = 5
                            print(photo.fromCamera) // Image source (camera or library)
                            print(photo.image) // Final image selected by the user
                            print(photo.originalImage) // original image selected by the user, unfiltered
                            //                         print(photo.modifiedImage) // Transformed image, can be nil
                            //                         print(photo.exifMeta) // Print exif meta data of original image.
                            if let imageData = photo.image.jpeg(.lowest) {
                                photoALLPlace.append(UIImage(data: imageData)!)
                                UserDefaults.standard.set(imageData, forKey: "photoALLPlace_\(photoALLPlace.count-1)")
                                
                            }
                        }
                        picker.dismiss(animated: true, completion: nil)
                        self.collectionView.reloadData()
                    }
                    self.window?.rootViewController?.present(picker, animated: true, completion: nil)
                } else if photoALLPlace.first == photoALLPlaceChech {
                    let picker = TabGesController()
                    picker.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController?.present(picker, animated: true)
                }
                
            } else if (indexPath.row == 1 && photoALLPlace[1] == photoALLPlaceChech) {
                let picker = TabGesController()
                picker.modalPresentationStyle = .fullScreen
                self.window?.rootViewController?.present(picker, animated: true)
            } else if indexPath.row == 1 && photoALLPlace[1] != photoALLPlaceChech {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[1]),
                    ImageSource(image: photoALLPlace[2]),
                    ImageSource(image: photoALLPlace[3])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            } else if indexPath.row == 2 && (photoALLPlace.first != UIImage(named: "Group 29-2") && photoALLPlace.first != UIImage(named: "Group 29-2N")) {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[2]),
                    ImageSource(image: photoALLPlace[3]),
                    ImageSource(image: photoALLPlace[1])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            } else if indexPath.row == 3 && (photoALLPlace.first != UIImage(named: "Group 29-2") && photoALLPlace.first != UIImage(named: "Group 29-2N")) {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[3]),
                    ImageSource(image: photoALLPlace[1]),
                    ImageSource(image: photoALLPlace[2])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            } else if indexPath.row == 2 && photoALLPlace.count == 3 && (photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N")) {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[2])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            } else if indexPath.row == 2 && photoALLPlace.count == 4 && (photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N")) {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[2]),
                    ImageSource(image: photoALLPlace[3])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            } else if indexPath.row == 3 && photoALLPlace.count == 4 && (photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N")) {
                self.slideshow.setImageInputs([
                    ImageSource(image: photoALLPlace[3]),
                    ImageSource(image: photoALLPlace[2])
                ])
                self.slideshow.presentFullScreenController(from: (self.window?.rootViewController)! )
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: CGFloat(75), height: CGFloat(60))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func registerCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MapCollectionPhotoPlaceCell.self, forCellWithReuseIdentifier: "MapCollectionPhotoPlaceCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        registerCell()
        
        let viewMainList = UIView(frame: CGRect(x: 30, y: 10, width: screenWidth-60, height: 120))
        viewMainList.layer.shadowRadius = 3.0
        viewMainList.layer.shadowOpacity = 0.2
        viewMainList.layer.cornerRadius = 5
        viewMainList.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.contentView.addSubview(viewMainList)
        self.viewMainList = viewMainList
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 40, y: 25, width: screenWidth-80, height: 20)
        titleLabel.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        
        
        let imageviewTC = UIImageView()
        imageviewTC.frame = CGRect(x: 40, y: 90, width: 80, height: 60)
        imageviewTC.image = isNight ? #imageLiteral(resourceName: "Group 29-2N") : #imageLiteral(resourceName: "Group 29-2")
        self.imageviewTC = imageviewTC
        
        self.contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
        ])
        setupTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            titleLabel.theme.textColor = themed { $0.navigationTintColor }
            viewMainList.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        } else {
            titleLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewMainList.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        }
    }
}

