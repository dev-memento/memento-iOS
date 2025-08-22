//
//  BaseTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/19/25.
//

import Foundation

import Moya

typealias MoyaRequestTask = Moya.Task

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case todo = "/v1/todos"
    case tag = "/v1/tags"
    case schedule = "/v1/schedules"
    case user = "/v1/members"
    case health = "/health"
}

enum HeaderType {
    case tokenHeader    // Access 토큰 필요
    case noTokenHeader           // 토큰 불필요 (로그인/회원가입/헬스체크 등)
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var utilPath: UtilPath { get }
    var pathParameter: String? { get }
    var queryParameter: [String: Any]? { get }
    var requestBodyParameter: Codable? { get }
}

extension BaseTargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🤖⛔️ Base URL이 없어요! ⛔️🤖")
        }
        return baseURL
    }
    
    var headers: [String: String]? {
        var header: [String: String] = ["Content-Type": "application/json"]
        return header
    }
    
    var task: MoyaRequestTask {
        if let queryParameter {
            return .requestParameters(parameters: queryParameter, encoding: URLEncoding.default)
        }
        if let requestBodyParameter {
            return .requestJSONEncodable(requestBodyParameter)
        }
        return .requestPlain
    }
    
    /// 서버가 200~299 상태코드로 응답했을 때만 성공으로 처리하고, 나머지(400, 401, 500 등)는 자동으로 실패
    /// 인터셉터(TokenRefreshPlugin)가 동작하려면 요청이 실패했을 때 에러(MoyaError) 로 전달되어야 함
    /// 그래야 401을 잡고 → 리프레시 요청 → 토큰 갱신 → 재시도 순서가 가능
    var validationType: ValidationType { .successCodes }
}
