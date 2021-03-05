//
//  MetricKitFunctional.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import MetricKit
@available(iOS 13.0, *)
class MetricsManager:NSObject{
    override init() {
        print("metric")
        super.init()
        MXMetricManager.shared.add(self)
    }
    deinit {
        MXMetricManager.shared.remove(self)
    }
}
@available(iOS 13.0, *)
extension MetricsManager:MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        //Save to disk
        print("metric")
        //Send to server for processing
    }
}
