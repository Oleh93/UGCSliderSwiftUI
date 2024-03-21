//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageURl2 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=1000&ms_params="
    
    var body: some View {
        PageViewControllerContainer(pages: [
            .audio("TestFile"),
            .image(imageURl2),
            .link(imageURl2, "TestFile")
        ])
        .background(.black)
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
