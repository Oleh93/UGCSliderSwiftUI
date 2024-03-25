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
    
    var audioPageViewModel: AudioPageViewModel
    
    init(imageURL: String, audioURL: String) {
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.audioPageViewModel = AudioPageViewModel(filename: audioURL)
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
                    AudioPageView(viewModel: self.audioPageViewModel)
                        .presentationDetents([.medium, .large])
                        .background(Color(.systemGray))
                }
            } else {
                HStack {
                    Spacer()
                    ImagePageView(url: imageURL)
                    Spacer()
                    AudioPageView(viewModel: self.audioPageViewModel)
                        .frame(width: 250, alignment: .trailing)
                        .background(Color(.systemGray))
                }
            }
        }
        .onChange(of: horizontalSizeClass, {
            if horizontalSizeClass == .compact {
                showingAudioDrawer = true
            } else {
                showingAudioDrawer = false
            }
            print(showingAudioDrawer)
        })
    }
}

#Preview {
    LinkPageView(imageURL: "https://mediasvc.ancestrystage.com/v2/image/namespaces/1093/media/4cc0bbbd-b908-4105-b198-17c3de9e50c6.jpg?Client=AncestryIOS&MaxSide=400", audioURL: "TestFile")
}
