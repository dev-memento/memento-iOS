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
    func login(provider: String, idToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void)
}

extension LoginAPIServiceProtocol {
    typealias LoginResponseDTO = BaseDTO<LoginResponseData>
}

// MARK: - LoginAPIService

final class LoginAPIService: BaseAPIService, LoginAPIServiceProtocol {
    
    let provider = MoyaProvider<LoginTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin()])
    
    /// 로그인 API 호출
    func login(provider: String, idToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void) {
        self.provider.request(.login(provider: provider, idToken: idToken)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
