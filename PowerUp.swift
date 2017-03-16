//
//  PowerUp.swift
//  Drift
//
//  Created by Teo Ming Yi on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PowerUp: GKEntity, ContactNotifiableType {

    private let entityManager: EntityManager

    init(spriteNode: SKSpriteNode, entityManager: EntityManager) {

        self.entityManager = entityManager

        super.init()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func contactWithEntityDidBegin(_ entity: GKEntity) {
        if let playerRacer = entity as? PlayerRacer,
            let playerRacerSprite = playerRacer.component(ofType: SpriteComponent.self),
            let vehicleSprite = playerRacerSprite.node as? VehicleSprite {
            vehicleSprite.physicsBody?.velocity *= 2.0
        }
        // remove power up
        guard let spriteComponent = self.component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.node.removeFromParent()
        entityManager.remove(self)
    }
}
