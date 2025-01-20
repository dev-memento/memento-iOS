//
//  MoyaPlugin.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/19/25.
//

import Foundation

import Moya

final class MoyaPlugin: PluginType {
    
    static let shared = MoyaPlugin()
    
    private init() {}
    
    // MARK: - Request 보낼 시 호출
    
    func willSend(_ request: RequestType, target: TargetType) {
        
        guard let httpRequest = request.request else {
            print("==> ❌🤖❌유효하지 않은 요청❌🤖❌")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "=======================================================\n🤖1️⃣🤖[\(method)] \(url)\n=======================================================\n"
        
        log.append("\n")
        log.append("🤖2️⃣🤖 API: \(target)\n")
        
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("✏️ header:\n\(headers)\n")
        }
        
        if let body = httpRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            log.append("✏️ body:\n\(bodyString)\n")
        } else {
            log.append("✏️ body: Unable to decode body\n")
        }
    
        log.append("=========================== 🤖END \(method)🤖============================\n")
        print(log)
    }
    
    // MARK: - Response 받을 시 호출
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            self.onSucceed(response)
        case let .failure(error):
            self.onFail(error)
        }
    }
    
    func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        var log = "🤖[RESULT] =============================================\n"
        log.append("🤖3️⃣🤖 [\(statusCode)] \(url)\n==============================================\n")
        
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\n🤖4️⃣🤖 \(reString)\n")
        }
        log.append("=============================================[END HTTP]🤖\n")
        print(log)
    }
    
    func onFail(_ error: MoyaError) {
        if let response = error.response {
            onSucceed(response)
            return
        }
        
        let errorCode = error.errorCode
        let errorMessage = mapErrorCodeToMessage(errorCode)
        
        var log = "❌🤖❌네트워크 오류❌🤖❌"
        
        log.append("<== ERROR CODE: \(errorCode)\n")
        log.append("<== \(errorMessage)\n")
        log.append("<== END HTTP 🤖🤖🤖")
        print(log)
    }
    
    // 에러 코드에 따른 메시지 매핑 함수
    func mapErrorCodeToMessage(_ code: Int) -> String {
        switch code {
        case -1009: return "🤖🔥 Internet connection is lost 🔥🤖"      // 인터넷 연결 끊어짐
        case -1001: return "🤖🔥request timed out🔥🤖"                  // 요청 시간 초과
        case -1004: return "🤖🔥Server connection failure🔥🤖"          // 서버 연결 실패
        case 401: return "🤖🔥Certification expires🔥🤖"                // 인증 만료 (재로그인 필요)
        case 403: return "🤖🔥No permission🔥🤖"                        // 권한 없음
        default: return "🤖🔥unknown network error [CODE: \(code)]🔥🤖"  // 알 수 없는 오류
        }
    }
}
