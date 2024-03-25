//
//  SliderView.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation
import SwiftUI

struct SliderView: View {
    let viewModel: SliderViewModel
    @ObservedObject var state: SliderViewState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    init(viewModel: SliderViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state
        
        viewModel.loadPages()
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            VStack(spacing: .zero) {
                PageView(
                    state: state,
                    currentIndex: $state.currentIndex,
                    pages: $state.pages
                )
                if viewModel.shouldShowToolbar {
                    ToolbarView(items: viewModel.toolBarItemsForCurrentPage())
                }
            }
            if state.isShowingInfoSideView {
                infoViewForCurrentPage
                    .frame(width: 250)
                    .transition(.move(edge: .trailing))
            }
        }
        .background(.black)
        .environment(\.colorScheme, .dark)
        .sheet(isPresented: $state.isShowingInfoAlert) {
            infoViewForCurrentPage
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $state.isShowingDeleteAlert) {
            deleteAlertForCurrentPage
        }
        .onChange(of: horizontalSizeClass, {
            viewModel.didChangeHorizontalSizeClass(horizontalSizeClass)
        })
        .onAppear(perform: {
            viewModel.didChangeHorizontalSizeClass(horizontalSizeClass)
        })
        .animation(.easeInOut, value: state.isShowingInfoSideView)
    }

    @ViewBuilder
    var infoViewForCurrentPage: some View {
        MetadataView(metadata: viewModel.metadataForCurrentPage()) {
            viewModel.didTapInfoViewCloseButton()
        }
            .padding(.horizontal, 16)
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
    SliderView(viewModel: .init())
}
