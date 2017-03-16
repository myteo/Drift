//
//  Colliders.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation

struct ColliderType {
    static let Vehicles: UInt32 = 1 << 0
    static let Obstacles: UInt32 = 1 << 1
    static let PowerUp: UInt32 = 1 << 2
}
