//
//  ImagePageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI

struct ImagePageView: View {
    var url: String
    
    var body: some View {
        
        AsyncImage(
            url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Text("Loading ...")
            }
    }
}
