//
//  SetupMapPhoto.swift
//  Escort
//
//  Created by Володя Зверев on 27.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
var photoALLModel =  [UIImage]()
var photoALLNumber =  [UIImage]()

var photoALLTrack =  [UIImage]()
var photoALLPlomba =  [UIImage]()
var photoALLPlace =  [UIImage]()
var photoALLPlaceChech: UIImage? = nil

var photoALLPlombaFirstTrack: [[UIImage]] =  [[],[],[],[]]
var photoALLPlombaSecondTrack: [[UIImage]] =  [[],[],[],[]]
var photoALLPlaceSetTrack: [[UIImage]] =  [[],[],[],[]]

var photoALLNumberDutLabel: [String] = ["","","",""]
var photoALLPlombaFirstTrackLabel: [String] =  ["","","",""]
var DutTrackLabel: [String] =  ["","","",""]
var photoALLPlombaSecondTrackLabel: [String] =  ["","","",""]
var photoALLPlaceSetTrackLabel: [String] =  ["","","",""]


var photoALLMore: [[UIImage]] =  [[],[],[],[]]

var photoALLTC = [UIImage]()

var TCorModel = true
var colectionNumber = 0
extension SetupMap: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
            PhotoAll.image = image
            if PhotoAll.image != nil {
                if colectionNumber == 1 {
                    photoALLModel.append(PhotoAll.image!)
                } else if colectionNumber == 2 {
                    photoALLNumber.append(PhotoAll.image!)
                } else if colectionNumber == 3 {
                    photoALLTrack.append(PhotoAll.image!)
                } else if colectionNumber == 4 {
                    photoALLPlomba.append(PhotoAll.image!)
                } else if colectionNumber == 5 {
                    photoALLPlace.append(PhotoAll.image!)
                }
            }
//            self.tableView.reloadData()
    }
}
