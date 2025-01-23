//
//  TagListItem.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct TagListItem<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties

    let tag: Tag
    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        Button(action: {
            viewModel.updateSelectedTag(tag)
        }) {
            HStack {
                Circle()
                    .fill(tag.color)
                    .frame(width: 12, height: 12)

                Text(tag.title)
                    .applyFont(.body_r_14)
                    .foregroundColor(
                        viewModel.selectedTag.id == tag.id
                        ? .gray02
                        : .gray07
                    )

                Spacer()
            }
        }
    }
}
