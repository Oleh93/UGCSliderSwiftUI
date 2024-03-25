//
//  VideoPageView.swift
//  PageViewController
//
//  Created by Oleksandr Shumylo on 22.03.2024.
//

import SwiftUI

struct VideoPageView: View {
    @StateObject var viewModel: VideoPlayerViewModel
    
    init(url: String) {
        self._viewModel = StateObject(wrappedValue: VideoPlayerViewModel(url: url))
    }
    
    public var body: some View {
        if let avPlayer = viewModel.player {
            VideoPlayerView(isPlaying: $viewModel.isPlaying, player: avPlayer)
                .onDisappear {
                    viewModel.stopVideoPlayback()
                }
        } else {
            Text("Video not found")
                .font(.title)
        }
    }
}
