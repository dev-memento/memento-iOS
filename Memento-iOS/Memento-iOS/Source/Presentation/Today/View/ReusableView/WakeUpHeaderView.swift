//
//  WakeUpHeaderView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/17/25.
//

import SwiftUI

struct WakeUpHeaderView: View {
    var body: some View {
        HStack {
            Text("8 AM")
                .applyFont(.detail_b_12)
                .foregroundColor(.gray07)
            Text("Wake up")
                .applyFont(.detail_b_12)
                .foregroundColor(.gray07)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WakeUpHeaderView()
}
