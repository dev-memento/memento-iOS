//
//  TagAPIService.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/23/25.
//

import Foundation

import Moya

// MARK: - TagAPIServiceProtocol

protocol TagAPIServiceProtocol {
    func getTags(completion: @escaping (NetworkResult<BaseDTO<[TagResponseData]>>) -> Void)
}

extension TagAPIServiceProtocol {
    typealias TagResponseDTO = BaseDTO<TagResponseData>
}

// MARK: - TagAPIService

final class TagAPIService: BaseAPIService, TagAPIServiceProtocol {

    private let provider = MoyaProvider<TagTargetType>(plugins: [MoyaPlugin.shared])
    
    func getTags(completion: @escaping (NetworkResult<BaseDTO<[TagResponseData]>>) -> Void) {
        provider.request(.getTags) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<[TagResponseData]>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<[TagResponseData]>> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
            }
        }
    }
    
}
