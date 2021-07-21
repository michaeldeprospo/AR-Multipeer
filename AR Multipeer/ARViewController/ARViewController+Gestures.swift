//
//  ARViewController+Gestures.swift
//  AR Multipeer
//
//  Created by Michael DeProspo on 7/21/21.
//

import RealityKit
import ARKit

extension ARViewController {
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Get 2D location of gesture
        let location = sender.location(in: arView)
        
        guard let raycastResult = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal).first else {
            print("Could not get raycast result")
            return
        }
        
        let anchor = ARAnchor(transform: raycastResult.worldTransform)
        
        guard let modelName = availableModels.randomElement() else {
            return
        }
        
        loadModel(named: modelName, completion: { modelEntity in
            if let entity = modelEntity {
                let clonedEntity = entity.clone(recursive: true)
                
                clonedEntity.generateCollisionShapes(recursive: true)
                self.arView.installGestures(.all, for: clonedEntity)

                let anchorEntity = AnchorEntity(anchor: anchor)
                anchorEntity.addChild(clonedEntity)
                
                anchorEntity.synchronization?.ownershipTransferMode = .autoAccept
                anchorEntity.anchoring = AnchoringComponent(anchor)
                
                self.arView.session.add(anchor: anchor)
                self.arView.scene.addAnchor(anchorEntity)
                
                if let myData = modelName.data(using: .unicode) {
                    self.multipeerHelper.sendToAllPeers(myData, reliably: true)
                }
            }
        })
        
    }
    
}
