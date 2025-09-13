//
//  CustomAlertView.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/29/25.
//

import SwiftUI
import MDSKit

struct CustomAlertView: View {
    let title: String
    let message: String?
    let cancelTitle: String
    let confirmTitle: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(title)
                .applyFont(.body_r_14)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            if let message = message {
                Text(message)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray07)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 8) {
                Button(action: cancelAction) {
                    Text(cancelTitle)
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray03)
                        .frame(width: 137, height: 36)
                        .background(Color.gray08)
                        .cornerRadius(4)
                }
                
                Button(action: confirmAction) {
                    Text(confirmTitle)
                        .applyFont(.body_r_14)
                        .foregroundColor(.grayBlack)
                        .frame(width: 137, height: 36)
                        .background(Color.mementoRed)
                        .cornerRadius(4)
                }
            }
        }
        .padding(EdgeInsets(top: 28, leading: 14, bottom: 14, trailing: 14))
        .background(Color.gray09)
        .cornerRadius(4)
    }
}

#Preview("Delete Item") {
    CustomAlertView(
        title: "Do you really want to delete?",
        message: nil,
        cancelTitle: "Cancel",
        confirmTitle: "Delete",
        confirmAction: { print("삭제 실행") },
        cancelAction: { print("취소") }
    )
    .preferredColorScheme(.dark)
    .background(Color.white)
}

#Preview("Delete Account") {
    CustomAlertView(
        title: "Would you like to delete account?",
        message: "Permanently delete the account and remove access from all workspaces.",
        cancelTitle: "Cancel",
        confirmTitle: "Delete account",
        confirmAction: { print("계정 삭제 실행") },
        cancelAction: { print("취소") }
    )
    .preferredColorScheme(.dark)
    .background(Color.white)
}

#Preview("With Long Message") {
    CustomAlertView(
        title: "Delete workspace?",
        message: "Deleting this workspace will remove all members, data, and related resources. This action cannot be undone.",
        cancelTitle: "Cancel",
        confirmTitle: "Confirm",
        confirmAction: { print("워크스페이스 삭제") },
        cancelAction: { print("취소") }
    )
    .preferredColorScheme(.dark)
    .background(Color.white)
}
