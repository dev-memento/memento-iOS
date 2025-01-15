//
//  AllDayCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct AllDayCell: View {
    
    var colorType: String
    var title: String
    
    var body: some View {
        HStack(spacing: 26) {
            Rectangle()
                .fill(Color.distinguishColorType(colorType))
                .frame(width: 3)
            
            AllDayTitleLabel(title: title)
            
            Spacer()
        }
        .frame(height: 32)
        .background(Color.black)
    }
}

struct AllDayTitleLabel: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
