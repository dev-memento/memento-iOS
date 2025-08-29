//
//  WindDownFooterView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/17/25.
//

import SwiftUI

struct WindDownFooterView: View {
    
    let windDownTime: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(.ic_winddown)
                .renderingMode(.template)
                .resizable()
                .frame(width: 17, height: 17)
                .foregroundStyle(Color.gray07)
            
            Text(windDownTime)
            
            Text(StringLiteral.Today.windDown)
            
            Spacer()
        }
        .applyFont(.detail_b_12)
        .foregroundColor(.gray07)
    }
}

#Preview {
    WindDownFooterView(windDownTime: "11 PM")
}
