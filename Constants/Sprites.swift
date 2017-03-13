//
//  Sprites.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

struct Sprites {
    struct Names {
        static let Accelerator = "Accelerator"
        static let Brake = "Brakepad"
        static let AntiClockwise = "AntiClockwise"
        static let Clockwise = "Clockwise"
        static let Weapon = "Weapon"
    }
    
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
    
    struct Trees {
        static let Names = ["treeTall", "treeShort", "treeConiferTall", "treeTall_autumn", "treeShort_autumn", "treeConiferShort"]
    }
}
