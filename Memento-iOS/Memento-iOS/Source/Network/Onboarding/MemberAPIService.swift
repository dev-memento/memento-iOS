//
//  LoginAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

// MARK: - LoginAPIServiceProtocol

protocol MemberAPIServiceProtocol {
    func socialLogin(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void)
    
    func withdraw(completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
}

extension MemberAPIServiceProtocol {
    typealias LoginResponseDTO = BaseDTO<LoginResponseData>
}

// MARK: - LoginAPIService

final class MemberAPIService: BaseAPIService, MemberAPIServiceProtocol {
    
    
    let provider = MoyaProvider<MemberTargetType>(plugins: [MoyaPlugin.shared])
    
    // MARK: - 회원 로그인
    func socialLogin(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String, completion: @escaping (NetworkResult<LoginResponseDTO>) -> Void) {
        self.provider.request(
            .socialLogin(provider: provider, idToken: idToken, timeZoneOffset: timeZoneOffset, fcmToken: fcmToken)
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
    
    // MARK: - 회원 탈퇴
    func withdraw(completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
         self.provider.request(.withdraw) { [weak self] result in
             guard let self else { return }
             switch result {
             case .success(let res):
                 let parsed: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                    statusCode: res.statusCode,
                    data: res.data
                 )
                 completion(
                    parsed
                 )
             case .failure(let err):
                 if let res = err.response {
                     let parsed: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                        statusCode: res.statusCode,
                        data: res.data
                     )
                     completion(
                        parsed
                     )
                 }
             }
         }
     }
}
