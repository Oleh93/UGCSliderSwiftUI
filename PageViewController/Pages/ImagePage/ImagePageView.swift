//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagePageView: View {
    
    struct Constants {
        static let animationDuration: CGFloat = 0.3
        static let maxOutOfEdgeCount = 2
        static let maxOutOfEdgePart = 0.05 // 5%
    }
    
    var url: String
    var sliderSize: CGSize
    
    @State private var loadingFailed: Bool = false
    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
    @State var isGragging: Bool = false
    @State var imageSize: CGSize = .zero
    @State var outOfLeftEdgeCount: Int = 0
    @State var outOfRightEdgeCount: Int = 0
    
    var body: some View {
        Group {
            if loadingFailed {
                errorView
            } else {
                image(from: url)
            }
        }
        .onDisappear {
            scale = 1.0
            offset = .zero
            lastOffset = .zero
        }
    }
    
    private func resetToOriginalPisitionAndScale() {
        scale = 1
        offset = .zero
        lastOffset = .zero
        outOfLeftEdgeCount = 0
        outOfRightEdgeCount = 0
    }
    
    private func image(from url: String) -> some View {
        WebImage(url: URL(string: url)) { image in
            ZoomableImageView(image: image)
        } placeholder: {
            ProgressView {
                Text("Loading...")
                    .font(.headline)
            }
        }
        .onFailure { _ in
            self.loadingFailed = true
        }
        .readSize { size in
            imageSize = size
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
    ImagePageView(url: "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f007c94b-0069-4b33-b537-312f1f712602.jpg?Client=AncestryIOS&MaxSide=1000", sliderSize: .zero)
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

