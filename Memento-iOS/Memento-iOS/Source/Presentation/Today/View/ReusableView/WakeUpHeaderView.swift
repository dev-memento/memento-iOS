//
//  WakeUpHeaderView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/17/25.
//

import SwiftUI

struct WakeUpHeaderView: View {
    
    let wakeUpTime: String
    
    var body: some View {
        HStack {
            Text(wakeUpTime)
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
    WakeUpHeaderView(wakeUpTime: "8 AM")
}
