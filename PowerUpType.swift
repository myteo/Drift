//
//  PowerUpType.swift
//  Drift
//
//  Created by Teo Ming Yi on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit

enum PowerUpType: Int {
    case speedBoost
    case trap
    case immunity
    case frostBullet
    case homingMissile
    case globalDownSize

    static func getRandomType() -> PowerUpType {
        /*let randomNum = Int(arc4random() % 6)
        return PowerUpType(rawValue: randomNum) ?? PowerUpType.speedBoost*/
        return .trap
    }

    func getImage() -> UIImage {
        switch self {
        case .speedBoost:
            return #imageLiteral(resourceName: "speedBoost")
        case .trap:
            return #imageLiteral(resourceName: "trap")
        case .immunity:
            return #imageLiteral(resourceName: "immunity")
        case .frostBullet:
            return #imageLiteral(resourceName: "frostBullet")
        case .homingMissile:
            return #imageLiteral(resourceName: "homingMissile")
        case .globalDownSize:
            return #imageLiteral(resourceName: "globalDownsize")
        }
    }
}
