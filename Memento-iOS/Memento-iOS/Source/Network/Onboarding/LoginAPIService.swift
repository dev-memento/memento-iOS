//
//  LoginAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

// MARK: - LoginAPIServiceProtocol

protocol LoginAPIServiceProtocol {
    func login(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void)
}

extension LoginAPIServiceProtocol {
    typealias LoginResponseDTO = BaseDTO<LoginResponseData>
}

// MARK: - LoginAPIService

final class LoginAPIService: BaseAPIService, LoginAPIServiceProtocol {
    
    let provider = MoyaProvider<LoginTargetType>(plugins: [MoyaPlugin.shared])
    
    /// 로그인 API 호출
    func login(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void) {
        self.provider.request(
            .login(provider: provider, idToken: idToken, timeZoneOffset: timeZoneOffset, fcmToken: fcmToken)
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                print(networkResult.stateDescription)
                completion(networkResult)
                
                
                if case .success(let data) = networkResult,
                   let loginData = data?.data {
                    do {
                        let access = loginData.accessToken.replacingOccurrences(of: "Bearer ", with: "")
                        let refresh = loginData.refreshToken.replacingOccurrences(of: "Bearer ", with: "")
                        try TokenKeychainManager.shared.saveAccessToken(access)
                        try TokenKeychainManager.shared.saveRefreshToken(refresh)
                    } catch {
                        print("[ERROR] 토큰 저장 실패: \(error)")
                    }
                }
                
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
}
