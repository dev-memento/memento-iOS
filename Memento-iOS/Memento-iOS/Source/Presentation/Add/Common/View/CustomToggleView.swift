//
//  CustomToggleView.swift
//  Memento-iOS
//
//  Created by RAFA on 3/25/25.
//

import SwiftUI

import MDSKit

struct CustomToggleView: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(StringLiteral.Common.toggleButtonTitle)
                .applyFont(.detail_b_10)
                .foregroundStyle(Color.gray07)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12)
                .fill(isOn ? Color.mainGreen : Color.gray08)
                .animation(.easeInOut(duration: 0.2), value: isOn)
                .frame(width: 40, height: 24)
                .overlay(
                    Circle()
                        .fill(Color.gray02)
                        .frame(width: 20, height: 20)
                        .offset(x: isOn ? 8 : -8)
                        .animation(.easeInOut(duration: 0.2), value: isOn)
                )
                .onTapGesture { isOn.toggle() }
        }
    }
}
