//
//  Sprites.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

struct Sprites {
    static let alphaPressed = CGFloat(0.5)
    static let alphaUnpressed = CGFloat(0.75)

    struct Names {
        static let accelerator = "Accelerator"
        static let brake = "Brake"
        static let antiClockwise = "AntiClockwise"
        static let clockwise = "Clockwise"
        static let item = "ItemSprite"
        static let status = "PlayerStatusSprite"
        static let display = "PowerUpDisplay"
        static let steering = "SteeringSprite"
    }

    struct Car {
        struct Colors {
            static let blue = "car_blue_"
            static let black = "car_black_"
        }
        static let mass = CGFloat(21)
    }

    struct Trees {
        static let Names = ["tree_large", "tree_small"]
    }
}
