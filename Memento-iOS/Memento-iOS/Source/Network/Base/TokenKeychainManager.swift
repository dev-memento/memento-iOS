//
//  KeychainManager.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Security

/// Keychain 관련 에러 정의
enum KeychainError: Error {
    case dataConversionFailed
    case itemNotFound
    case unexpectedData
    case unhandledError(OSStatus)
}

final class TokenKeychainManager {
    
    static let shared = TokenKeychainManager() // 싱글톤 인스턴스
    
    private init() {}
    
    // MARK: - 저장 메서드
    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        
        // 기존에 저장된 값이 있으면 삭제
        try? delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.unhandledError(status)
        }
    }
    
    // MARK: - 조회 메서드
    func load(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
        } else if status != errSecSuccess {
            throw KeychainError.unhandledError(status)
        }
        
        guard let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedData
        }
        return value
    }
    
    // MARK: - 삭제 메서드
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandledError(status)
        }
    }
    
    // MARK: - Access Token
    
    func saveAccessToken(_ token: String) throws {
        try save(key: "AccessToken", value: token)
    }
    
    func getAccessToken() throws -> String? {
        return try load(key: "AccessToken")
    }
    
    // MARK: - Refresh Token
    
    func saveRefreshToken(_ token: String) throws {
        try save(key: "RefreshToken", value: token)
    }
    
    func getRefreshToken() throws -> String? {
        return try load(key: "RefreshToken")
    }
    
    // MARK: - Token Management
    
    func clearTokens() throws {
        try delete(key: "AccessToken")
        try delete(key: "RefreshToken")
    }
    
    func removeAllTokens() throws {
        try delete(key: "AccessToken")
        try delete(key: "RefreshToken")
    }
    
    // MARK: - Token Validation
    
    func hasValidToken() -> Bool {
        do {
            if let accessToken = try getAccessToken(), !accessToken.isEmpty {
                return true
            }
            return false
        } catch {
            return false
        }
    }
}
