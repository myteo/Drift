//
//  GameServiceManager.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

enum GameServiceMessageType {
    case Position
    case Direction
}

struct GameServiceMessage {
    
    let messageType: GameServiceMessageType
    let message: Any
    
}

protocol GameServiceManagerDelegate: class {
    
    func connecting(to peerID: MCPeerID)
    
    func connected(to peerID: MCPeerID)
    
    func disconnected(from peerID: MCPeerID)
    
    func positionChanged(for peerID: MCPeerID, to position: CGPoint)
    // func directionChanged(for peerID: MCPeerID, to direction: )
    
}

class GameServiceManager: GameService {
    
    fileprivate weak var delegate: GameServiceManagerDelegate?
    private lazy var multipeerService: MultipeerService = {
        let multipeerService = MultipeerServiceManager()
        multipeerService.set(sessionDelegate: self)
        return multipeerService
    }()
    
    func update(position: CGPoint) {
        
        let data = Data.init(from: position)
        multipeerService.send(data: data, mode: .unreliable)
    }
    
    /*
    func update(direction: CGPoint) {
        
        multipeerService.send(data: <#T##Data#>, mode: .unreliable)
    }
     */
    
}

extension GameServiceManager: SessionDelegate {
    
    // Might want to extract the first 3 into a parent class to inherit these..
    func connecting(to peerID: MCPeerID) {
        delegate?.connected(to: peerID)
    }
    
    func connected(to peerID: MCPeerID) {
        delegate?.connected(to: peerID)
    }
    
    func disconnected(from peerID: MCPeerID) {
        delegate?.disconnected(from: peerID)
    }
    
    func received(data: Data, from peer: MCPeerID) {
        let position = data.to(type: CGPoint.self)
        delegate?.positionChanged(for: peer, to: position)
    }
}
