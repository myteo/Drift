//
//  RaceEndedState.swift
//  Drift
//
//  Created by Alex on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class RaceEndedState: GKState {

    unowned let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

    }
}
