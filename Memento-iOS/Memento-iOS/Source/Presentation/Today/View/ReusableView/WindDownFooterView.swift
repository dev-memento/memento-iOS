//
//  WindDownFooterView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/17/25.
//

import SwiftUI

struct WindDownFooterView: View {
    var body: some View {
        HStack {
            Text("11 PM")
                .applyFont(.detail_b_12)
                .foregroundColor(.gray07)
                .padding(.trailing, 10)
            Text("Wind down")
                .applyFont(.detail_b_12)
                .foregroundColor(.gray07)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WindDownFooterView()
}
