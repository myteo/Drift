//
//  Laser.swift
//  Drift
//
//  Created by Leon on 13/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Laser: GKEntity {
    
    init(entityManager: EntityManager) {
        
        super.init()
        
        let texture = SKTexture(imageNamed: Projectiles.Laser.Name)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}