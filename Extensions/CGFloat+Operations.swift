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
}
