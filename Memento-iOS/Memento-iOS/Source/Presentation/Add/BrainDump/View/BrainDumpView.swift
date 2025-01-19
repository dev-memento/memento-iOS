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
            VStack() {
                ZStack(alignment: .topLeading) {
                    // 배경
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 172)
                        .shadow(radius: 4)
                    
                    if inputText.isEmpty {
                        Text("Got plans? I’ll turn it into your to-do.")
                            .foregroundStyle(LinearGradient.todoNow)
                            .applyFont(.body_b_16)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                    }

                    CustomTextEditor(text: $inputText)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .applyFont(.body_b_16)
                }
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 172)

                .overlay {
                    if buttonTap {
                        NeonAnimationView(
                            width: UIScreen.main.bounds.width * 0.95,
                            height: 172
                        )
                    }
                }
                BraindumpExampleTextScrollView(layout: layout, titles: titles)
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

struct BraindumpExampleTextScrollView: View {
    let layout: [GridItem]
    let titles: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: layout, spacing: 10) {
                ForEach(titles, id: \.self) { item in
                    BraindumpExampleTextCell(title: item)
                }
            }
            .frame(height: 48)
        }
    }
}

struct BraindumpExampleTextCell: View {
    let title: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(LinearGradient.brainDump)
                .frame(width: 195, height: 48)
                .overlay {
                    Text(title)
                        .applyFont(.detail_r_12)
                        .font(.system(size: 14))
                        .foregroundColor(.gray06)
                        .lineLimit(2)
                        .truncationMode(.tail)
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
