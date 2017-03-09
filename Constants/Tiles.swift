//
//  Tiles.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit

struct Tiles {
    static let Columns = 42
    static let Rows = 42
    static let Width = CGFloat(100)
    static let Height = CGFloat(50)
    static let Size = CGSize(width: Width, height: Height)
    struct Water {
        static let NodeNames = ["Water"]
    }
    struct Grass {
        static let NodeNames = ["Grass1", "Grass2"]
        static let Friction = CGFloat(0.4)
    }
    struct Road {
        static let NodeNames = ["RoadNorthBack1", "RoadEastFront1", "RoadNorth1", "RoadEast1", "RoadNorthBack2", "RoadEastFront2", "RoadNorth2", "RoadEast2", "RoadNorthBack3", "RoadEastFront3", "RoadNorth3", "RoadEast3", "RoadTurn1", "RoadTurn2", "RoadTurn3", "RoadTurn4", "RoadTurn5", "RoadTurn6"]
        static let Friction = CGFloat(0.1)
    }
    
    
}
