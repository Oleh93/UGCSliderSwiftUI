//
//  LinkPageView.swift
//  PageViewController
//
//  Created by Bohdan Revutskyy on 21.03.2024.
//

import Foundation
import SwiftUI

struct LinkPageView: View {
    var imageURL: String
    var audioURL: String
    
    var body: some View {
        VStack {
            ImagePageView(url: imageURL)
            AudioPageView(filename: audioURL)
        }
    }
}
