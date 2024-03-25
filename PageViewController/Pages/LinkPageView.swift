//
//  LinkPageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI

struct LinkPageView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var showingAudioDrawer = false
    
    var imageURL: String
    var audioURL: String
    
    var isDisplayedView: Bool
    var audioPageViewModel: AudioPageViewModel
    
    init(imageURL: String, audioURL: String, audioPageViewModel: AudioPageViewModel, isDisplayedView: Bool) {
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.isDisplayedView = isDisplayedView
        self.audioPageViewModel = audioPageViewModel
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                ZStack {
                    ImagePageView(url: imageURL)
                    
                    Button {
                        showingAudioDrawer = true
                    } label: {
                        Text("Play Audio")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.bottom, 16)
                    .padding(.trailing, 32)
                }
                .sheet(isPresented: $showingAudioDrawer) {
                    AudioPageView(isDisplayedView: isDisplayedView, viewModel: self.audioPageViewModel)
                        .presentationDetents([.height(200), .large])
                        .background(Color(.secondarySystemBackground))
                        .environment(\.colorScheme, .dark)
                }
                
            } else {
                HStack {
                    Spacer()
                    ImagePageView(url: imageURL)
                    Spacer()
                    AudioPageView(isDisplayedView: isDisplayedView, viewModel: self.audioPageViewModel)
                        .frame(width: 250, alignment: .trailing)
                        .background(Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all))
                        
                }
            }
        }
        .onChange(of: horizontalSizeClass, {
            if horizontalSizeClass == .compact && isDisplayedView {
                showingAudioDrawer = true
            } else {
                showingAudioDrawer = false
            }
            print(showingAudioDrawer)
        })
    }
}

#Preview {
    LinkPageView(imageURL: "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400", audioURL: "TestFile", audioPageViewModel: AudioPageViewModel(filename: audioName, name: "We are from Ukraine"), isDisplayedView: true)
}
