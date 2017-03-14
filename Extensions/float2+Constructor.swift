//
//  float2+Constructor.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit

extension float2 {
    init(_ point: CGPoint) {
        self.init(x: Float(point.x), y: Float(point.y))
    }
}
