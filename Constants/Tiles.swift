//
//  Tiles.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit

struct Tiles {
    static let Columns = 48
    static let Rows = 48
    static let Width = CGFloat(100)
    static let Height = CGFloat(50)
    static let Size = CGSize(width: Width, height: Height)
    struct Water {
    }
    struct Grass {
        static let TileName = "Grass"
        static let Friction = CGFloat(0.4)
    }
    struct Road {
        static let TileName = "Road"
        static let Friction = CGFloat(0.1)
    }

}
