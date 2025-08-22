//
//  TokenKeychainManager.swift
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
    
    // MARK: - Access Token 저장, 가져오기
    
    func saveAccessToken(_ token: String) throws {
        print("👍 AccessToken 저장 완료")
        try save(key: "AccessToken", value: token)
    }
    
    func getAccessToken() throws -> String? {
        return try load(key: "AccessToken")
    }
    
    // MARK: - Refresh Token 저장, 가져오기
    
    func saveRefreshToken(_ token: String) throws {
        print("👍 RefreshToken 저장 완료")
        try save(key: "RefreshToken", value: token)
    }
    
    func getRefreshToken() throws -> String? {
        return try load(key: "RefreshToken")
    }
    
    // MARK: - Token 삭제
    
    func clearTokens() throws {
        try delete(key: "AccessToken")
        try delete(key: "RefreshToken")
    }
    
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
    
    // MARK: - Token 유효성 검사 (만료시각 확인)
    /// 키체인에서 액세스 토큰을 꺼내서 비어있지 않고, 만료되지 않았는지 확인

    func hasValidToken() -> Bool {
        do {
            guard let accessToken = try getAccessToken(), !accessToken.isEmpty else {
                return false
            }
            return !isTokenExpired(accessToken)
        } catch {
            return false
        }
    }

    func isTokenExpired(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count == 3,
              let payloadData = Data(base64Encoded: String(parts[1]).base64Padded()),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else { return true }

        return Date().timeIntervalSince1970 > exp
    }
}
