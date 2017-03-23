//
//  InRaceLapState.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

class InRaceLapState: GKState, OnCrossedFinishLine {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is CrossedStartOfFinishLineState.Type, 
            is CheatingState.Type:
            return true
        default:
            return false
        }
    }

    func justCrossedStartOfFinishLine() {
        stateMachine?.enter(CrossedStartOfFinishLineState.self)
    }

    func justCrossedEndOfFinishLine() {
        stateMachine?.enter(CheatingState.self)
    }
}
