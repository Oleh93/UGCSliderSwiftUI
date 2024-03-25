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

    init(viewModel: SliderViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state
        
        viewModel.loadPages()
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            PageView(
                currentIndex: $state.currentIndex,
                pages: $state.pages
            )
            ToolbarView(items: viewModel.toolBarItemsForCurrentPage())
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
    }
    
    @ViewBuilder
    var infoViewForCurrentPage: some View {
        MetadataView(metadata: viewModel.metadataForCurrentPage())
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
