//
//  TagPickerSheet.swift
//  Memento-iOS
//
//  Created by RAFA on 3/25/25.
//

import SwiftUI

protocol TagSelectable: ObservableObject {
    var selectedTag: Tag { get set }
}

struct TagPickerSheet<ViewModel: TagSelectable>: View {

    @ObservedObject var viewModel: ViewModel
    @Binding var isPresented: Bool

    let type: PickerButtonType
    let tagList: [Tag]

    var body: some View {
        SheetContainer(type: type) {
            SheetOKButton { isPresented = false }

            List {
                ForEach(tagList) { tag in
                    Button(action: {
                        viewModel.selectedTag = tag
                    }) {
                        HStack {
                            Circle()
                                .fill(tag.color)
                                .frame(width: 12, height: 12)

                            Text(tag.title)
                                .applyFont(.body_r_14)
                                .foregroundStyle(viewModel.selectedTag.id == tag.id ? Color.gray02 : Color.gray07)

                            Spacer()
                        }
                    }
                    .listRowBackground(viewModel.selectedTag.tagId == tag.tagId ? Color.gray08 : Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .ignoresSafeArea()
            .padding([.horizontal, .bottom], 10)
            .scrollDisabled(tagList.count <= 3)
        }
        .applyDynamicSheetForTagCount()
    }
}
