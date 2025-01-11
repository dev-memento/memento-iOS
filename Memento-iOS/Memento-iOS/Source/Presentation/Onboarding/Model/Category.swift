//
//  Category.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import Foundation

struct Category: Identifiable {
    let id = UUID() // 고유 ID
    let name: String // 카테고리 이름
    
    // 전역 목업 데이터
    static let mockData: [Category] = [
        Category(name: "Technology & IT"),
        Category(name: "Data & Analytics"),
        Category(name: "Design & Creativity"),
        Category(name: "Business & Management"),
        Category(name: "Education & Training"),
        Category(name: "Healthcare & Wellness"),
        Category(name: "Freelance & Self-Employment"),
        Category(name: "Service & Hospitality"),
        Category(name: "Engineering & Manufacturing")
    ]
}
