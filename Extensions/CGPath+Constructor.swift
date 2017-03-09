//
//  CGPath+Constructor.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

extension CGPath {
    static func from(points: [[Int]]) -> CGPath {
        let points = points.map { CGPoint(x: $0[0], y: $0[1]) }
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        return path
    }
}
