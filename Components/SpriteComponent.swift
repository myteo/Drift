//
//  SpriteComponent.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let node: SKSpriteNode

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture,
                            color: SKColor.white,
                            size: size)
        node.entity = entity
        super.init()
    }

    init(entity: GKEntity, spriteNode: SKSpriteNode) {
        node = spriteNode
        node.entity = entity
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func removeAndRespawn() {
        let parentNode = node.parent
        node.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() +
            5.0, execute: {
                parentNode?.addChild(self.node)
        })
    }
}
