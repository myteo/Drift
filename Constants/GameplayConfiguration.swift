//
//  MovementConstants.swift
//  Drift
//
//  Created by Alex on 13/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

struct GameplayConfiguration {

    struct VehiclePhysics {
        static let maxSpeed: CGFloat = 2500
        static let mass: CGFloat = 0.05
    }

    // player agent isn't designed to move. however,
    // mass is required for agent to have a position
    struct PlayerRacer {
        static let agentMaxSpeed: Float = 0
        static let agentMaxAcceleration: Float = 0
        static let agentMass: Float = 0.1
    }

    struct AIRacer {
        static let agentMaxSpeed: Float = 300
        static let agentMaxAcceleration: Float = 170
        static let agentMass: Float = 0.6

        static let avoidAgentPredictionTime: TimeInterval = 10
        static let avoidAgentWeight: Float = 1.5

        static let separationDistance: Float = 100
        static let separationAngle: Float = 1.5 * Float.pi

        static let obstacleBufferRadius: Float = 10
        static let pathRadius: Float = 20

        static let stayOnPathWeight: Float = 1.0
        static let stayOnPathPredictionTime: TimeInterval = 1

        static let followPathWeight: Float = 1.0
        static let followPathPredictionTime: TimeInterval = 1

        static let avoidObstaclesWeight: Float = 2.0
        static let avoidObstaclesPredictionTime: TimeInterval = 1
    }

    struct SpeedBoost {
        static let speedBoostDuration: Double = 5.0
        static let maxSpeedBoost: CGFloat = 2.0
        static let currentSpeedBoost: CGFloat = 2.0
    }

    struct SpeedReduction {
        static let speedReductionDuration: Double = 5.0
        static let maxSpeedReduction: CGFloat = 2.0
        static let currentSpeedReduction: CGFloat = 2.0

    }
}
