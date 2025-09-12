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
    func getTags(completion: @escaping (NetworkResult<TagResponseDTO>) -> Void)
    func postTag(request: TagPostRequest, completion: @escaping (NetworkResult<TagPostResponseDTO>) -> Void)
    func deleteTag(tagId: Int, completion: @escaping (NetworkResult<TagDeleteResponseDTO>) -> Void)
    func patchTag(tagId: Int, request: TagPostRequest, completion: @escaping (NetworkResult<TagPatchResponseDTO>) -> Void)
}

extension TagAPIServiceProtocol {
    typealias TagResponseDTO = BaseDTO<[TagResponse]>
    typealias TagPostResponseDTO = BaseDTO<TagPostResponse>
    typealias TagDeleteResponseDTO = BaseDTO<EmptyData>
    typealias TagPatchResponseDTO = BaseDTO<EmptyData>
}

struct EmptyData: Codable {}

// MARK: - TagAPIService

final class TagAPIService: BaseAPIService, TagAPIServiceProtocol {
    
    private let provider = MoyaProvider<TagTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    func getTags(completion: @escaping (NetworkResult<TagResponseDTO>) -> Void) {
        provider.request(.getTags) { result in
            let networkResult: NetworkResult<TagResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                } else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    func postTag(request: TagPostRequest, completion: @escaping (NetworkResult<TagPostResponseDTO>) -> Void) {
        provider.request(.postTag(request)) { result in
            let networkResult: NetworkResult<TagPostResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
                else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    func deleteTag(tagId: Int, completion: @escaping (NetworkResult<TagDeleteResponseDTO>) -> Void) {
        provider.request(.deleteTag(tagId)) { result in
            let networkResult: NetworkResult<TagDeleteResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
                else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    func patchTag(tagId: Int, request: TagPostRequest, completion: @escaping (NetworkResult<TagPatchResponseDTO>) -> Void) {
        provider.request(.patchTag(tagId, request)) { result in
            let networkResult: NetworkResult<TagPatchResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
                else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
}
