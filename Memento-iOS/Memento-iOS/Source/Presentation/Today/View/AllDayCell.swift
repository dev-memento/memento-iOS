//
//  AllDayCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct AllDayCell: View {

    var body: some View {
        HStack(spacing: 26) {
            Rectangle()
                .fill(Color.distinguishColorType("red"))
                .frame(width: 3)
            
            Text("박익범 가정방문 어쩌고")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .frame(height: 32)
        .background(Color.black)
    }
}


struct ScheduleCellData {
    let colorType: String
    let text: String
}
