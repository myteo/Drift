//
//  CGPath+Constructor.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

extension CGPath {
    static func from(points: [[Int]]) -> CGPath? {
        var CGPoints = points.map { CGPoint(x: $0[0], y: $0[1]) }
//        let sprite = SKSpriteNode(imageNamed: imageNamed)
//        let offsetX = CGFloat(sprite.frame.size.width * sprite.anchorPoint.x)
//        let offsetY = CGFloat(sprite.frame.size.height * sprite.anchorPoint.y)
        let path = CGMutablePath()
        guard points.count > 1 else {
            return nil
        }
        path.move(to: CGPoints.first!)
        for i in 1..<CGPoints.count {
            let point = CGPoints[i]
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}
