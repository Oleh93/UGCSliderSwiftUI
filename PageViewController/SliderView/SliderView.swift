//
//  SliderView.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation
import SwiftUI

struct SliderView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    let viewModel: SliderViewModel
    @ObservedObject var state: SliderViewState

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
        .onChange(of: horizontalSizeClass, {
            viewModel.didChangeHorizontalSizeClass(horizontalSizeClass)
        })
        .background(.black)
        .environment(\.colorScheme, .dark)
        .sheet(isPresented: $state.isShowingInfoAlert) {
            infoViewForCurrentPage
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .environment(\.colorScheme, .dark)
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
        .padding(16)
        .background(Color(.secondarySystemBackground))
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
