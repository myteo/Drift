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

enum GameServiceMessageType: Int {
    case Position = 0
    case Rotation
}

struct GameServiceMessage {

    let position: CGPoint
    let rotation: CGFloat

}

protocol GameServiceManagerDelegate: class {

    func connecting(to peerID: MCPeerID)

    func connected(to peerID: MCPeerID)

    func disconnected(from peerID: MCPeerID)

    func playerChanged(for peerID: MCPeerID, to position: CGPoint, with rotation: CGFloat)

}

class GameServiceManager: GameService {

    fileprivate weak var delegate: GameServiceManagerDelegate?
    private lazy var multipeerService: MultipeerService = {
        let multipeerService = MultipeerServiceManager()
        multipeerService.set(sessionDelegate: self)
        multipeerService.searchForPeers()
        return multipeerService
    }()

    func set(delegate: GameServiceManagerDelegate) {
        self.delegate = delegate
    }

    func update(position: CGPoint, rotation: CGFloat) {

        let message = GameServiceMessage(position: position, rotation: rotation)
        let data = Data.init(from: message)
        multipeerService.send(data: data, mode: .unreliable)
    }
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

        let message = data.to(type: GameServiceMessage.self)
        self.delegate?.playerChanged(for: peer, to: message.position, with: message.rotation)
    }
}
