//
//  Double+Operations.swift
//  Drift
//
//  Created by Leon on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation

extension Double {
    func toDegree() -> Double {
        return self / M_PI * 180.0
    }

    func getEulerAngleRad() -> Double {
        let angle = self.truncatingRemainder(dividingBy: M_PI)
        return abs(self) > M_PI ? self > 0 ? -M_PI + angle : M_PI + angle : self
    }
}
