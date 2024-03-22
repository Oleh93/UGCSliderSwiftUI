//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageUrl = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f007c94b-0069-4b33-b537-312f1f712602.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl2 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f04f4e0a-2480-4155-883e-ac8cadd1adc6.jpg?Client=AncestryIOS&MaxSide=1000"
    let imageUrl3 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/bfe4e3ef-b565-46c5-a332-63b2723ca5c8.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl4 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/1c6bfe7b-d599-42ab-8037-af06e5c93efd.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl5 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/c8ae06e5-14d7-4e96-b53b-8098dbcdb2da.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl6 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/458becd8-a519-4037-847f-1ba08abbf89f.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl7 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/8a7ef112-1b3f-4f97-9061-c335c12d6d72.jpg?Client=AncestryIOS&MaxSide=1000"
    
    let imageUrl8 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/ecb71db0-15ec-456e-b032-b677f9daf406.jpg?Client=AncestryIOS&MaxSide=1000"
    
    var body: some View {
        PageViewControllerContainer(pages: [
            .image(imageUrl),
            .audio("TestFile"),
            .link(imageUrl2, "TestFile"),
            .image(imageUrl3),
            .image(imageUrl4),
            .link(imageUrl5, "TestFile"),
            .image(imageUrl6),
            .image(imageUrl7),
            .image(imageUrl8),
        ])
        .background(.black)
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
