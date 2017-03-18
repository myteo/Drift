//
//  MultipeerServiceManager.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerServiceManager: NSObject, MultipeerService {

    private let session = Session()
    private lazy var advertiser: Advertiser = {
        return Advertiser(session: self.session.session)
    }()

    private lazy var browser: Browser = {
        return Browser(session: self.session.session)
    }()

    func searchForPeers() {
        advertiser.startAdvertising()
        browser.startBrowsing()
    }

    func isConnected() -> Bool {
        return session.isConnected()
    }

    func getConnectedPeers() -> [MCPeerID] {
        return session.getConnectedPeers()
    }

    func stopSearchingForPeers() {
        advertiser.stopAdvertising()
        browser.stopBrowsing()
    }

    func set(sessionDelegate: SessionDelegate) {
        session.delegate = sessionDelegate
    }

    func send(data: Data, mode: MCSessionSendDataMode) {
        session.send(data: data, mode: mode)
    }
}
