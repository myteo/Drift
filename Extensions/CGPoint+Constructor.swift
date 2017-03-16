//
//  CGPoint+Constructor.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit

extension CGPoint {
    init(_ point: float2) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }

    var magnitudeSquared: CGFloat {
        return self.x * self.x + self.y * self.y
    }
}
