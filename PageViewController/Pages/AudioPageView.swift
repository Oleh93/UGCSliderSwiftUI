//
//  AudioPageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI
import AVKit

struct AudioPageView: View {
    
    var isDisplayedView: Bool
    @ObservedObject var viewModel: AudioPageViewModel
    
    init(isDisplayedView: Bool, viewModel: AudioPageViewModel) {
        self.isDisplayedView = isDisplayedView
        self.viewModel = viewModel
        if !isDisplayedView {
            viewModel.stopAudio()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            PlayerView()
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            viewModel.setupAudio()
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateProgress()
        }
    }
    
    @ViewBuilder
    func PlayerView() -> some View {
        VStack(spacing: 16) {
            Text("My Awesome Audio")
            
            Slider(value: Binding(get: {
                viewModel.currentTime
            }, set: { newValue in
                viewModel.seekAudio(to: newValue)
            }), in: 0...viewModel.totalTime)
            
            HStack {
                Text(viewModel.timeString(time: viewModel.currentTime))
                Spacer()
                Text(viewModel.timeString(time: viewModel.totalTime))
            }
            
            HStack() {
                Spacer()
                Button {
                    viewModel.isPLaying ? viewModel.stopAudio() : viewModel.playAudio()
                } label: {
                    Image(systemName: viewModel.isPLaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                }
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
}

class AudioPageViewModel: ObservableObject {
    var filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    @Published private var player: AVAudioPlayer?
    
    @Published var isPLaying = false
    @Published var totalTime: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    
    func setupAudio() {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        
        guard player == nil else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio")
        }
    }
    
    func playAudio() {
        player?.play()
        isPLaying = true
    }
    
    func stopAudio() {
        player?.stop()
        isPLaying = false
    }
    
    func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    deinit {
        stopAudio()
        print("deinit")
    }
}

#Preview {
    AudioPageView(isDisplayedView: true, viewModel: AudioPageViewModel(filename: "TestFile"))
        .environment(\.colorScheme, .dark)
}
