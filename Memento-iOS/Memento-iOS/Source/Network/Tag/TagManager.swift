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
                    
                    if let encoded = try? JSONEncoder().encode(tagResponse.data) {
                        UserDefaults.standard.set(encoded, forKey: "saved_tags")
                        
                        let savedTags = self?.getSavedTags() ?? []
                        
                    } else {
                        print("JSON 인코딩 실패")
                    }
                    
                    self?.saveTags(tagResponse.data)
                    completion(true)
                    
                default:
                    completion(false)
                }
            }
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
    
    func createAndSaveTag(request: TagPostRequest, completion: @escaping (TagPostResponse?) -> Void) {
        let apiService = TagAPIService()
        
        apiService.postTag(request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let tagResponse = response else {
                        completion(nil)
                        return
                    }
                    
                    let newTag = TagResponse(
                        id: Int.random(in: 10000...99999),
                        name: tagResponse.data.name,
                        colorCode: tagResponse.data.colorCode
                    )
                    self?.addTagToLocal(newTag)
                    completion(tagResponse.data)
                    
                default:
                    completion(nil)
                }
            }
        }
    }
    
    func hasLocalTags() -> Bool {
        return !getSavedTags().isEmpty
    }
    
    func saveTags(_ tags: [TagResponse]) {
        if let encoded = try? JSONEncoder().encode(tags) {
            userDefaults.set(encoded, forKey: tagsKey)
        }
    }
    
    private func addTagToLocal(_ tag: TagResponse) {
        var currentTags = getSavedTags()
        currentTags.append(tag)
        saveTags(currentTags)
    }
}
