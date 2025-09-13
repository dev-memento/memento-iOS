//
//  TagManager.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 8/29/25.
//

import Foundation

final class TagManager {
    
    static let shared = TagManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tagsKey = "saved_tags"
    
    // MARK: - 서버 연동
    
    /// 서버에서 태그를 가져와 로컬에 저장
    func fetchAndSaveTags(completion: @escaping (Bool) -> Void) {
        let apiService = TagAPIService()
        
        apiService.getTags { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    guard let tagResponse = response else {
                        completion(false)
                        return
                    }
                    
                    self?.saveTags(tagResponse.data)
                    completion(true)
                    
                default:
                    completion(false)
                }
            }
        }
    }
    
    /// 태그 생성하고 로컬에 저장
    func createAndSaveTag(request: TagPostRequest, completion: @escaping (TagPostResponse?) -> Void) {
        let apiService = TagAPIService()
        
        apiService.postTag(request: request) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let tagResponse = response else {
                        completion(nil)
                        return
                    }
                    
                    self.fetchAndSaveTags { _ in
                        DispatchQueue.main.async {
                            completion(tagResponse.data)
                        }
                    }
                    
                default:
                    completion(nil)
                }
            }
        }
    }
    
    /// 태그 수정
    func updateTag(tagId: Int, request: TagPostRequest, completion: @escaping (Bool) -> Void) {
        let apiService = TagAPIService()
        
        apiService.patchTag(tagId: tagId, request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // 로컬 업데이트
                    self?.updateTagInLocal(tagId: tagId, name: request.name, colorCode: request.hexCode)
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
    }
    
    /// 태그 삭제
    func deleteTag(tagId: Int, completion: @escaping (Bool) -> Void) {
        let apiService = TagAPIService()
        
        apiService.deleteTag(tagId: tagId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // 로컬에서 제거
                    self?.removeTagFromLocal(tagId: tagId)
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - 로컬
    
    /// 태그 로컬에 저장하기
    func saveTags(_ tags: [TagResponse]) {
        if let encoded = try? JSONEncoder().encode(tags) {
            userDefaults.set(encoded, forKey: tagsKey)
        }
    }
    
    /// 로컬에 저장된 태그들 가져오기
    func getSavedTags() -> [TagResponse] {
        guard let data = userDefaults.data(forKey: tagsKey),
              let tags = try? JSONDecoder().decode([TagResponse].self, from: data) else {
            return []
        }
        return tags
    }
    
    /// 특정 ID로 태그 찾기
    func getTag(by id: Int) -> TagResponse? {
        return getSavedTags().first { $0.id == id }
    }
    
    /// 태그 이름으로 찾기
    func getTag(by name: String) -> TagResponse? {
        return getSavedTags().first { $0.name == name }
    }
    
    func hasLocalTags() -> Bool {
        return !getSavedTags().isEmpty
    }
    
    /// 로컬 태그 업데이트
    private func updateTagInLocal(tagId: Int, name: String, colorCode: String) {
        let updatedTags = getSavedTags().map { tag in
            tag.id == tagId ? TagResponse(id: tagId, name: name, colorCode: colorCode) : tag
        }
        saveTags(updatedTags)
    }
    
    /// 로컬에서 태그 제거
    private func removeTagFromLocal(tagId: Int) {
        var currentTags = getSavedTags()
        currentTags.removeAll { $0.id == tagId }
        saveTags(currentTags)
    }
}
