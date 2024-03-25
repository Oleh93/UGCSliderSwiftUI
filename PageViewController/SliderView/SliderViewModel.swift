//
//  SliderViewModel.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation

class SliderViewModel {
    let state: SliderViewState
    
    private var defaultInfoAlertAction: (() -> Void) {
        { self.state.isShowingInfoAlert = true }
    }
    
    private var defaultDeleteAlertAction: (() -> Void) {
        { self.state.isShowingDeleteAlert = true }
    }
    
    private lazy var defaultToolBarItems: [ToolbarView.ToolBarItemConfig] = [
        .init(image: .init(systemName: "trash"), action: defaultDeleteAlertAction),
        .init(image: .init(systemName: "info.circle"), action: defaultInfoAlertAction)
    ]
    
    init() {
        self.state = .init()
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
                .init(name: "Type", descripiton: "Image")
            ]
        case .audio(let string):
            [
                .init(name: "Title", descripiton: "Good evening we are from Ukraine"),
                .init(name: "Description", descripiton: "The song's incipit 'Good evening, we are from Ukraine', became a popular unofficial military greeting in Ukraine after the Russian military invasion"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "Audio")
            ]
        case .link(let string, let string2):
            [
                .init(name: "Title", descripiton: "Good evening we are from Ukraine"),
                .init(name: "Description", descripiton: "The song's incipit 'Good evening, we are from Ukraine', became a popular unofficial military greeting in Ukraine after the Russian military invasion"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "Link")
            ]
        case .video(let string):
            [
                .init(name: "Title", descripiton: "Ukraine promo"),
                .init(name: "Description", descripiton: "What is it like to be in Ukraine?"),
                .init(name: "Date", descripiton: "25/03/2024 12:40:30"),
                .init(name: "Type", descripiton: "Video")
            ]
        }
    }
    
    func toolBarItemsForCurrentPage() -> [ToolbarView.ToolBarItemConfig] {
        defaultToolBarItems
    }
}
