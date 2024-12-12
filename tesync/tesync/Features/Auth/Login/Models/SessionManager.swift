//
//  Auth.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import Foundation
import TeslaSwift
import KeychainAccess

class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isBusy: Bool = false
    let keychain = Keychain(service: "com.nicolasjott.tesync")
    
    
    func authenticateUser(token: Token) {
            keychain["authToken"] = token.token
            isAuthenticated = true
    }
    
    func authenticate(token: AuthToken) {
        do {
            // Encode the AuthToken object to Data
            let encoder = JSONEncoder()
            let tokenData = try encoder.encode(token)
            
            // Store the token data in the Keychain
            keychain["authToken"] = tokenData.base64EncodedString()
            
            // Update authentication state
            isAuthenticated = true
        } catch {
            print("Error encoding token: \(error)")
        }
    }
    
    func retrieveToken() -> AuthToken? {
        do {
            if let tokenString = try keychain.get("authToken"),
               let tokenData = Data(base64Encoded: tokenString) {
                // Decode the data back into an AuthToken object
                let decoder = JSONDecoder()
                let token = try decoder.decode(AuthToken.self, from: tokenData)
                return token
            }
        } catch {
            print("Error decoding token from Keychain: \(error)")
        }
        return nil
    }
    
    func logout() {
        isBusy = true
        do {
            try keychain.remove("authToken")
            
            isAuthenticated = false
            isBusy = false
        } catch let error {
            isBusy = false
            print("Error removing token from Keychain: \(error)")
        }
    }
}
