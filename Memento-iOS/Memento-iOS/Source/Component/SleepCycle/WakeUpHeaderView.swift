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
        HStack(spacing: 6) {
            Image(.ic_wakeup)
                .renderingMode(.template)
                .resizable()
                .frame(width: 17, height: 17)
                .foregroundStyle(Color.gray07)
            
            Text(wakeUpTime)
            
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
