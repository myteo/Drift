//
//  Direction.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import Foundation

enum SpinDirection: String {
    case Clockwise, AntiClockwise
    static let degree = CGFloat(M_PI / 180)
    static let degreeLimit = 6 * degree
    static let degreeTiltLimit = 36 * degree
    static let radianLimit = Double(degreeLimit.toRadian())
}

enum Direction: Int {
    case N = 0, NE, E, SE, S, SW, W, NW

    // Assets use 27 degrees even though 30 is used if true 2:1 ratio
    static let radianOffset = CGFloat(27 * M_PI / 180)
    static let xOffset = cos(radianOffset)
    static let yOffset = sin(radianOffset)

    var name: String {
        switch self {
        case .N: return "N"
        case .NE: return "NE"
        case .E: return "E"
        case .SE: return "SE"
        case .S: return "S"
        case .SW: return "SW"
        case .W: return "W"
        case .NW: return "NW"
        }
    }

    var vector: CGVector {
        switch self {
        case .N: return CGVector(dx: 0, dy: 1)
        case .S: return CGVector(dx: 0, dy: -1)
        case .E: return CGVector(dx: 1, dy: 0)
        case .W: return CGVector(dx: -1, dy: 0)
        case .NW: return CGVector(dx: -Direction.xOffset, dy: Direction.yOffset)
        case .NE: return CGVector(dx: Direction.xOffset, dy: Direction.yOffset)
        case .SW: return CGVector(dx: -Direction.xOffset, dy: -Direction.yOffset)
        case .SE: return CGVector(dx: Direction.xOffset, dy: -Direction.yOffset)
        }
    }

    // Angle in radians, using atan2
    var angle: CGFloat {
        switch self {
        case .N: return CGFloat.π / 2
        case .S: return -CGFloat.π / 2
        case .E: return 0
        case .W: return CGFloat.π
        case .NE: return CGFloat(Direction.radianOffset)
        case .SE: return -CGFloat(Direction.radianOffset)
        case .NW: return CGFloat.π - (Direction.radianOffset)
        case .SW: return -CGFloat.π + (Direction.radianOffset)
        }
    }

    // Path for polygon physics body
    var path: CGPath {
        var path: CGPath
        switch self {
        case .NE: path = CGPath.from(points: [[-16, -4], [3, 8], [16, 1], [-2, -11]])
        case .E: path = CGPath.from(points: [[-16, 3], [15, 3], [15, -7], [-16, -7]])
        case .N: path = CGPath.from(points: [[-6, 11], [6, 11], [6, -10], [-6, -10]])
        case .S: path = CGPath.from(points: [[-7, 9], [6, 9], [6, -9], [-6, -9]])
        case .W: path = CGPath.from(points: [[-16, 3], [14, 3], [14, -6], [-16, -6]])
        case .NW: path = CGPath.from(points: [[-17, 0], [-5, 8], [16, -3], [4, -9]])
        case .SW: path = CGPath.from(points: [[-16, -5], [2, 7], [14, 1], [-4, -11]])
        case .SE: path = CGPath.from(points: [[-16, 0], [-3, 9], [16, -4], [5, -12]])
        }
        return path
    }

    var list: [Direction] {
        return [.N, .NE, .E, .SE, .S, .SW, .W, .NW]
    }

    mutating func turnClockwise() {
        let nextIndex = self.rawValue + 1
        let index = nextIndex % list.count
        self = list[index]
    }

    mutating func turnAntiClockwise() {
        let nextIndex = self.rawValue - 1
        let index = nextIndex % list.count < 0 ? list.count - 1 : nextIndex
        self = list[index]
    }

    public static func getNextDirection(_ prev: CGPoint, _ next: CGPoint) -> Direction {
        let angle = Double(atan2(next.y - prev.y, next.x - prev.x) * 180) / M_PI
        switch angle {
        case 15.0 ..< 60: return .NE
        case 60 ..< 120: return .N
        case 120 ..< 165: return .NW
        case 165 ..< 180: return .W
        case -180 ..< -165: return .W
        case -165 ..< -120: return .SW
        case -120 ..< -60: return .S
        case -60 ..< -15.0: return .SE
        case -15.0 ..< 15.0: return .E
        default: return .NE
        }
    }
}
