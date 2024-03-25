//
//  MetadataView.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 25.03.2024.
//

import Foundation
import SwiftUI

struct MetadataView: View {
    struct Metadata {
        var name: String
        var descripiton: String
    }
    
    var metadata: [Metadata] = []
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(metadata.indices, id: \.self) { index in
                        let item = metadata[index]
                        VStack(alignment: .leading) {
                            Text("\(item.name):").font(.headline)
                            Text(item.descripiton).font(.body)
                        }
                        .tag(index)
                    }
                }
                Spacer(minLength: .zero)
            }
        }
    }
}

#Preview {
    MetadataView(metadata: [
        .init(name: "Title", descripiton: "test_audio"),
        .init(name: "Description", descripiton: "This is an audio file"),
        .init(name: "Date", descripiton: "25/03/2024 12:40:30")
    ])
}
