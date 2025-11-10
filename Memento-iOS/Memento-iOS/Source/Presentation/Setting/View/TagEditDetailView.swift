//
//  TagEditDetailView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/26/25.
//

import SwiftUI
import MDSKit

struct TagEditDetailView: View {
    
    @EnvironmentObject var viewModel: SettingViewModel
    
    @State var tag: TagItem
    @State private var originalTagId: Int?
    @State private var showDeleteAlert = false
    @State private var showDuplicateAlert = false
    @State private var alertMessage = ""
    
    let tagColors = [Color.mementoRed, Color.mementoPink, Color.mementoOrange, Color.mementoYellow, Color.mementoLightGreen, Color.mementoMint, Color.mementoCyan, Color.mementoBlue, Color.mementoPurple, Color.gray05]
    var isNew: Bool = false
    
    init(tag: TagItem?, isNew: Bool) {
        var initialTag = TagItem(
            title: "",
            color: .gray05,
            colorHex: "#A9ADBB",
            isChevronVisible: false
        )
        
        if let tagItem = tag, !isNew {
            let savedTags = TagManager.shared.getSavedTags()
            if let savedTag = savedTags.first(where: { $0.name == tagItem.title }) {
                initialTag = TagItem(
                    title: tagItem.title,
                    color: Color.fromHex(savedTag.colorCode),
                    colorHex: savedTag.colorCode,
                    isChevronVisible: false
                )
                self._originalTagId = State(initialValue: savedTag.id)
            }
        }
        
        self._tag = State(initialValue: initialTag)
        self.isNew = isNew
    }
    
    var body: some View {
        CustomNavigationBar(
            title: SettingsTagViewText.navigationTitle,
            showBackButton: true,
            showSkipButton: true,
            skipButtonTitle: "Done",
            backButtonAction: { viewModel.navigateBack() },
            skipButtonAction: { saveOrUpdateTag() }
        )
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(SettingsTagViewText.tagName)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray06)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                
                ZStack(alignment: .leading) {
                    if tag.title.isEmpty {
                        Text(SettingsTagViewText.enterTagName)
                            .foregroundColor(.gray07)
                            .applyFont(.body_r_14)
                    }
                    TextField("", text: $tag.title)
                        .tint(Color.mementoLightGreen)
                        .foregroundColor(.gray03)
                        .applyFont(.body_r_14)
                        .autocorrectionDisabled(true)
                }
                .padding(.top, 9)
                .padding(.horizontal, 16)
                .frame(height: 20)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray05)
                    .padding(.horizontal, 12)
                
                Text(SettingsTagViewText.color)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray06)
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 13) {
                    ForEach(tagColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Circle().strokeBorder(
                                    Color.white,
                                    lineWidth: tag.colorHex == colorToHex(color) ? 2 : 0
                                )
                            )
                            .onTapGesture {
                                tag.color = color
                                tag.colorHex = colorToHex(color)
                            }
                    }
                }
                .padding(.top, 14)
                .padding(.bottom, 24)
                .padding(.horizontal, 19)
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray10))
            .padding(.top, 26)
            .padding(.horizontal, 20)
            
            if !isNew {
                Button { showDeleteAlert = true } label: {
                    Text(SettingsTagViewText.deleteTag)
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.mementoRed)
                }
                .padding(.top, 20)
                .padding(.leading, 31)
            }
            
            Spacer()
        }
        .overlay(deleteAlertView)
        .overlay(duplicateAlertView)
    }
    
    @ViewBuilder
    private var deleteAlertView: some View {
        if showDeleteAlert {
            CustomAlertView(
                title: "Are you sure you want to delete this tag?",
                message: "If you delete it, associated items \nwill be moved to 'Untitled'.",
                cancelTitle: "Cancel",
                confirmTitle: "Delete",
                confirmAction: { showDeleteAlert = false; deleteTag() },
                cancelAction: { showDeleteAlert = false }
            )
            .padding(.horizontal, 32)
            .preferredColorScheme(.dark)
        }
    }
    
    @ViewBuilder
    private var duplicateAlertView: some View {
        if showDuplicateAlert {
            SingleButtonAlertView(
                title: "Tag name already exists.",
                buttonTitle: "OK",
                buttonAction: { showDuplicateAlert = false }
            )
            .padding(.horizontal, 32)
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveOrUpdateTag() {
        guard !tag.title.isEmpty else { return }
        
        let savedTags = TagManager.shared.getSavedTags()
        
        let isDuplicate = savedTags.contains { savedTag in
            savedTag.name == tag.title &&
            (!isNew ? savedTag.id != originalTagId : true)
        }
        
        if isDuplicate {
            showDuplicateAlert = true
            return
        }
        
        let request = TagPostRequest(name: tag.title, hexCode: tag.colorHex)
        
        if isNew {
            TagManager.shared.createAndSaveTag(request: request) { response in
                if response != nil {
                    print("태그 생성 성공")
                    DispatchQueue.main.async {
                        viewModel.navigateBack()
                    }
                } else {
                    DispatchQueue.main.async {
                        print("태그 생성 실패")
                    }
                }
            }
        } else {
            guard let tagId = originalTagId else { return }
            TagManager.shared.updateTag(tagId: tagId, request: request) { success in
                DispatchQueue.main.async {
                    if success {
                        print("태그 수정 성공")
                        viewModel.navigateBack()
                        alertMessage = "Tag updated successfully."
                    } else {
                        print("태그 수정 실패")
                        alertMessage = "Failed to update tag."
                    }
                }
            }
        }
    }
    
    private func deleteTag() {
        guard let tagId = originalTagId else { return }
        TagManager.shared.deleteTag(tagId: tagId) { success in
            DispatchQueue.main.async {
                if success {
                    print("태그 삭제 성공")
                    viewModel.navigateBack()
                } else {
                    print("태그 삭제 실패")
                }
            }
        }
    }
    
    private func colorToHex(_ color: Color) -> String {
        switch color {
        case .mementoRed: return "#FF426E"
        case .mementoPink: return "#EE8AAD"
        case .mementoOrange: return "#FF8162"
        case .mementoYellow: return "#FFE483"
        case .mementoLightGreen: return "#7BD27D"
        case .mementoMint: return "#149C95"
        case .mementoCyan: return "#6CA9E1"
        case .mementoBlue: return "#3867FF"
        case .mementoPurple: return "#7B5DFF"
        default: return "#A9ADBB"
        }
    }
}
