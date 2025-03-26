//
//  RoundedCorner.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/26/25.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat               // 둥글게 줄 반지름
    var corners: UIRectCorner         // 어떤 모서리에 줄지 설정 (좌상, 우하 등)

    func path(in rect: CGRect) -> Path {
        // UIBezierPath: UIKit의 경로 그리기 도구
        let path = UIBezierPath(
            roundedRect: rect,                  // 현재 뷰의 크기
            byRoundingCorners: corners,         // 라운드를 줄 모서리들
            cornerRadii: CGSize(width: radius, height: radius) // 라운드 크기
        )
        return Path(path.cgPath) // SwiftUI가 이해할 수 있는 Path로 변환
    }
}


#Preview {
    RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft])
        .frame(width: 50, height: 50)
}
