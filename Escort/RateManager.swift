//
//  RateManager.swift
//  Escort
//
//  Created by Володя Зверев on 29.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import StoreKit

class RateManager {
    
    class func incrementCount() {
        let count = UserDefaults.standard.integer(forKey: "run_count")
        if count < 2 {
            UserDefaults.standard.set(count + 1, forKey: "run_count")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func showRatesController() {
        let count = UserDefaults.standard.integer(forKey: "run_count")
        print(count)
        if count == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                SKStoreReviewController.requestReview()
            })
        }
    }
}
