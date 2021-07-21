//
//  ARViewController.swift
//  AR Multipeer
//
//  Created by Michael DeProspo on 7/21/21.
//

import ARKit
import RealityKit
import Combine

class ARViewController: UIViewController, ARSessionDelegate {
    
    var arView = ARView(frame: .zero)
    var multipeerHelper: MultipeerHelper!
    
    let availableModels = ["flower_tulip.usdz", "trowel.usdz"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        arView.automaticallyConfigureSession = false
        setupConfiguration()
        setupGestures()
        startMultipeer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConfiguration() {
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isCollaborationEnabled = true
        
        arView.frame = view.bounds
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        arView.session.delegate = self
        arView.session.run(configuration)

        view.addSubview(arView)
    }
    
    func loadModel(named name: String, completion: @escaping (ModelEntity?)->()) {

        var cancellable: AnyCancellable? = nil
        
        cancellable = ModelEntity.loadModelAsync(named: name).sink(
            receiveCompletion: { loadCompletion in
                // Handle error
                switch loadCompletion {
                case .failure(let error):
                    print("Unable to load modelEntity for \(name). Error: \(error.localizedDescription)")
                    case .finished:
                        break
                }
                
                cancellable?.cancel()
            }, receiveValue: { modelEntity in
                
                cancellable?.cancel()
                completion(modelEntity)
                
                print("DEBUG: Successfully loaded modelEntity for modelName: \(name)")
            })
    }
    
}
