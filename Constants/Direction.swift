//
//  Direction.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

enum Direction: Int {
    case N = 0, NE, E, SE, S, SW, W, NW
    
    var name: String {
        get {
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
    }
    
    var vector: CGVector {
        get {
            switch self {
            case .N: return CGVector(dx: 0, dy: -1)
            case .S: return CGVector(dx: 0, dy: 1)
            case .E: return CGVector(dx: 1, dy: 0)
            case .W: return CGVector(dx: -1, dy: 0)
            case .NW: return CGVector(dx: -1, dy: -1)
            case .NE: return CGVector(dx: 1, dy: -1)
            case .SW: return CGVector(dx: -1, dy: 1)
            case .SE: return CGVector(dx: 1, dy: 1)
            }
        }
    }
    
    // Path for polygon physics body
    var path: CGPath {
        var path: CGPath
        switch self {
        case .NE: path = CGPath.from(points: [[-16,-4],[3,8],[16,1],[-2,-11]])!
        case .E: path = CGPath.from(points: [[-16,3],[15,3],[15,-7],[-16,-7]])!
        case .N: path = CGPath.from(points: [[-6,11],[6,11],[6,-10],[-6,-10]])!
        case .S: path = CGPath.from(points: [[-7,9],[6,9],[6,-9],[-6,-9]])!
        case .W: path = CGPath.from(points: [[-16,3],[14,3],[14,-6],[-16,-6]])!
        case .NW: path = CGPath.from(points: [[-17,0],[-5,8],[16,-3],[4,-9]])!
        case .SW: path = CGPath.from(points: [[-16,-5],[2,7],[14,1],[-4,-11]])!
        case .SE: path = CGPath.from(points: [[-16,0],[-3,9],[16,-4],[5,-12]])!
        }
        return path
    }
    
    var list: [Direction] {
        get { return [.N, .NE, .E, .SE, .S, .SW, .W, .NW] }
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
}
