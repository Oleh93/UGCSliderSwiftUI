//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import SwiftUI

struct ImagePageView: View {
    var url: String
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        loadImage(from: url)
            .scaleEffect(scale)
            .gesture(
              MagnificationGesture()
                .onChanged { value in
                  self.scale = value.magnitude
                }
                .onEnded { value in
                    if self.scale < 1.0 {
                        withAnimation {
                            self.scale = 1.0
                        }
                    }
                }
            )
    }
    
    @ViewBuilder
    private func loadImage(from url: String) -> some View {
        AsyncImage(
            url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Text("Loading ...")
            }
    }
}

struct ImagePageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePageView(url: "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=1200")
    }
}

