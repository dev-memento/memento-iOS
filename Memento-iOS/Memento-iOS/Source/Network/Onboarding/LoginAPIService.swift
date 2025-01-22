//
//  LoginAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

protocol LoginAPIServiceProtocol {
    func login(provider: String, idToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void)
}

extension LoginAPIServiceProtocol {
    typealias LoginResponseDTO = BaseDTO<LoginResponseData>
    typealias NewAccessTokenDTO = BaseDTO<NewAccessTokenResponseData>
}

final class LoginAPIService: BaseAPIService, LoginAPIServiceProtocol {
    
    private let provider = MoyaProvider<LoginTargetType>(plugins: [MoyaPlugin.shared])
    
    /// 로그인 API 호출
    func login(provider: String, idToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void) {
        self.provider.request(.login(provider: provider, idToken: idToken)) { result in
            
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
                
            case .failure(let error):
                if let response = error.response, response.statusCode == 401 {
                    self.refreshAccessToken { success in
                        if success {
                            self.login(provider: provider, idToken: idToken, completion: completion)
                        } else {
                            print("토큰 갱신 실패")
                        }
                    }
                } else {
                    if let response = error.response {
                        let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                        completion(networkResult)
                    }
                }
            }
        }
        
    }
    
    /// Access Token 갱신
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        do {
            // Keychain에서 Refresh Token 로드
            guard let refreshToken = try TokenKeychainManager.shared.loadRefreshToken() else {
                print("리프레시 토큰 없음")
                completion(false)
                return
            }
            
            let refreshProvider = MoyaProvider<TokenRefreshType>() // Refresh 전용 provider
            
            // Refresh Token 요청
            refreshProvider.request(.refreshToken(refreshToken: refreshToken)) { result in
                switch result {
                case .success(let response):
                    do {
                        // 상태 코드 확인 및 데이터 처리
                        guard (200...299).contains(response.statusCode) else {
                            print("서버 응답 상태 코드 에러: \(response.statusCode)")
                            completion(false)
                            return
                        }
                        
                        // 응답 데이터 디코딩
                        let decodedResponse = try JSONDecoder().decode(NewAccessTokenDTO.self, from: response.data)
                        
                        // 새로운 Access Token 저장
                        try TokenKeychainManager.shared.saveAccessToken(decodedResponse.data.accessToken)
                        try TokenKeychainManager.shared.saveRefreshToken(decodedResponse.data.refreshToken)
                        
                        print("Access Token 갱신 성공")
                        completion(true)
                        
                    } catch {
                        // 디코딩 오류 처리
                        print("디코딩 실패: \(error.localizedDescription)")
                        completion(false)
                    }
                    
                case .failure(let error):
                    // 네트워크 오류 처리
                    print("네트워크 오류: \(error.localizedDescription)")
                    completion(false)
                }
            }
        } catch {
            // Keychain 에러 처리
            print("리프레시 토큰 로드 실패: \(error.localizedDescription)")
            completion(false)
        }
    }
}
