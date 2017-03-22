//
//  BaseLapState.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

protocol OnCrossedFinishLine {

    func justCrossedStartOfFinishLine()
    func justCrossedEndOfFinishLine()
}
