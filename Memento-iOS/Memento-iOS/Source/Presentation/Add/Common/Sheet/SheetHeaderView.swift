//
//  SheetHeaderView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct SheetHeaderView: View {

    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button("OK", action: action)
                .applyFont(.body_r_14)
                .foregroundColor(Color.gray04)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.trailing, 22)
        }
    }
}
