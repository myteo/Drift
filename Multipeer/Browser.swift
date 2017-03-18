//
//  Browser.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Browser: NSObject {

    fileprivate let session: MCSession
    fileprivate lazy var serviceBrowser: MCNearbyServiceBrowser = {
        let serviceBrowser = MCNearbyServiceBrowser(peer: self.session.myPeerID,
            serviceType: MultipeerConstants.defaultServiceType)
        serviceBrowser.delegate = self
        return serviceBrowser
    }()

    init(session: MCSession) {
        self.session = session
    }

    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }

    func startBrowsing() {
        serviceBrowser.startBrowsingForPeers()
    }

    func stopBrowsing() {
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension Browser: MCNearbyServiceBrowserDelegate {

    // For now, there is no find game / host game because multipeer hosts invite people to join the
    // session rather than the standard way where other people look for hosts to join.
    // So current strategy is to accept / invite anyone that is found.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {

        browser.invitePeer(peerID, to: self.session, withContext: nil,
                           timeout: MultipeerConstants.defaultTimeOut)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Do nothing for now
    }
}
