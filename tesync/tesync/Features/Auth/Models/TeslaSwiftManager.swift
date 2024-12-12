//
//  TeslaSwiftManager.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import Foundation
import TeslaSwift
import KeychainAccess



class TeslaSwiftManager: ObservableObject {
    @Published var api: TeslaSwift
    @Published var isAuthenticated: Bool = false
    
    private let keychain = Keychain(service: "com.nicolasjott.shared")
    
    init() {
        let teslaAPI = TeslaAPI.fleetAPI(
            region: .northAmericaAsiaPacific,
            clientID: Constants.clientID,
            clientSecret: Constants.clientSecret,
            redirectURI: Constants.redirectURI
        )
        
        // Initialize the TeslaSwift instance
        self.api = TeslaSwift(teslaAPI: teslaAPI)
    }
    
    func authenticateTesla(token: TeslaAuthToken) async throws -> Bool {
        let validToken = convertToken(token: token)
        
        api.reuse(token: validToken)
        
        do {
            let newToken = try await api.refreshToken()
        } catch {
            print("Error refreshing token: \(error)")
            let error = error as? TeslaError
            
            
            if error == .tokenRefreshFailed {
                return false
            }
        }
        
        
        DispatchQueue.main.async {
            self.isAuthenticated = true
        }
        return true
    }
    
    func convertToken(token: TeslaAuthToken) -> AuthToken {
        let teslaToken: AuthToken = AuthToken(accessToken: token.accessToken ?? "")
        teslaToken.expiresIn = token.expiresIn ?? 0
        teslaToken.refreshToken = token.refreshToken ?? ""
        teslaToken.idToken = token.idToken ?? ""
        teslaToken.tokenType = token.tokenType ?? ""
        return teslaToken
    }
    
    
}

