//
//  CGPoint+Operations.swift
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

    init(vectorFloat2 point: vector_float2) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }

    var magnitudeSquared: CGFloat {
        return self.x * self.x + self.y * self.y
    }

    func distance(to other: CGPoint) -> CGFloat {
        let xDist = self.x - other.x
        let yDist = self.y - other.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
