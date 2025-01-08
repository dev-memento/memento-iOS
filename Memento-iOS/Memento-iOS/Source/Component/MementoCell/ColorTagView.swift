//
//  ColorTagView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

/// 일정  카테고리에 따른 좌측 색상 태그 View
struct ColorTagView: View {
    var colorType: String
    
    var body: some View {
        Rectangle()
            .fill(Color.distinguishColorType(colorType))
            .frame(width: 3)
    }
}
