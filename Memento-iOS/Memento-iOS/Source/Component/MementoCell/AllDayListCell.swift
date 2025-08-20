//
//  AllDayListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import SwiftUI

struct AllDayListCell: View {

    var tagColorCode: String
    var title: String
    
    var body: some View {
        HStack(spacing: 21) {
            ColorTagView(colorType: tagColorCode, width: 5)
            
            AllDayTitleView(title: title)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 32)
        .background(Color.mainNavy)
    }
}

struct AllDayTitleView: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .applyFont(.body_r_14)
            .foregroundColor(.gray05)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AllDayListCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 3) {
            AllDayListCell(tagColorCode: "#FF426E", title: "여행")
            AllDayListCell(tagColorCode: "#FF8162", title: "테니스")
        }
        .previewLayout(.sizeThatFits)
    }
}
