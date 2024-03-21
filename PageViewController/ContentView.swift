//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageUrl1 = "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400"
    let imageURl2 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=400&ms_params="
    
    var body: some View {
        PageViewControllerContainer([
            .audio("TestFile"),
            .image(imageUrl1),
            .link(imageURl2, "TestFile")
        ])
        .padding(16)
    }
}

#Preview {
    ContentView()
}
