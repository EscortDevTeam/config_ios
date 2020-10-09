//
//  GrafficsDaysCell.swift
//  Escort
//
//  Created by Володя Зверев on 30.07.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject, AxisValueFormatter {
    
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    fileprivate var referenceTimeInterval2: [String]?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter, referenceTimeInterval2: [String]) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
        self.referenceTimeInterval2 = referenceTimeInterval2
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print("\(String(describing: referenceTimeInterval2)), \(value)")
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        
        else {
            return ""
        }
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
        
        if value < 0 {
            return ""
        } else {
            return ""
        }
    }

}
