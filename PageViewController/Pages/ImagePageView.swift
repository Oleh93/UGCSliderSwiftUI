//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagePageView: View {
    var url: String
    @State private var loadingFailed: Bool = false
    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
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
            offset = .zero
            lastOffset = .zero
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
            .highPriorityGesture(scale == 1.0 ? nil : DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    withAnimation(.interactiveSpring()) {
                        offset = handleOffsetChange(value.translation)
                    }
                })
                .onEnded({ _ in
                    lastOffset = offset
                }))
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        if scale == 1.0 {
                            withAnimation {
                                scale = 4.0
                            }
                        } else {
                            withAnimation {
                                scale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                    }
            )
    }
    
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        
        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height
        
        return newOffset
    }
    
    private func image(from url: String) -> some View {
        WebImage(url: URL(string: url)) { image in
            image
                .resizable()
                .offset(offset)
                .aspectRatio(contentMode: .fit)
                .clipped()
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

#Preview {
    ImagePageView(url: "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f007c94b-0069-4b33-b537-312f1f712602.jpg?Client=AncestryIOS&MaxSide=1000")
}

