//
//  ContentViewModel.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation

class ContentViewModel {
    let state: PageViewState
    
    init() {
        self.state = .init()
    }
    
    func loadPages() {
        let pages: [PageType] = [
            .image(.init(
                url: imageUrl,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { self.state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { self.state.isShowingDeleteAlert = true }
                    )
                ]
            )),
            .audio(audioName),
            .link(imageUrl2, audioName),
            .video(videoName),
        ]
        
        state.configurePages(pages)
    }
}
