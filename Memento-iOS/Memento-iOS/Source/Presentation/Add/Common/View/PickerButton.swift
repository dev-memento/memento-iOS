//
//  PickerButton.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/20/25.
//

import SwiftUI

struct PickerButton: View {
    
    let label: String
    @Binding var isPresented: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            Text(label)
                .applyFont(.body_r_14)
                .foregroundColor(.gray02)
                .padding(.horizontal, 22)
                .padding(.vertical, 8)
                .background(isPresented ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
        }
    }
}
