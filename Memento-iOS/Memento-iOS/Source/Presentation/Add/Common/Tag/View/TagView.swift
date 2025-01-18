//
//  TagView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct TagView: View {

    // MARK: - Properties

    @StateObject private var viewModel = PickerButtonViewModel(type: .tag)

    // MARK: - Body

    var body: some View {
        HStack {
            Text("Tag")
                .applyFont(.body_r_16)
                .foregroundStyle(Color.gray05)

            Spacer()

            TagPickerSheetView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray10
            .ignoresSafeArea()

        TagView()
    }
}
