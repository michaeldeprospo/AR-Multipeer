//
//  ARViewController+Multipeer.swift
//  AR Multipeer
//
//  Created by Michael DeProspo on 7/21/21.
//

import RealityKit
import MultipeerConnectivity

extension ARViewController: MultipeerHelperDelegate {
    
    func shouldSendJoinRequest(_ peer: MCPeerID, with discoveryInfo: [String: String]?) -> Bool {
        if ARViewController.checkPeerToken(with: discoveryInfo) {
            return true
        }
        
        print("incompatible peer!")
        return false
    }

    func startMultipeer() {
        multipeerHelper = MultipeerHelper(
            serviceName: "ar-multipeer",
            sessionType: .both,
            delegate: self
        )

        // MARK: - Setting RealityKit Synchronization
        guard let syncService = multipeerHelper.syncService else {
            fatalError("could not create multipeerHelp.syncService")
        }
        
        arView.scene.synchronizationService = syncService
        
        print("Multipeer service started...")
    }

    func receivedData(_ data: Data, _ peer: MCPeerID) {
        print("Received Data from: \(peer.displayName) - \(String(data: data, encoding: .unicode))" ?? "Data is not a unicode string")
        
        if let modelName = String(data: data, encoding: .unicode) {
            DispatchQueue.main.async {
                self.loadModel(named: modelName, completion: { modelEntity in
                    if let _ = modelEntity {
                        print("Remote model loaded...")
                    }
                })
            }
        }
    }

    func peerJoined(_ peer: MCPeerID) {
        print("new peer has joined: \(peer.displayName)")
    }
    
    func peerLeft(_ peer: MCPeerID) {
        print("peer has left: \(peer.displayName)")
    }
    
    func peerLost(_ peer: MCPeerID) {
        print("peer was lost left: \(peer.displayName)")
    }
    
}
