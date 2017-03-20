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
    case slowBullet
    case homingMissile
    case globalDownSize

    static func getRandomType() -> PowerUpType {
        let randomNum = Int(arc4random() % 6)
        return PowerUpType(rawValue: randomNum) ?? PowerUpType.speedBoost
    }

    func getImage() -> UIImage {
        switch self {
        case .speedBoost:
            return #imageLiteral(resourceName: "speedBoost")
        case .trap:
            return #imageLiteral(resourceName: "trap")
        case .immunity:
            return #imageLiteral(resourceName: "immunity")
        case .slowBullet:
            return #imageLiteral(resourceName: "bulletBlueSilver_outline")
        case .homingMissile:
            return #imageLiteral(resourceName: "bulletRedSilver_outline")
        case .globalDownSize:
            return #imageLiteral(resourceName: "barrel_blue")
        }
    }
}
