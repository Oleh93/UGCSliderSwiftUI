//
//  SliderViewModel.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation

class SliderViewModel {
    let state: SliderViewState
    
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
            .link(imageUrl2, audioName2),
            .video(videoUrl?.absoluteString ?? ""),
            
                .image(.init(
                    url: imageUrl3,
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
            .image(.init(
                url: imageUrl4,
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
            .image(.init(
                url: imageUrl5,
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
            
                .video(videoUrl2?.absoluteString ?? ""),
            
                .image(.init(
                    url: imageUrl6,
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
        ]
        
        state.configurePages(pages)
    }
}
