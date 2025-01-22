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
}

final class LoginAPIService: BaseAPIService, LoginAPIServiceProtocol {

    private let provider = MoyaProvider<LoginTargetType>(plugins: [MoyaPlugin.shared])

    /// 로그인 API 호출
    func login(provider: String, idToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void) {
        self.provider.request(.login(provider: provider, idToken: idToken)) { result in
            switch result {
            case .success(let response):
                // 서버 응답 처리
                let networkResult: NetworkResult<LoginResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                print("로그인 요청 결과: \(networkResult.stateDescription)")
                completion(networkResult)
                
            case .failure(let error):
                // 네트워크 오류 처리
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
