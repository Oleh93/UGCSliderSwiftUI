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
        VStack(spacing: .zero) {
            PageView(
                state: state,
                currentIndex: $state.currentIndex,
                pages: $state.pages
            )
            ToolbarView(items: viewModel.toolBarItemsForCurrentPage())
        }
        .onChange(of: horizontalSizeClass, {
            print(horizontalSizeClass)
        })
        .background(.black)
        .environment(\.colorScheme, .dark)
        .sheet(isPresented: $state.isShowingInfoAlert) {
            ZStack {
                Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all)
                infoViewForCurrentPage
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .environment(\.colorScheme, .dark)
        }
        .alert(isPresented: $state.isShowingDeleteAlert) {
            deleteAlertForCurrentPage
        }
    }
    
    @ViewBuilder
    var infoViewForCurrentPage: some View {
        MetadataView(metadata: viewModel.metadataForCurrentPage())
            .padding(16)
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
