//
//  SignupModel.swift
//  tesync
//
//  Created by Nicolas Ott on 10/1/24.
//

import Foundation
import SwiftUICore

struct SignupData: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

enum SignupError: Error {
    case invalidBody
    case invalidUrl
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidBody:
            return "There was an issue encoding your signup data."
        case .invalidUrl:
            return "The signup URL is invalid."
        case .invalidResponse:
            return "The server responded with an error."
        case .invalidData:
            return "Unable to process the server response."
        }
    }
}


class SignupModel: ObservableObject {
    let apiUrl: String = "\(Constants.apiURL)/api/auth"
    @Published var isLoading: Bool = false
    
    
    func signup(email: String, password: String, name: String) async throws -> Token {
        isLoading = true
        let nameParts = name.split(separator: " ")
        
        let firstName = nameParts.first ?? ""
        let lastName = nameParts.last ?? ""
        
        let signupData = SignupData(email: email, password: password, firstName: String(firstName), lastName: String(lastName))
        
        guard let encoded = try? JSONEncoder().encode(signupData) else {
            isLoading = false
            throw SignupError.invalidBody
        }
        
        guard let url = URL(string: "\(apiUrl)/register") else {
            isLoading = false
            throw SignupError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            isLoading = false
            throw SignupError.invalidResponse
        }
        do {
            isLoading = false
            let token = try JSONDecoder().decode(Token.self, from: data)
            
            return token
            
        } catch {
            isLoading = false
            throw SignupError.invalidData
        }
    }
}

