//
//  TagView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct TagView<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel

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
