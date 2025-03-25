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
        Toggle(isOn: $isOn) {
            Text(StringLiteral.Common.toggleButtonTitle)
                .applyFont(.detail_b_10)
                .foregroundStyle(Color.gray07)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .toggleStyle(CustomToggleStyle())
    }
}
