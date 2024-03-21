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
    var filename: String
    
    @State private var player: AVAudioPlayer?
    
    @State private var isPLaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            PlayerView()
            Spacer()
        }
        .onAppear(perform: {
            setupAudio()
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio")
        }
    }
    
    private func playAudio() {
        player?.play()
        isPLaying = true
    }
    
    private func stopAudio() {
        player?.stop()
        isPLaying = false
    }
    
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    @ViewBuilder
    func PlayerView() -> some View {
        VStack(spacing: 16) {
            Text("My Awesome Audio")
            
            Slider(value: Binding(get: {
                currentTime
            }, set: { newValue in
                seekAudio(to: newValue)
            }), in: 0...totalTime)
            .foregroundColor(.black)
            
            
            HStack {
                Text(timeString(time:currentTime))
                Spacer()
                Text(timeString(time:totalTime))
            }
            
            HStack() {
                Spacer()
                Button {
                    isPLaying ? stopAudio() : playAudio()
                } label: {
                    Image(systemName: isPLaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                }
                Spacer()
            }
            .foregroundColor(.black)
        }
        .padding(16)
    }
}
