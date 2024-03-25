//
//  ContentView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 20.03.2024.
//

import SwiftUI

let imageUrl = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f007c94b-0069-4b33-b537-312f1f712602.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl2 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/f04f4e0a-2480-4155-883e-ac8cadd1adc6.jpg?Client=AncestryIOS&MaxSide=1000"
let imageUrl3 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/bfe4e3ef-b565-46c5-a332-63b2723ca5c8.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl4 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/1c6bfe7b-d599-42ab-8037-af06e5c93efd.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl5 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/c8ae06e5-14d7-4e96-b53b-8098dbcdb2da.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl6 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/458becd8-a519-4037-847f-1ba08abbf89f.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl7 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/8a7ef112-1b3f-4f97-9061-c335c12d6d72.jpg?Client=AncestryIOS&MaxSide=1000"

let imageUrl8 = "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/ecb71db0-15ec-456e-b032-b677f9daf406.jpg?Client=AncestryIOS&MaxSide=1000"

let audioName = "TestFile"

let videoUrl = Bundle.main.url(forResource: "Ukraine", withExtension: "mp4")
let videoUrl2 = Bundle.main.url(forResource: "StillWaters", withExtension: "mp4")

struct ContentView: View {
    @ObservedObject var state = PageViewState()
    
    init() {
        loadPages()
    }
    
    func loadPages() {
        let pages: [PageType] = [
            .image(.init(
                url: imageUrl,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { state.isShowingDeleteAlert = true }
                    )
                ]
            )),
            .audio(audioName),
            .link(imageUrl2, audioName),
            .video(videoUrl?.absoluteString ?? ""),
            
            .image(.init(
                url: imageUrl3,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { state.isShowingDeleteAlert = true }
                    )
                ]
            )),
            .image(.init(
                url: imageUrl4,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { state.isShowingDeleteAlert = true }
                    )
                ]
            )),
            .image(.init(
                url: imageUrl5,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { state.isShowingDeleteAlert = true }
                    )
                ]
            )),
            
			.video(videoUrl2?.absoluteString ?? ""),
            
            .image(.init(
                url: imageUrl6,
                toolBarItems: [
                    .init(
                        image: .init(systemName: "info.circle"),
                        action: { state.isShowingInfoAlert = true }
                    ),
                    .init(
                        image: .init(systemName: "square.and.arrow.up"),
                        action: { }
                    ),
                    .init(
                        image: .init(systemName: "trash"),
                        action: { state.isShowingDeleteAlert = true }
                    )
                ]
            )),
        ]
        
        state.configurePages(pages)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            PageView(
                currentIndex: $state.currentIndex,
                pages: $state.pages
            )
            ToolbarView(items: state.currentPage.toolBarItems)
        }
        .background(.black)
        .environment(\.colorScheme, .dark)
        .sheet(isPresented: $state.isShowingInfoAlert) {
            infoViewForCurrentPage
                .presentationDetents([.medium])
        }
        .alert(isPresented: $state.isShowingDeleteAlert) {
            deleteAlertForCurrentPage
        }
    }
    
    @ViewBuilder
    var infoViewForCurrentPage: some View {
        switch state.currentPage {
        case .image(let imageConfig):
            Text(imageConfig.description)
        default:
            EmptyView()
        }
    }
    
    var deleteAlertForCurrentPage: Alert {
        Alert(
            title: Text("Delete item?"),
            primaryButton: .cancel(),
            secondaryButton: .destructive(Text("Delete"), action: { state.deleteCurrentItem() })
        )
    }
}

#Preview {
    ContentView()
}
