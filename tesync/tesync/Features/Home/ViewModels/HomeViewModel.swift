//
//  HomeViewModel.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import Foundation
import KeychainAccess

class HomeViewModel: ObservableObject {
    var sessionManager: SessionManager
    var teslaSwiftManager: TeslaSwiftManager
    
    let keychain = Keychain(accessGroup: "com.nicolasjott.tesync")
    
    init(sessionManager: SessionManager, teslaSwiftManager: TeslaSwiftManager) {
        self.sessionManager = sessionManager
        self.teslaSwiftManager = teslaSwiftManager
    }
    
    func refresh() {
        // get refresh token
        if let authToken = sessionManager.retrieveToken() {
            print(authToken.accessToken!)
            teslaSwiftManager.api.reuse(token: authToken)
            
        }
    }
}
