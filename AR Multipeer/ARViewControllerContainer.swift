//
//  ARViewControllerContainer.swift
//  AR Multipeer
//
//  Created by Michael DeProspo on 7/21/21.
//

import SwiftUI

struct ARViewControllerContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
