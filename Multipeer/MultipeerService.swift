//
//  MultipeerService.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// API for the multipeer service
// For now, all data is sent through messages. Maybe we can extend the wrapper to
// support streaming / resources too.
protocol MultipeerService {

    func searchForPeers()

    func isConnected() -> Bool

    func getConnectedPeers() -> [MCPeerID]

    func stopSearchingForPeers()

    func set(sessionDelegate: SessionDelegate)

    // Sends the given data to all connected peers.
    func send(data: Data, mode: MCSessionSendDataMode)

}
