//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagePageView: View {
    var url: String
    @State private var scale: CGFloat = 1.0
    @State private var loadingFailed: Bool = false
    
    var body: some View {
        Group {
            if loadingFailed {
                errorView
            } else {
                image(from: url)
            }
        }
    }
    
    private func image(from url: String) -> some View {
        WebImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView {
                Text("Loading...")
                    .font(.headline)
            }
        }
        .onFailure { _ in
            self.loadingFailed = true
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
            Text("The server is currently unavailable. Please check your internet connection or try again later")
                .font(.title)
        }
        .padding(20)
    }
}

struct ImagePageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePageView(url: "https://mediasvc.ancestry.com/v2/image/namespaces/1093/media/70fc088a-bc84-42b9-8828-5d685cc89924.jpg?Client=AncestryIOS&MaxSide=1200")
    }
}

