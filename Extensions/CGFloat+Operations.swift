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

    static public func / (left: CGFloat, right: Int) -> CGFloat {
        return CGFloat(Double(left) / Double(right))
    }
}
