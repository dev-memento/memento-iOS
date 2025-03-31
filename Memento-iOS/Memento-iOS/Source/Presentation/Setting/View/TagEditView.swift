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
    let categories: [TagItem] = [
        TagItem(title: "Untitled", color: Color.gray05, isChevronVisible: false),
        TagItem(title: "Family", color: Color.mementoRed, isChevronVisible: true),
        TagItem(title: "Hobby", color: Color.mementoOrange, isChevronVisible: true),
        TagItem(title: "Self-Development", color: Color.mementoMint, isChevronVisible: true),
        TagItem(title: "Work", color: Color.mementoCyan, isChevronVisible: true),
        TagItem(title: "Personal", color: Color.mementoBlue, isChevronVisible: true),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            CustomNavigationBar(
                title: SettingsTagViewText.navigationTitle,
                showBackButton: true,
                showSkipButton: false,
                backButtonAction: {
                    viewModel.navigateBack()
                }
            )
            .padding(.top, 25)
            
            VStack(spacing: 6) {
                ForEach(categories) { item in
                    Button {
                        viewModel.navigateToNext(.TagDetail(item, item.isChevronVisible))
                    } label: {
                        CategoryRowView(item: item)
                    }
                }

                Button(action: {
                    viewModel.navigateToNext(.TagDetail(nil, false))
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
