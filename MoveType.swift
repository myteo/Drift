//
//  MoveComponentType.swift
//  Drift
//
//  Created by Alex on 12/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

enum MoveType {
    case AIRacer, PlayerRacer
    
    var maxSpeed: Float {
        switch self {
        case .AIRacer: return 300
        case .PlayerRacer: return 0
        }
    }
    
    var maxAcceleration: Float {
        switch self {
        case .AIRacer: return 170
        case .PlayerRacer: return 0
        }
    }
    
    // all agents need mass > 0, or they will not have a position
    var mass: Float {
        switch self {
        case .AIRacer: return 0.6
        case .PlayerRacer: return 0.1 
        }
    }
}
