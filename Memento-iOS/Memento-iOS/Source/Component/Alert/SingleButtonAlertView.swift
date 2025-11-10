//
//  SingleButtonAlertView.swift
//  Memento-iOS
//
//  Created by 이세민 on 11/11/25.
//

import SwiftUI
import MDSKit

struct SingleButtonAlertView: View {
    let title: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 29) {
            Text(title)
                .applyFont(.body_r_14)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray03)
                    .frame(maxWidth: 137, minHeight: 36)
                    .background(Color.gray08)
                    .cornerRadius(4)
            }
        }
        .padding(EdgeInsets(top: 28, leading: 70, bottom: 14, trailing: 70))
        .background(Color.gray09)
        .cornerRadius(4)
    }
}
