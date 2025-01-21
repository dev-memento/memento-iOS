//
//  NetworkResult.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/19/25.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T?)
    
    case networkFail        // 네트워크 연결 실패했을 때
    case decodeError        // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
    
    case badRequest         // 400 유효하지 않은 헤더
    case unAuthorized       // 401 유효하지 않은 토큰
    case notFound           // 404 ~ 에 대한 정보가 없음
    case methodNotAllowed   // 405 지원하지 않는 HTTP 메소드
    case conflict           // 409 이미 등록된 데이터
    case serverError        // 500 서버 내부 오류
    
    case pathError
    
    var stateDescription: String {
        switch self {
        case .success: return "🤖🔥 SUCCESS 🔥🤖"
            
        case .networkFail: return "🤖🔥 NETWORK FAIL 🔥🤖"
        case .decodeError: return "🤖🔥 DECODED_ERROR 🔥🤖"
            
        case .badRequest: return "🤖🔥 400 : BAD REQUEST EXCEPTION 🔥🤖"
        case .unAuthorized: return "🤖🔥 401 : UNAUTHORIZED EXCEPTION 🔥🤖"
        case .notFound: return "🤖🔥 404 : NOT FOUND 🔥🤖"
        case .methodNotAllowed: return "🤖🔥 405 : METHOD NOT ALLOWED 🔥🤖"
        case .conflict: return "🤖🔥 409 : CONFLICT 🔥🤖"
        case .serverError: return "🤖🔥 500 : INTERNAL SERVER_ERROR 🔥🤖"
        case .pathError: return "🤖🔥 PATH ERROR 🔥🤖"
        }
    }
}
