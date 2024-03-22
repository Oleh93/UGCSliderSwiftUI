//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct ImagePageView: View {
    var url: String
    @State private var loadingFailed: Bool = false
    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    
    var body: some View {
        Group {
            if loadingFailed {
                errorView
            } else {
                zoomableImage
            }
        }
        .onDisappear {
            scale = 1.0
        }
    }
    
    private var zoomableImage: some View {
        image(from: url)
            .scaleEffect(scale * gestureScale)
            .gesture(
                MagnificationGesture()
                    .updating($gestureScale) { value, gestureScale, _ in
                        gestureScale = value
                    }
                    .onEnded { delta in
                        if (scale * delta) < 1.0 {
                            withAnimation {
                                scale = 1.0
                            }
                        } else {
                            scale *= delta
                        }
                    }
            )
            .gesture(
                TapGesture(count: 2)
                    .onEnded {
                        if scale == 1.0 {
                            withAnimation {
                                scale = 4.0
                            }
                        } else {
                            withAnimation {
                                scale = 1.0
                            }
                        }
                    }
            )
    }
    
    private func image(from url: String) -> some View {
        WebImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView {
                Text("Loading...")
                    .font(.headline)
            }
        }
        .onFailure { _ in
            self.loadingFailed = true
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
            Text("The server is currently unavailable. Please check your internet connection or try again later")
                .font(.title)
        }
        .padding(20)
    }
}


struct ImagePageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePageView(url: "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=1200")
    }
}

