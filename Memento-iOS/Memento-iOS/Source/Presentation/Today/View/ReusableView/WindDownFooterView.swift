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
        HStack {
            Text(windDownTime)
                .padding(.trailing, 10)
            Text(StringLiteral.Today.windDown)
            
            Spacer()
        }
        .applyFont(.detail_b_12)
        .foregroundColor(.gray07)
        .padding()
    }
}

#Preview {
    WindDownFooterView(windDownTime: "11 PM")
}
