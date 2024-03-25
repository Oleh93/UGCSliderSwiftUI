//
//  VideoPlayerView.swift
//  PageViewController
//
//  Created by Oleksandr Shumylo on 25.03.2024.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @Binding var isPlaying: Bool
    @State private var showControls = true
    @State private var timer: Timer?
    
    @State private var isPLayerFullScreen = false
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    @State var player: AVPlayer
    
    var body: some View {
        
        let controlButtons = PlayerControlButtonsView(
            isPlaying: $isPlaying,
            timer: $timer,
            showPlayerControlButtons: $showControls,
            isPlayerFullScreen: $isPLayerFullScreen,
            avPlayer: $player
        )
        
        let player = PlayerViewContainer(player: $player)
        
        VStack {
            
            ZStack {
                player
                
                if showControls {
                    controlButtons
                }
                
            }
            .padding(.top)
            .frame(height: frameHeight(for: orientation))
            .onTapGesture {
                withAnimation {
                    showControls.toggle()
                }
                if isPlaying {
                    startTimer()
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    orientation = UIDevice.current.orientation
                }
            }
            .statusBar(hidden: true)
            .preferredColorScheme(.dark)
            .fullScreenCover(isPresented: $isPLayerFullScreen) {
                ZStack {
                    player
                    if showControls {
                        controlButtons
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showControls.toggle()
                    }
                    if isPlaying {
                        startTimer()
                    }
                }
                .frame(height: frameHeightFullScreen(for: orientation))
            }
        }
    }
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            withAnimation {
                showControls = false
            }
        }
    }
    
    
    private func frameHeightFullScreen(for orientation: UIDeviceOrientation) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if orientation.isPortrait {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.4 : screenHeight * 0.33
        } else {
            return UIScreen.main.bounds.height
        }
    }
    
    private func frameHeight(for orientation: UIDeviceOrientation) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if orientation.isLandscape {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.8 : screenHeight * 0.66
        } else {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.4 : screenHeight * 0.33
        }
    }
}


private struct PlayerViewContainer: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerViewContainer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayerViewContainer>) {
    
    }
}
