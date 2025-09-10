//
//  FloatingButton.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/24/25.
//

import SwiftUI

struct FloatingButton: View {
    
    @Binding var floatingButtonPressed: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 52, height: 52)
                        .foregroundColor(floatingButtonPressed ? Color.mainGreen : Color.gray09)
                    
                    Button {
                        floatingButtonPressed.toggle()
                    } label: {
                        Image(.ic_prio)
                            .renderingMode(.template)
                            .foregroundColor(floatingButtonPressed ? .grayBlack : .grayWhite)
                    }
                }
                .padding(20)
            }
        }
    }
}
