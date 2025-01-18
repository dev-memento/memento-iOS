//
//  BrainDumpView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/17/25.
//

import SwiftUI
import MDSKit

struct BrainDumpView: View {
    @State private var inputText: String = ""
    @State private var buttonTap: Bool = false
    
    
    let layout: [GridItem] = [
        GridItem(.flexible(maximum: 195))
    ]
    
    let titles : [String] = [
        "Schedule a brainstorming session for the marketing team.",
        "Prepare slides for next week’s meeting. The focus should be on highlighting key milestones and providing visuals for the timeline."]
    
    var body: some View {
        ZStack {
            BrainDumpBackgroundView()
            
            VStack {
                ZStack(alignment: .topLeading) {
                    // 배경
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.black) // 배경색
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 172)
                        .shadow(radius: 4) // 그림자 효과
                    
                    // 플레이스홀더
                    if inputText.isEmpty {
                        Text("Got plans? I’ll turn it into your to-do.")
                            .foregroundColor(.gray)
                            .applyFont(.body_b_16)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                    }
                    
                    // 텍스트 에디터
                    TextEditor(text: $inputText)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .foregroundColor(.white) // 입력 텍스트 색상
                        .background(Color.clear) // 배경 투명
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 172)
                        .scrollContentBackground(.hidden)
                }
                .frame(width: 343, height: 172) // 필드 크기
                .overlay {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: layout, spacing: 10) {
                            ForEach(titles, id: \.self) { item in
                                TitleCell(title: item)
                            }
                        }
                        .frame(height: 48)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    BrainDumpFooterView(buttonTap: $buttonTap)
                        .frame(height: 74)
                        .padding(.leading, 20)
                        .padding(.trailing, 26)
                }
            }
        }
    }
}

struct TitleCell: View {
    let title: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray07)
                .frame(width: 195, height: 48)
                .overlay {
                    Text(title)
                        .applyFont(.detail_r_12)
                        .font(.system(size: 14))
                        .foregroundColor(.gray06)
                        .lineLimit(2) // 최대 두 줄로 제한
                        .truncationMode(.tail) // ...으로 표시
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 10)
                }
        }
    }
}

struct BrainDumpFooterView: View {
    @Binding var buttonTap: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                print("Paste button tapped")
            }) {
                Text("Paste")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 143, height: 42)
                    .background(Color.gray08)
                    .clipShape(Capsule())
            }
            .frame(width: 143, height: 42)
            
            Spacer()
            
            Button {
                buttonTap.toggle()
            } label: {
                Image(buttonTap ? .btn_enter_active :  .btn_enter_disabled)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
            }
            
        }
    }
}


#Preview {
    BrainDumpView()
}
