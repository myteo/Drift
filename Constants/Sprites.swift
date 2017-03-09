//
//  Sprites.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

struct Sprites {
    static let AcceleratorName = "Accelerator"
    static let BrakeName = "Brakepad"
    static let AntiClockwiseName = "AntiClockwise"
    static let ClockwiseName = "Clockwise"
    
    struct Car {
        struct Colors {
            static let Blue = "carBlue3_"
            static let Black = "carBlack2_"
        }
        static let Mass = CGFloat(3)
    }
    
    struct StartLane {
        static let First = CGPoint(x: -500, y: -6)
        static let Second = CGPoint(x: -450, y: -16)
        static let Thrid = CGPoint(x: -400, y: -40)
    }
}
