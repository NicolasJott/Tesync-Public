//
//  AuthModel.swift
//  tesync
//
//  Created by Nicolas Ott on 10/1/24.
//

import Foundation
import KeychainAccess
import TeslaSwift

struct Token : Codable {
    let token: String
}

struct Profile: Codable, Identifiable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: Date
    let updatedAt: Date
    
    let teslaAccount: TeslaAccount?
}



class AuthModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var profile: Profile?
    @Published var isLoading: Bool = false
    
    
    let keychain = Keychain(service: "com.nicolasjott.tesync", accessGroup: "ZH8B3J7N69.com.nicolasjott.shared")
    
    let apiUrl: String = "\(Constants.apiURL)/api"
    
    func authenticate(token: Token) async throws {
     
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        keychain.synchronizable(true)["authToken"] = token.token
        
        try await getProfile()
    }
    
    func getProfile() async throws {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: "\(apiUrl)/profile") else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw LoginError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(keychain["authToken"]!)", forHTTPHeaderField: "Authorization")
    
        request.httpMethod = "GET"
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw LoginError.invalidResponse
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
        do {
            let decoder = JSONDecoder()
            let customDateFormatter = DateFormatter()
            customDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            customDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            customDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(customDateFormatter)
            let profile = try decoder.decode(Profile.self, from: data)
            
            DispatchQueue.main.async {
                self.profile = profile
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            print(error)
            throw LoginError.invalidData
        }
    }
    
    func reuseToken() async throws {
        if keychain["authToken"] == nil {
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        try await getProfile()
        
    }
    
    
    func logout() {
        keychain.synchronizable(true)["authToken"] = nil
        isAuthenticated = false
        profile = nil
    }
    
}
