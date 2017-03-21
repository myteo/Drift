//
//  Trap.swift
//  Drift
//
//  Created by Teo Ming Yi on 21/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Trap: GKEntity, ContactNotifiableType {

    init(spriteNode: SKSpriteNode) {

        super.init()

        let spriteComponent = SpriteComponent(entity: self,
                                          spriteNode: spriteNode)
        addComponent(spriteComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ContactNotifiableType
    func contactWithEntityDidBegin(_ entity: GKEntity, at scene: SKScene) {
        assert(entity is AIRacer || entity is PlayerRacer)

        guard let spriteComponent = self.component(ofType: SpriteComponent.self)?.node as? TrapSprite else {
                return
        }
        spriteComponent.removeSprite()

        /// Add powerComponent to entity if it does not already have a PowerUpComponent
        guard let vehicleSprite = entity.component(ofType: SpriteComponent.self)?.node as? VehicleSprite else {
            return
        }
        vehicleSprite.reduceSpeedToNormal()
    }

}
