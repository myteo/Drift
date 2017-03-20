//
//  ContactNotifiableType.swift
//  Drift
//
//  Created by Teo Ming Yi on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

protocol ContactNotifiableType {

    func contactWithEntityDidBegin(_ entity: GKEntity, at scene: SKScene)
}
