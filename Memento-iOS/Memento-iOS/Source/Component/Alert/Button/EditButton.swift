//
//  EditButton.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/21/25.
//

import SwiftUI

struct EditButton: View {
    
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: {
            onEdit()
        }) {
            VStack {
                Image(.ic_edit)
                Text(StringLiteral.Alert.edit)
                    .applyFont(.body_r_16)
            }
            .foregroundColor(.gray05)
            .padding()
            .frame(width: 140, height: 74)
            .background(Color.gray09)
            .cornerRadius(2)
        }
    }
}

struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
        EditButton(onEdit: {})
            .previewLayout(.sizeThatFits)
    }
}
