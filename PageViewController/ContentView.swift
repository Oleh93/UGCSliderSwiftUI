//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageUrl1 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=1200"
    
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
