//
//  RoundedCorner.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/26/25.
//

import SwiftUI

/// 특정 모서리에만 둥근 처리를 할 수 있도록 도와주는 Shape
///
/// SwiftUI의 `cornerRadius`는 모든 모서리에만 적용되기 때문에,
/// 특정 모서리만 둥글게 하고 싶을 때 이 커스텀 Shape을 사용합니다.
///
/// ```swift
/// RoundedCorner(radius: 10, corners: [.topLeft, .bottomRight])
///     .fill(Color.red)
///     .frame(width: 100, height: 50)
/// ```
///
/// - Parameters:
///   - radius: 적용할 라운드 반지름
///   - corners: 둥글게 만들 모서리 (예: [.topLeft, .bottomLeft])
///
struct RoundedCorner: Shape {
    
    /// 둥글게 줄 반지름
    var radius: CGFloat
    
    /// 둥글게 적용할 모서리
    var corners: UIRectCorner

    /// 실제 라운드 모서리 경로를 그리는 함수
    /// - Parameter rect: 현재 뷰의 프레임
    /// - Returns: 둥근 모서리가 적용된 경로(Path)
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft])
        .frame(width: 50, height: 50)
}
