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
    let width: CGFloat
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(label)
                .applyFont(.body_r_14)
                .foregroundColor(.gray02)
                .padding(.vertical, 8)
                .frame(width: width)
                .background(isPresented ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
        }
    }
}

struct PickerButton_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        HStack(spacing: 10) {
            PickerButton(
                label: "Aug 21, 2025",
                isPresented: $isPresented,
                onTap: { isPresented.toggle() },
                width: 124
            )
            
            PickerButton(
                label: "4:00 AM",
                isPresented: $isPresented,
                onTap: { isPresented.toggle() },
                width: 96
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
