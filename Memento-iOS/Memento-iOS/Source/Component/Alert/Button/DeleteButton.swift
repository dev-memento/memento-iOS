//
//  DeleteButton.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/21/25.
//

import SwiftUI

struct DeleteButton: View {
    
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: {
            onDelete()
        }) {
            VStack {
                Image(.ic_delete)
                Text(StringLiteral.Alert.delete)
                    .applyFont(.body_r_16)
            }
            .foregroundColor(.mementoRed)
            .padding()
            .frame(width: 140, height: 74)
            .background(Color.labelImmediate15)
            .cornerRadius(2)
        }
    }
}
