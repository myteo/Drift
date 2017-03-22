//
//  FinishLine.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

// Finish line edges should come in pairs, the start & end edge.
class FinishLineEdge: GKEntity, ContactNotifiableType {
    let isStartEdge: Bool

    init(sprite: FinishLineEdgeSprite, isStartEdge: Bool) {
        self.isStartEdge = isStartEdge
        super.init()

        let spriteComponent = SpriteComponent(entity: self, spriteNode: sprite)
        addComponent(spriteComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func contactWithEntityDidBegin(_ entity: GKEntity) {
        guard let lapTracker = entity.component(ofType: LapTrackerComponent.self) else {
            return
        }

        if isStartEdge {
            lapTracker.justCrossedStartOfFinishLine()
        } else {
            lapTracker.justCrossedEndOfFinishLine()
        }
    }
}
