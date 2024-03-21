//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    let imageUrl1 = "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400"
    
    var body: some View {
        PageViewControllerContainer([
            .audio("TestFile"),
            .image(imageUrl1),
            .link(imageUrl1, "TestFile")
        ])
    }
}

struct ImagePageView: View {
    var url: String
    
    var body: some View {
        
        AsyncImage(
            url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Text("Loading ...")
            }
    }
}

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



struct LinkPageView: View {
    var imageURL: String
    var audioURL: String
    
    var body: some View {
        VStack {
            ImagePageView(url: imageURL)
            AudioPageView(filename: audioURL)
        }
    }
}

enum PageType {
    case image(String)
    case audio(String)
    case link(String, String)
}

struct PageViewControllerContainer: View {
    
    var pages: [PageType]
    
    init(_ pages: [PageType]) {
        self.pages = pages
    }
    
    var body: some View {
        PageViewController(controllers: pages.map({ UIHostingController(rootView: getView(for: $0)) }))
    }
    
    @ViewBuilder
    private func getView(for viewType: PageType) -> some View {
        switch viewType {
        case .image(let url):
            ImagePageView(url: url)
        case .audio(let filename):
            AudioPageView(filename: filename)
        case .link(let imageURL, let audioURL):
            LinkPageView(imageURL: imageURL, audioURL: audioURL)
        }
    }
}

struct PageViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == 0 {
                return self.parent.controllers.last
            }
            return self.parent.controllers[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == self.parent.controllers.count - 1 {
                return self.parent.controllers.first
            }
            return self.parent.controllers[index + 1]
        }
            
        
        let parent: PageViewController

        init(_ parent: PageViewController) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    typealias UIViewControllerType = UIPageViewController
    
    var controllers: [UIViewController] = []

}

#Preview {
    ContentView()
}
