//
//  CGFloat+Operations.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit

extension CGFloat {
    static public func += (left: inout CGFloat, right: Int) {
        left = left + CGFloat(right)
    }

    static public func * (left: CGFloat, right: CGVector) -> CGVector {
        return CGVector(dx: left * right.dx, dy: left * right.dy)
    }

    static let π = CGFloat.pi
    static let π_2 = CGFloat(M_PI_2)
    static let π_4 = CGFloat(M_PI_4)

    func getVector() -> CGVector {
        return CGVector(dx: cos(self + CGFloat.π_2), dy: sin(self + CGFloat.π_2))
    }

    func toRadian() -> CGFloat {
        return CGFloat(Double(self) / 180.0 * M_PI)
    }
}
