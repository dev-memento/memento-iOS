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


//MARK: 서버에서 요구하는 문자열로 변환 하는 로직
enum CategoryType: String {
    case technology = "TECHNOLOGY"
    case dataAnalytics = "DATA_ANALYTICS"
    case designCreativity = "DESIGN_CREATIVITY"
    case businessManagement = "BUSINESS_MANAGEMENT"
    case educationTraining = "EDUCATION_TRAINING"
    case healthcareWellness = "HEALTHCARE_WELLNESS"
    case freelance = "FREELANCE_SELF_EMPLOYMENT"
    case serviceHospitality = "SERVICE_HOSPITALITY"
    case engineeringManufacturing = "ENGINEERING_MANUFACTURING"
    case other = "OTHER"

    static func from(name: String) -> String {
        switch name {
        case "Technology & IT": return CategoryType.technology.rawValue
        case "Data & Analytics": return CategoryType.dataAnalytics.rawValue
        case "Design & Creativity": return CategoryType.designCreativity.rawValue
        case "Business & Management": return CategoryType.businessManagement.rawValue
        case "Education & Training": return CategoryType.educationTraining.rawValue
        case "Healthcare & Wellness": return CategoryType.healthcareWellness.rawValue
        case "Freelance & Self-Employment": return CategoryType.freelance.rawValue
        case "Service & Hospitality": return CategoryType.serviceHospitality.rawValue
        case "Engineering & Manufacturing": return CategoryType.engineeringManufacturing.rawValue
        default: return CategoryType.other.rawValue
        }
    }
}
