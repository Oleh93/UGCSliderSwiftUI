//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageUrl1 = "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400"
    
    var body: some View {
        PageViewControllerContainer([
            .audio("TestFile"),
            .image(imageUrl1),
            .link(imageUrl1, "TestFile")
        ])
    }
}

#Preview {
    ContentView()
}
