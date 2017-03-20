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

    struct Menu {
        static let car1Name = "menu-car1"
        static let car2Name = "menu-car2"
        static let car3Name = "menu-car3"
        static let car4Name = "menu-car4"
        static let car1Y = CGFloat(1000)
        static let car2Y = CGFloat(1400)
        static let car3Y = CGFloat(500)
        static let duration = Double(0.5)
        static let wait = Double(0.6)
    }

    struct Names {
        static let accelerator = "Accelerator"
        static let brake = "Brake"
        static let antiClockwise = "AntiClockwise"
        static let clockwise = "Clockwise"
        static let weapon = "WeaponSprite"
        static let steering = "SteeringSprite"
        static let pauseBtn = "Pause"
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
