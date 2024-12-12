//
//  TeslaAccount.swift
//  tesync
//
//  Created by Nicolas Ott on 10/9/24.
//

import Foundation
import TeslaSwift
import KeychainAccess

struct TeslaAccount: Codable {
    let id: Int
    let userId: Int
    let authToken: TeslaAuthToken
}

struct TeslaAuthToken: Codable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: TimeInterval?
    let createdAt: Date?
    let tokenType: String?
    let idToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expiresIn
        case createdAt
        case tokenType
        case idToken
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        expiresIn = try container.decodeIfPresent(TimeInterval.self, forKey: .expiresIn)
        tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
        idToken = try container.decodeIfPresent(String.self, forKey: .idToken)
        
   
        if let timestamp = try? container.decodeIfPresent(Double.self, forKey: .createdAt) {
            createdAt = Date(timeIntervalSince1970: timestamp)
        } else {
            createdAt = nil
        }
    }
    
    init(
        accessToken: String?,
        refreshToken: String?,
        expiresIn: TimeInterval?,
        createdAt: Date?,
        tokenType: String?,
        idToken: String?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.createdAt = createdAt
        self.tokenType = tokenType
        self.idToken = idToken
    }
}


class TeslaAccountModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    let keychain = Keychain(service: "com.nicolasjott.tesync", accessGroup: "ZH8B3J7N69.com.nicolasjott.shared")
    let apiUrl: String = "\(Constants.apiURL)/api"
    
    func addTeslaAccount(authToken: AuthToken) async throws {
        let tokenData = TeslaAuthToken(accessToken: authToken.accessToken, refreshToken: authToken.refreshToken, expiresIn: authToken.expiresIn, createdAt: authToken.createdAt, tokenType: authToken.tokenType, idToken: authToken.idToken)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        
        
        guard let encoded = try? encoder.encode(tokenData) else {
            print("Error encoding authToken")
            return
        }
        
        
        guard let url = URL(string: "\(apiUrl)/profile/tesla-account") else {
            print("Error constructing api url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(keychain["authToken"]!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            isLoading = false
            throw LoginError.invalidResponse
        }
    }
    
    func removeTeslaAccount(id: Int) async throws -> Bool {
        isLoading = true
        defer {
            isLoading = false
        }
        
        guard let url = URL(string: "\(apiUrl)/tesla-accounts/\(id)") else {
            print ("Error constructing api url")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(keychain["authToken"]!)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw LoginError.invalidResponse
        }
        
        return true
    }
}
