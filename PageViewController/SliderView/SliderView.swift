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
        GeometryReader { geometry in
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
                    infoSideViewForCurrentPage
                }
            }
            .onAppear {
                setSliderSize(viewSize: geometry.size, safeAreaInsets: geometry.safeAreaInsets)
            }
            .readSize { size in
                setSliderSize(viewSize: size, safeAreaInsets: geometry.safeAreaInsets)
            }
        }
        .onChange(of: horizontalSizeClass) { horizontalSizeClass in
            viewModel.didChangeHorizontalSizeClass(horizontalSizeClass)
        }
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
        .onAppear(perform: {
            viewModel.didChangeHorizontalSizeClass(horizontalSizeClass)
        })
        .animation(.easeInOut, value: state.isShowingInfoSideView)
    }
    
    func setSliderSize(viewSize: CGSize, safeAreaInsets: EdgeInsets) {
        let width = viewSize.width - safeAreaInsets.leading - safeAreaInsets.trailing
        let height = viewSize.height - safeAreaInsets.top - safeAreaInsets.bottom
        state.sliderSize = CGSize(width: width, height: height)
    }

    @ViewBuilder
    var infoViewForCurrentPage: some View {
        MetadataView(metadata: viewModel.metadataForCurrentPage())
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
    
    @ViewBuilder
    var infoSideViewForCurrentPage: some View {
        VStack {
            HStack {
                Button { viewModel.didTapInfoViewCloseButton() } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(uiColor: .label))
                }
                .frame(width: 44, height: 44)
                Spacer()
            }
            infoViewForCurrentPage
        }
        .frame(width: 250)
        .background(Color(.secondarySystemBackground))
        .transition(.move(edge: .trailing))
    }
}

#Preview {
    SliderView(viewModel: .init())
}
