//
//  TagPickerSheet.swift
//  Memento-iOS
//
//  Created by RAFA on 3/25/25.
//

import SwiftUI

protocol TagSelectable: ObservableObject {
    var selectedTag: Tag { get set }
    var tagList: [Tag] { get }
}

struct TagPickerSheet<ViewModel: TagSelectable>: View {

    @ObservedObject var viewModel: ViewModel
    @Binding var isPresented: Bool

    let type: PickerButtonType

    var body: some View {
        SheetContainer(type: type) {
            SheetOKButton { isPresented = false }

            List {
                ForEach(viewModel.tagList) { tag in
                    Button(action: {
                        viewModel.selectedTag = tag
                    }) {
                        HStack {
                            Circle()
                                .fill(tag.color)
                                .frame(width: 12, height: 12)

                            Text(tag.title)
                                .applyFont(.body_r_14)
                                .foregroundStyle(isSelected(tag: tag) ? Color.gray02 : Color.gray07)

                            Spacer()
                        }
                    }
                    .listRowBackground(isSelected(tag: tag) ? Color.gray08 : Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .ignoresSafeArea()
            .padding([.horizontal, .bottom], 10)
            .scrollDisabled(viewModel.tagList.count <= 3)
        }
        .applyDynamicSheetForTagCount(tagList: viewModel.tagList)
    }

    private func isSelected(tag: Tag) -> Bool {
        viewModel.selectedTag.tagId == tag.tagId
    }
}
