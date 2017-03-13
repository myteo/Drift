//
//  MoveComponentType.swift
//  Drift
//
//  Created by Alex on 12/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

enum AgentMoveType {
    case AIRacer, PlayerRacer
    
    var maxSpeed: Float {
        switch self {
        case .AIRacer: return GameplayConfiguration.AIRacer.agentMaxSpeed
        case .PlayerRacer: return GameplayConfiguration.PlayerRacer.agentMaxSpeed
        }
    }
    
    var maxAcceleration: Float {
        switch self {
        case .AIRacer: return GameplayConfiguration.AIRacer.agentMaxAcceleration
        case .PlayerRacer: return GameplayConfiguration.PlayerRacer.agentMaxAcceleration
        }
    }
    
    var mass: Float {
        switch self {
        case .AIRacer: return GameplayConfiguration.AIRacer.agentMass
        case .PlayerRacer: return GameplayConfiguration.PlayerRacer.agentMass
        }
    }
}
