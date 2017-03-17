//
//  MultipeerServiceManager.swift
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

    func searchForPlayers()

    func isConnected() -> Bool

    func getConnectedPeers() -> [MCPeerID]

    func stopSearchingForPlayers()

    func set(sessionDelegate: SessionDelegate)

    // Sends the given data to all connected peers.
    func send(data: Data, mode: MCSessionSendDataMode)

}

class MultipeerServiceManager: NSObject, MultipeerService {

    private let session = Session()
    private lazy var advertiser: Advertiser = {
        return Advertiser(session: self.session.session)
    }()

    private lazy var browser: Browser = {
        return Browser(session: self.session.session)
    }()

    func searchForPlayers() {
        advertiser.startAdvertising()
        browser.startBrowsing()
    }

    func isConnected() -> Bool {
        return session.isConnected()
    }

    func getConnectedPeers() -> [MCPeerID] {
        return session.getConnectedPeers()
    }

    func stopSearchingForPlayers() {
        advertiser.stopAdvertising()
        browser.stopBrowsing()
    }

    func set(sessionDelegate: SessionDelegate) {
        session.sessionDelegate = sessionDelegate
    }

    func send(data: Data, mode: MCSessionSendDataMode) {
        session.send(data: data, mode: mode)
    }
}
