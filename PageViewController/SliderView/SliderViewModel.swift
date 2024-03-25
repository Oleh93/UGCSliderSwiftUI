//
//  SliderViewModel.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation
import SwiftUI

class SliderViewModel {
    private var horizontalSizeClass: UserInterfaceSizeClass?

    let state: SliderViewState

    private lazy var defaultToolBarItems: [ToolbarView.ToolBarItemConfig] = [
        .init(image: .init(systemName: "trash"), action: { self.didTapDeleteButton() }),
        .init(image: .init(systemName: "info.circle"), action: { self.didTapInfoButton() })
    ]
    
    init() {
        self.state = .init()
    }
    
    var shouldShowToolbar: Bool {
        if horizontalSizeClass == .compact {
            return true
        } else {
            return !state.isShowingInfoSideView
        }
    }
    
    func loadPages() {
        let pages: [PageType] = [
            .image(.init(url: imageUrl)),
            .audio(audioName),
            .link(imageUrl4, audioName2),
            .video(videoUrl?.absoluteString ?? ""),
            .image(.init(url: imageUrl3)),
            .image(.init(url: imageUrl2)),
            .image(.init(url: imageUrl5)),
            .video(videoUrl2?.absoluteString ?? ""),
            .image(.init(url: imageUrl6))
        ]
        
        state.configurePages(pages)
    }
    
    func metadataForCurrentPage() -> [MetadataView.Metadata] {
        switch state.currentPage {
        case .image(let imageConfig):
            [
                .init(name: "Title", descripiton: imageConfig.imageName),
                .init(name: "Description", descripiton: imageConfig.description),
                .init(name: "Date", descripiton: imageConfig.dateString),
                .init(name: "Type", descripiton: "image"),
                .init(name: "URL", descripiton: imageConfig.url)
            ]
        case .audio(let string):
            [
                .init(name: "Title", descripiton: "test_audio"),
                .init(name: "Description", descripiton: "This is in audio"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "audio"),
                .init(name: "URL", descripiton: string)
            ]
        case .link(let string, let string2):
            [
                .init(name: "Title", descripiton: "test_audio"),
                .init(name: "Description", descripiton: "This is a link"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "link"),
                .init(name: "URL1", descripiton: string),
                .init(name: "URL2", descripiton: string2)
            ]
        case .video(let string):
            [
                .init(name: "Title", descripiton: "test_audio"),
                .init(name: "Description", descripiton: "This is a video"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "video"),
                .init(name: "URL", descripiton: string)
            ]
        }
    }
    
    func toolBarItemsForCurrentPage() -> [ToolbarView.ToolBarItemConfig] {
        defaultToolBarItems
    }
    
    func didTapInfoButton() {
        if horizontalSizeClass == .compact {
            state.isShowingInfoAlert = true
        } else {
            state.isShowingInfoSideView = true
        }
    }
    
    func didTapDeleteButton() {
        state.isShowingDeleteAlert = true
    }
    
    func didChangeHorizontalSizeClass(_ horizontalSizeClass: UserInterfaceSizeClass?) {
        self.horizontalSizeClass = horizontalSizeClass
        
        if horizontalSizeClass == .compact {
            if state.isShowingInfoSideView {
                state.isShowingInfoAlert = true
                state.isShowingInfoSideView = false
            }
        } else {
            if state.isShowingInfoAlert {
                state.isShowingInfoAlert = false
                state.isShowingInfoSideView = true
            }
        }
    }
    
    func didTapInfoViewCloseButton() {
        state.isShowingInfoAlert = false
        state.isShowingInfoSideView = false
    }
}
