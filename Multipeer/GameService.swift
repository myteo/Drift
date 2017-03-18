//
//  GameService.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import UIKit

protocol GameService {

    func set(delegate: GameServiceManagerDelegate)

    func update(position: CGPoint, rotation: CGFloat)
}
