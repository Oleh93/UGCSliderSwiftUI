//
//  VideoPageView.swift
//  PageViewController
//
//  Created by Oleksandr Shumylo on 22.03.2024.
//

import SwiftUI
import AVKit

struct VideoPageView: View {
    var videoFileName: String
    @State private var player = AVPlayer()
    
    var body: some View {
        if let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player = AVPlayer(url: videoURL)
                    player.play()
                }
                .onDisappear {
                    player.pause()
                }
        } else {
            Text("Video not found")
                .font(.headline)
                .foregroundColor(.red)
        }
    }
}

struct VideoPageView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPageView(videoFileName: "Ukraine")
    }
}
