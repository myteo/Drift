//
//  Int+Random.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation

extension Int {
    static func random(_ max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
