//
//  VideoPlayerViewModel.swift
//  PageViewController
//
//  Created by Oleksandr Shumylo on 24.03.2024.
//

import Foundation
import AVKit

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying: Bool = false
    
    init(url: String) {
        if let videoUrl = URL(string: url) {
            player = AVPlayer(url: videoUrl)
        }
    }

    func stopVideoPlayback() {
        player?.pause()
        player?.seek(to: .zero)
    }
}
