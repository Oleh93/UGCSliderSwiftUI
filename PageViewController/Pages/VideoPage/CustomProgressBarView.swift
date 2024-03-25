//
//  CustomProgressBarView.swift
//  PageViewController
//
//  Created by Oleksandr Shumylo on 25.03.2024.
//

import SwiftUI
import AVKit

struct CustomProgressBarView: UIViewRepresentable {
    @Binding var value: Float
    @Binding var avPlayer: AVPlayer
    @Binding var isPlaying: Bool
        
    private var smallThumbImage: UIImage {
        createThumbImage(size: CGSize(width: 16, height: 16), color: .white)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomProgressBarView>) -> UISlider {
        let dashedSlider = DashedSliderView(avPlayer: self.avPlayer)
        
        dashedSlider.maximumTrackTintColor = .clear
        dashedSlider.minimumTrackTintColor = .clear
        dashedSlider.setThumbImage(smallThumbImage, for: .normal)
        dashedSlider.value = value
        dashedSlider.addTarget(context.coordinator, action: #selector(context.coordinator.change(slider:)), for: .valueChanged)
        
        context.coordinator.addSliderValueTimeObserver(player: avPlayer)
        
        return dashedSlider
    }
    
    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBarView>) {
        uiView.value = value
        uiView.setNeedsDisplay()
    }
    
    private func updateSliderValue() {
        let currentTime = avPlayer.currentTime()
        let duration = avPlayer.currentItem?.duration ?? CMTime.zero
        
        if !duration.isIndefinite {
            let value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            self.value = value
        }
    }
    
    private func createThumbImage(size: CGSize, color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fillEllipse(in: rect)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        CustomProgressBarView.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomProgressBarView

        private var sliderTimeObserver: Any?
        
        init(parent: CustomProgressBarView) {
            self.parent = parent
        }

        @objc func change(slider: UISlider) {
            let duration = parent.avPlayer.currentItem?.duration.seconds ?? 0
            let targetTime = CMTime(seconds: Double(slider.value) * duration, preferredTimescale: 1)
            parent.avPlayer.seek(to: targetTime)
        }

        func addSliderValueTimeObserver(player: AVPlayer) {
            if sliderTimeObserver == nil {
                sliderTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                    self.parent.updateSliderValue()
                }
            }
        }
        
        func detachSliderValueTimeObserver() {
            if let observer = sliderTimeObserver {
                parent.avPlayer.removeTimeObserver(observer)
                sliderTimeObserver = nil
            }
        }
        
        deinit {
            detachSliderValueTimeObserver()
        }
    }
}

private class DashedSliderView: UISlider {
    var avPlayer: AVPlayer

    init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dashHeight: CGFloat = 3.0
    let timeCodeColor = UIColor(.black).cgColor
    let trackLine = UIColor.gray.cgColor
    let viewedColor = UIColor.white.cgColor
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let viewedX = rect.size.width * CGFloat(value)
        
        context?.setFillColor(trackLine)
        let trackLine = CGRect(x: 0, y: (rect.size.height - dashHeight) / 2, width: rect.size.width, height: dashHeight)
        context?.fill(trackLine)
                
        context?.setFillColor(viewedColor)
        let viewedLine = CGRect(x: 0, y: (rect.size.height - dashHeight) / 2, width: viewedX, height: dashHeight)
        context?.fill(viewedLine)
        
        let totalDuration = CMTimeGetSeconds(
            avPlayer.currentItem?.asset.duration ?? CMTime(seconds: 0, preferredTimescale: 1)
        )
    }
}
