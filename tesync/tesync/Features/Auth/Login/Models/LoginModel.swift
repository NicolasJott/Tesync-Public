//
//  LoginModel.swift
//  tesync
//
//  Created by Nicolas Ott on 10/1/24.
//

import Foundation
import SwiftUICore

struct LoginData: Codable {
    let email: String
    let password: String
}

enum LoginError: Error, LocalizedError {
    case invalidBody
    case invalidUrl
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .invalidBody:
            return "There was an issue encoding your login data."
        case .invalidUrl:
            return "The login URL is invalid."
        case .invalidResponse:
            return "The server responded with an error."
        case .invalidData:
            return "Unable to process the server response."
        }
    }
}
class LoginModel: ObservableObject {
    @EnvironmentObject var authModel: AuthModel
    @Published var error: Error?
    @Published var isLoading: Bool = false

    
    let apiUrl: String = "\(Constants.apiURL)/api/auth"
    
    
    func login(email: String, password: String) async throws -> Token {
        isLoading = true
        
        let loginData = LoginData(email: email, password: password)
        
        guard let encoded = try? JSONEncoder().encode(loginData) else {
            isLoading = false
            throw LoginError.invalidBody
        }
        
        guard let url = URL(string: "\(apiUrl)/login") else {
            isLoading = false
            throw LoginError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            isLoading = false
            throw LoginError.invalidResponse
        }
        isLoading = false
        do {
            let token = try JSONDecoder().decode(Token.self, from: data)
            return token
        } catch {
            throw LoginError.invalidData
        }
    }
}
