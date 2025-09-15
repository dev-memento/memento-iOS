//
//  EmptyView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct EmptyView: View {
    
    var body: some View {
        Text("No plans yet? Add one now!")
            .applyFont(.title_b_22)
            .foregroundColor(.gray08)
            .padding(.horizontal, 48)
    }
}
