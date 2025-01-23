//
//  ColorTagView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct ColorTagView: View {
    var colorType: String
    
    var body: some View {
        Rectangle()
            .fill(Color.fromHex(colorType))
            .frame(width: 3)
    }
}
