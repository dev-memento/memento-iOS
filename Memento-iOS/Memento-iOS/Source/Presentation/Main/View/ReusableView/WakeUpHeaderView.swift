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
                .padding(.trailing, 10)
            Text(StringLiteral.Today.wakeUp)
            Spacer()
        }
        .applyFont(.detail_b_12)
        .foregroundColor(.gray07)
    }
}

#Preview {
    WakeUpHeaderView(wakeUpTime: "8 AM")
}
