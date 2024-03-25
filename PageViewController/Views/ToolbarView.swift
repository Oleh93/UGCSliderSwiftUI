//
//  ToolbarView.swift
//  PageViewController
//
//  Created by Oleh Mykytyn on 22.03.2024.
//

import Foundation
import SwiftUI

struct ToolbarView: View {
    
    struct ToolBarItemConfig {
        var image: Image
        var action: () -> Void
    }
    
    var items: [ToolBarItemConfig]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: items[index].action) {
                    items[index].image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                }
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.secondarySystemBackground))
    }
}
