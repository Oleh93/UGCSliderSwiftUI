//
//  PageViewState.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 22.03.2024.
//

import Foundation
import Combine

class PageViewState: ObservableObject {
    @Published var isShowingInfoAlert: Bool = false
    @Published var isShowingDeleteAlert: Bool = false

    @Published private(set) var pages: [PageType] = []
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
    
    // TODO: implement insetion, deletion, etc here
}
