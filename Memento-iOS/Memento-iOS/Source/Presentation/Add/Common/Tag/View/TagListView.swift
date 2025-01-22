//
//  TagListView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct TagListView<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        List {
            ForEach(Tag.mockData) { tag in
                TagListItem(tag: tag, viewModel: viewModel)
                    .listRowBackground(
                        viewModel.selectedTag.id == tag.id
                        ? Color.gray08
                        : Color.clear
                    )
            }
        }
        .listStyle(PlainListStyle())
        .ignoresSafeArea()
        .padding([.horizontal, .bottom], 10)
        .scrollDisabled(Tag.mockData.count <= 4)
    }
}
