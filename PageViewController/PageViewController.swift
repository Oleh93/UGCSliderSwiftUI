//
//  PageViewController.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI

enum PageType {
    case image(String)
    case audio(String)
    case link(String, String)
}

struct PageViewControllerContainer: View {
    
    var pages: [PageType]
    
    var body: some View {
        TabView {
            ForEach(pages.indices, id: \.self) { index in
                getView(for: pages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
    
    @ViewBuilder
    private func getView(for viewType: PageType) -> some View {
        switch viewType {
        case .image(let url):
            ImagePageView(url: url)
        case .audio(let filename):
            AudioPageView(viewModel: AudioPageViewModel(filename: filename))
        case .link(let imageURL, let audioURL):
            LinkPageView(imageURL: imageURL, audioURL: audioURL)
        }
    }
}
