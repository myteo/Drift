//
//  MoveBehavior.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, avoid: [GKAgent]) {
        super.init()
        if targetSpeed > 0 {
            setWeight(0.5, for: GKGoal(toWander: Float(25)))
            setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
            setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        }
    }
}

