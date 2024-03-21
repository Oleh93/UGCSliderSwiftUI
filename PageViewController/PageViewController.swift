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
            AudioPageView(viewModel: AudioPageViewModel(filename: filename))
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
