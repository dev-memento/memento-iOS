//
//  AddEventTitleView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddEventTitleView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddEventTitleViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if viewModel.isTitleEmpty {
                    Text("Add your event")
                        .foregroundColor(.gray07)
                        .applyFont(.body_b_18)
                        .padding(.vertical, 11)
                }

                TextField("", text: $viewModel.title)
                    .tint(Color.mementoLightGreen)
                    .foregroundColor(.grayWhite)
                    .applyFont(.body_b_18)
                    .padding(.vertical, 11)
            }
            .frame(height: 27)
            .padding(.vertical, 11)

            Divider()
                .frame(height: 2)
                .background(Color.gray08)
                .padding(.bottom, 24)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray10
            .ignoresSafeArea()

        AddEventTitleView(viewModel: AddEventTitleViewModel())
    }
}
