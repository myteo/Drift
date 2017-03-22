//
//  FinishedLapState.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

class FinishedLapState: GKState, OnCrossedFinishLine {
    // TODO: check the total number of laps here, tell world about victory or smth, somehow

    func justCrossedStartOfFinishLine() {}
    func justCrossedEndOfFinishLine() {}
}
