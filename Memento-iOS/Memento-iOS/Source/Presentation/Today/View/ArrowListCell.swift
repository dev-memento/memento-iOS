//
//  ArrowListCell.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/17/25.
//

import SwiftUI

struct ArrowListCell<Content: View>: View {
    
    var isArrowHidden: Bool
    let content: () -> Content

    var body: some View {
        HStack {

            if !isArrowHidden {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
            }

            content()
        }
    }
}
