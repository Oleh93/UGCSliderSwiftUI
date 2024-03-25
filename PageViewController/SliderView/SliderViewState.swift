//
//  SliderViewState.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 22.03.2024.
//

import Foundation
import Combine

class SliderViewState: ObservableObject {
    @Published var isShowingInfoAlert: Bool = false
    @Published var isShowingDeleteAlert: Bool = false

    @Published var pages: [PageType] = []
    @Published var currentIndex: Int = .zero

    var currentPage: PageType {
        pages[currentIndex]
    }
    
    func configurePages(_ pages: [PageType]) {
        self.pages = pages
    }
    
    func deleteCurrentItem() {
        pages.remove(at: currentIndex)
    }
    
    func getViewModel(for page: PageType) -> AudioPageViewModel? {
        switch page {
        case .audio(let string):
            if let vm = audioViewModels[string] {
                return vm
            } else {
                let vm = AudioPageViewModel(filename: string)
                audioViewModels[string] = vm
                return vm
            }
        case .link(_, let string2):
            if let vm = audioViewModels[string2] {
                return vm
            } else {
                let vm = AudioPageViewModel(filename: string2)
                audioViewModels[string2] = vm
                return vm
            }
        default:
            return nil
        }
    }
    
    private var audioViewModels: [String: AudioPageViewModel] = [:]
    
    // TODO: implement insetion, deletion, etc here
}
