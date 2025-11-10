//
//  TagEditView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/25/25.
//

import SwiftUI
import MDSKit
        
struct TagEditView: View {
    
    @EnvironmentObject var viewModel: SettingViewModel
    @State private var savedTags: [TagResponse] = []
    
    var body: some View {
        CustomNavigationBar(
            title: SettingsTagViewText.navigationTitle,
            showBackButton: true,
            showSkipButton: false,
            backButtonAction: {
                viewModel.navigateBack()
            }
        )
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 6) {
                // default라서 버튼 제거 
                CategoryRowView(
                    item: TagItem(
                        title: "Untitled",
                        color: Color.fromHex("#A9ADBB"),
                        colorHex: "#A9ADBB",
                        isChevronVisible: false
                    )
                )
                
                // 기존 저장된 태그들 (Untitled 제외)
                ForEach(savedTags.filter { $0.name != "Untitled" }, id: \.id) { tag in
                    let tagItem = TagItem(
                        title: tag.name,
                        color: Color.fromHex(tag.colorCode),
                        colorHex: tag.colorCode,
                        isChevronVisible: true
                    )
                    
                    Button {
                        viewModel.navigateToNext(.TagDetail(tagItem, false))
                    } label: {
                        CategoryRowView(item: tagItem)
                    }
                }

                Button(action: {
                    viewModel.navigateToNext(.TagDetail(nil, true))
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.gray05)
                            .padding(.leading, 10)
                        
                        Text(SettingsTagViewText.add)
                            .foregroundColor(.gray05)
                            .applyFont(.body_r_14)
                        
                        Spacer()
                    }
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray10)
                    .cornerRadius(4)
                }
                
                Spacer()
            }
            .padding(.top, 26)
            .padding(.horizontal, 16)
        }
        .onAppear {
            loadSavedTags()
        }
    }

    private func loadSavedTags() {
        savedTags = TagManager.shared.getSavedTags()
        print("로컬에서 로드된 태그: \(savedTags.count)개")
    }
}

struct CategoryRowView: View {
    let item: TagItem
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray10)
            
            RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft])
                .fill(item.color)
                .frame(width: 8)
        }
        .overlay(
            HStack {
                Spacer().frame(width: 12)
                Text(item.title)
                    .applyFont(.body_r_14)
                    .foregroundColor(.gray05)
                
                Spacer()
                
                if item.isChevronVisible {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray07)
                }
            }
            .padding(.horizontal, 12)
        )
        .frame(height: 36)
    }
}

#Preview {
    TagEditView()
}
