//
//  SessionDelegate.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SessionDelegate: class {

    func connecting(to peer: MCPeerID)

    func connected(to peer: MCPeerID)

    func disconnected(from peer: MCPeerID)

    func received(data: Data, from peer: MCPeerID)

}
