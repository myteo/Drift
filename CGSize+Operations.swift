//
//  CGSize+Operations.swift
//  Drift
//
//  Created by Teo Ming Yi on 23/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    static func / (left: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: left.width / scalar, height: left.height / scalar)
    }

    static func /= (left: inout CGSize, scalar: CGFloat) {
        left = left / scalar
    }

    static func * (left: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: left.width * scalar, height: left.height * scalar)
    }

    static func *= (left: inout CGSize, scalar: CGFloat) {
        left = left * scalar
    }
}
