//
//  TagListItem.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct TagListItem: View {

    // MARK: - Properties

    let tag: Tag
    @ObservedObject var viewModel: AddTodoViewModel

    // MARK: - Body

    var body: some View {
        Button(action: {
            viewModel.selectedTag = tag
        }) {
            HStack {
                Circle()
                    .fill(tag.color)
                    .frame(width: 12, height: 12)

                Text(tag.title)
                    .applyFont(.body_r_14)
                    .foregroundStyle(
                        viewModel.selectedTag.id == tag.id ? Color.gray02 : .gray07
                    )

                Spacer()
            }
        }
    }
}
