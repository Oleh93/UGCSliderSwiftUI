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
                // zoom
                MagnificationGesture()
                    .updating($gestureScale) { value, gestureScale, _ in
                        gestureScale = value
                    }
                    .onEnded { delta in
                        if (scale * delta) < 1.0 {
                            withAnimation(.interactiveSpring(duration: Constants.animationDuration)) {
                                resetToOriginalPisitionAndScale()
                            }
                        } else {
                            scale *= delta
                            // position the image correctly after zoom out
                            withAnimation(.interactiveSpring(duration: Constants.animationDuration)) {
                                dragDidEnd()
                            }
                        }
                    }
            )
            // intercept the TabView swipe if the image is scaled (custom DragGesture). If not, allow swipe.
            .highPriorityGesture(
                scale == 1.0 ? nil : DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        isGragging = true
                        withAnimation(.interactiveSpring()) {
                            offset = handleOffsetChange(value.translation)
                        }
                    })
                    .onEnded({ gesture in
                        isGragging = false
                        // first we need to decelerate image
                        withAnimation(.interactiveSpring(duration: 2 * Constants.animationDuration)) {
                            offset = handleOffsetChange(gesture.predictedEndTranslation)
                            lastOffset = offset
                        }
                        // then wait for decelerate to be done and then position the image correctly
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDuration) {
                            if !isGragging {
                                withAnimation(.interactiveSpring(duration: Constants.animationDuration)) {
                                    dragDidEnd()
                                }
                            }
                        }
                    }))
            .simultaneousGesture(
                // double tap
                TapGesture(count: 2)
                    .onEnded {
                        if scale == 1.0 {
                            withAnimation {
                                scale = 2.0
                            }
                        } else {
                            withAnimation(.interactiveSpring(duration: Constants.animationDuration)) {
                                resetToOriginalPisitionAndScale()
                            }
                        }
                    }
            )
    }
    
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        
        let imageScaledWidth = imageSize.width * scale
        // do not allow to move it horizontally if image width fits the slider width
        if imageScaledWidth > sliderSize.width {
            let expectedWidth = (offset.width / scale + lastOffset.width) * scale
            let absExpectedWidth = abs(expectedWidth)
            let maxOffSetWidth = ((imageScaledWidth - sliderSize.width) / 2 ) + imageScaledWidth * Constants.maxOutOfEdgePart
            // do not allow it go out of edge more then 5% of image
            let actualWidth = min(maxOffSetWidth, absExpectedWidth) * expectedWidth / absExpectedWidth
            newOffset.width = actualWidth / scale
        }
        
        let imageScaledHeight = imageSize.height * scale
        // do not allow to move it vertically if image height fits the slider height
        if imageScaledHeight > sliderSize.height {
            let expectedHeight = (offset.height / scale + lastOffset.height) * scale
            let absExpectedHeight = abs(expectedHeight)
            let maxOffSetHeight = ((imageScaledHeight - sliderSize.height) / 2 ) + imageScaledHeight * Constants.maxOutOfEdgePart
            // do not allow it go out of edge more then 5% of image
            let actualHeight = min(maxOffSetHeight, absExpectedHeight) * expectedHeight / absExpectedHeight
            newOffset.height = actualHeight / scale
        }
        
        return newOffset
    }
    
    private func dragDidEnd() {
        // position only if image is zoomed
        guard scale != 1 else {
            resetToOriginalPisitionAndScale()
            return
        }
        
        positionHorizontally()
        positionVertically()
        lastOffset = offset
        
        // if image has been moved out of edges more then `maxOutOfEdgeCount` times -> reset to original and allow swipe to next image
        if outOfLeftEdgeCount >= Constants.maxOutOfEdgeCount || outOfRightEdgeCount >= Constants.maxOutOfEdgeCount {
            resetToOriginalPisitionAndScale()
        }
    }
    
    private func positionHorizontally() {
        let imageScaledWidth = imageSize.width * scale
        // do not allow to move it horizontally if image width fits the slider width
        if imageScaledWidth > sliderSize.width {
            let imageScaledOffSetWidth = abs(offset.width * scale)
            let maxOffSetWidth = (imageScaledWidth - sliderSize.width) / 2
            let widthDifference = imageScaledOffSetWidth - maxOffSetWidth
            // if the image is moved out of bounds horizontally then we need to adjust its position
            if widthDifference > 0 {
                var newOffSetWidth: CGFloat
                // check if it is right or left side
                if offset.width >= 0 {
                    newOffSetWidth = maxOffSetWidth
                    outOfLeftEdgeCount = outOfLeftEdgeCount + 1
                    outOfRightEdgeCount = 0
                } else {
                    newOffSetWidth = -maxOffSetWidth
                    outOfRightEdgeCount = outOfRightEdgeCount + 1
                    outOfLeftEdgeCount = 0
                }
                offset = CGSize(width: newOffSetWidth / scale, height: offset.height)
            }
        }
    }
    
    private func positionVertically() {
        let imageScaledHeight = imageSize.height * scale
        // do not allow to move it vertically if image height fits the slider height
        if imageScaledHeight > sliderSize.height {
            let imageScaledOffSetHeight = abs(offset.height * scale)
            let maxOffSetHeight = (imageScaledHeight - sliderSize.height) / 2
            let heightDifference = imageScaledOffSetHeight - maxOffSetHeight
            // if the image is moved out of bounds vertically then we need to adjust its position
            if heightDifference > 0 {
                let newOffSetHeight = offset.height >= 0 ? maxOffSetHeight : -maxOffSetHeight
                offset = CGSize(width: offset.width, height: newOffSetHeight / scale)
            }
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

