//
//  CGVector.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

public extension CGVector {
    public init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    public init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }

    static func * (left: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * scalar, dy: left.dy * scalar)
    }

    static func *= (left: inout CGVector, scalar: CGFloat) {
        left = left * scalar
    }

    static func *= (left: inout CGVector, scalar: Double) {
        left *= CGFloat(scalar)
    }

    var reversed: CGVector {
        return CGVector(dx: self.dx * -1, dy: self.dy * -1)
    }

    var magnitude: CGFloat {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    
}
