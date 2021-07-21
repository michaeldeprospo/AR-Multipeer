//
//  ContentView.swift
//  AR Multipeer
//
//  Created by Michael DeProspo on 7/21/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ARViewControllerContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
