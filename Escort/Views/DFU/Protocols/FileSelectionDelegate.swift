//
//  File.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation

@objc protocol FileSelectionDelegate {
    func onFileSelected(withURL aFileURL : URL)
}
