//
//  DeleteActionSheetView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/18/25.
//

import SwiftUI

struct DeleteActionSheetView: View {
    
    @State private var isActionSheetShow = false

    var body: some View {
        VStack {
            Button("Show Action Sheet") {
                isActionSheetShow = true
            }
            .confirmationDialog(
                "Do you really want to delete this event? \nThis is a repeating event.",
                isPresented: $isActionSheetShow,
                titleVisibility: .visible
            ) {
                Button("Delete This Event Only", role: .destructive) {
                    print("일정 삭제 단일")
                }
                Button("Delete All Upcoming Events", role: .destructive) {
                    print("일정 삭제 다중")
                }
                Button("Cancel", role: .cancel) {
                    print("취소")
                }
            }
        }
    }
}

struct ActionSheetExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteActionSheetView()
    }
}
