//
//  ColorTagView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct ColorTagView: View {
    
    var colorType: String
    var width: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.fromHex(colorType))
            .frame(width: CGFloat(width))
    }
}

struct ColorTagView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTagView(colorType: "#149C95", width: 5)
            .frame(height: 32)
            .previewLayout(.sizeThatFits)
    }
}
