//
//  PlayerRacer.swift
//  Drift
//
//  Created by Alex on 12/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerRacer: GKEntity {

    init(spriteNode: SKSpriteNode, entityManager: EntityManager) {

        super.init()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let moveComponent = MoveComponent(type: .PlayerRacer,
                                          node: spriteNode,
                                          entityManager: entityManager)
        addComponent(moveComponent)
        
        let firingComponent = FiringComponent(entityManager: entityManager)
        addComponent(firingComponent)
    }
    
    func fireWeapon() {
        guard let firingComponent = self.component(ofType: FiringComponent.self) else{
            return
        }
        firingComponent.fireVehicleLaser()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
