//
//  AIProjectileMoveBehavior.swift
//  Drift
//
//  Created by Alex on 16/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit
import SpriteKit

class AIProjectileMoveBehavior: GKBehavior {

    init(targetSpeed: Float, seek: GKAgent, obstaclesToAvoid: [SKNode]) {
        super.init()

        addSpeedGoal(speed: targetSpeed)
        addSeekGoal(target: seek)
    }

    private func addSpeedGoal(speed: Float) {
        setWeight(1, for: GKGoal(toReachTargetSpeed: speed))
    }

    private func addSeekGoal(target: GKAgent) {
        setWeight(1, for: GKGoal(toSeekAgent: target))
    }

}
