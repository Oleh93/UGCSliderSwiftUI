//
//  PageView.swift
//  PageView
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI

enum PageType {
    case image(ImageConfig)
    case audio(String)
    case link(String, String)
    case video(String)
    
    // MARK: - ImageConfig
    struct ImageConfig {
        var imageName: String = "test_image"
        var description: String = "This is an image"
        var dateString: String = "25/03/2024 12:40:30"
        var url: String
    }
}

struct PageView: View {
    @Binding var currentIndex: Int
    @Binding var pages: [PageType]
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(pages.indices, id: \.self) { index in
                getView(for: pages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    private func getView(for viewType: PageType) -> some View {
        switch viewType {
        case .image(let config):
            ImagePageView(url: config.url)
        case .audio(let filename):
            AudioPageView(viewModel: AudioPageViewModel(filename: filename))
        case .link(let imageURL, let audioURL):
            LinkPageView(imageURL: imageURL, audioURL: audioURL)
        case .video(let videoUrl):
            VideoPageView(url: videoUrl)
        }
    }
}
