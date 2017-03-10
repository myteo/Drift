//
//  GameServiceManagerDelegate.swift
//  Drift
//
//  Created by Edmund Mok on 10/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol GameServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: GameServiceManager, connectedDevices: [String])
    
    // Temp using position and direction updates, another way would be to encapsulate it
    // into a class / struct of position + direction
    func positionChanged(for peerID: MCPeerID, to position: CGPoint, manager: GameServiceManager)
    func directionChanged(for peerID: MCPeerID, to direction: Direction, manager: GameServiceManager)
    
}
