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
    let tagColors = [Color.mementoRed, Color.mementoPink, Color.mementoOrange, Color.mementoYellow, Color.mementoLightGreen, Color.mementoMint, Color.mementoCyan, Color.mementoBlue, Color.mementoPurple, Color.gray10]
    var isNew: Bool = false
    
    init(tag: TagItem?, isNew: Bool) {
        self._tag = State(initialValue: tag ?? TagItem(title: "", color: .gray05, isChevronVisible: false))
        self.isNew = isNew
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                CustomNavigationBar(
                    title: "Tag",
                    showBackButton: true,
                    showSkipButton: false,
                    backButtonAction: {
                        viewModel.navigateBack()
                    }
                )
                .padding(.top, 25)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Tag name")
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray06)
                    
                    TextField("Enter tag name", text: $tag.title)
                        .padding(.vertical, 8)
                        .overlay(Rectangle().frame(height: 1).offset(y: 10).foregroundColor(.gray08))
                    
                    Text("Color")
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray06)
                        .padding(.top, 30)
                    
                    HStack(spacing: 13) {
                        ForEach(tagColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 18, height: 18)
                                .overlay(
                                    Circle().strokeBorder(Color.white, lineWidth: tag.color == color ? 2 : 0)
                                )
                                .onTapGesture {
                                    tag.color = color
                                }
                        }
                    }
                    .padding(.top, 14)
                }
                .padding(.top, 25)
                .padding(.bottom, 24)
                .padding(.leading, 12)
                .padding(.trailing, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray10)
                )
                .padding(.horizontal, 16)
                
                // ✅ 아래 Delete 버튼은 바깥에 따로
                if isNew {
                    Button {
                        // Action
                        
                    } label: {
                        Text("Delete tag")
                            .applyFont(.body_r_14)
                            .foregroundColor(Color.mementoRed)
                        
                    }
                    .padding(.top, 20)
                    .padding(.leading, 16)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TagEditDetailView(
        tag: TagItem(title: "Work", color: .mementoRed, isChevronVisible: true),
        isNew: false
    )
}

