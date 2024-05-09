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
    @State private var showingSideDrawer = true
    
    var imageURL: String
    var audioURL: String
    
    var isDisplayedView: Bool
    var audioPageViewModel: AudioPageViewModel
    var sliderSize: CGSize
    
    init(imageURL: String, audioURL: String, audioPageViewModel: AudioPageViewModel, isDisplayedView: Bool, sliderSize: CGSize) {
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.isDisplayedView = isDisplayedView
        self.audioPageViewModel = audioPageViewModel
        self.sliderSize = sliderSize
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                ZStack {
                    ImagePageView(url: imageURL, sliderSize: sliderSize)
                    playAudioButton
                        .padding(.bottom, 64)
                        .padding(.trailing, 32)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .sheet(isPresented: $showingAudioDrawer) {
                    AudioPageView(isDisplayedView: isDisplayedView, viewModel: self.audioPageViewModel)
                        .presentationDetents([.height(200), .large])
                        .background(Color(.secondarySystemBackground))
                        .environment(\.colorScheme, .dark)
                }
                
            } else {
                ZStack {
                    HStack {
                        Spacer()
                        ImagePageView(url: imageURL, sliderSize: sliderSize)
                        Spacer()
                        if showingSideDrawer {
                            VStack {
                                HStack {
                                    Button { showingSideDrawer = false } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(Color(uiColor: .label))
                                    }
                                    .frame(width: 44, height: 44)
                                    Spacer()
                                }
                                AudioPageView(isDisplayedView: isDisplayedView, viewModel: self.audioPageViewModel)
                            }
                            .frame(width: 250, alignment: .trailing)
                            .background(Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all))
                        }
                    }
                    
                    if !showingSideDrawer {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                playAudioButton
                            }
                            .padding(.bottom, 64)
                            .padding(.trailing, 16)
                        }
                    }
                }
            }
        }
        .onChange(of: horizontalSizeClass) { horizontalSizeClass in
            if horizontalSizeClass == .compact && isDisplayedView {
                showingAudioDrawer = true
            } else {
                showingAudioDrawer = false
            }
            
            if horizontalSizeClass == .regular && isDisplayedView {
                showingSideDrawer = true
            } else {
                showingSideDrawer = false
            }
        }
    }
    
    var playAudioButton: some View {
        Button {
            if horizontalSizeClass == .compact {
                showingAudioDrawer = true
            } else {
                showingSideDrawer = true
            }
        } label: {
            Text("Play Audio")
                .foregroundColor(.black)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .tint(.white)
    }
}

#Preview {
    LinkPageView(imageURL: "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400", audioURL: "TestFile", audioPageViewModel: AudioPageViewModel(filename: audioName, name: "We are from Ukraine"), isDisplayedView: true, sliderSize: .zero)
}
