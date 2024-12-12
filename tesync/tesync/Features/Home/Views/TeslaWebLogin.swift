//
//  TeslaWebLogin.swift
//  tesync
//
//  Created by Nicolas Ott on 9/4/24.
//

import TeslaSwift
import SwiftUI




struct TeslaWebLogin: UIViewControllerRepresentable {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var teslaAccountModel: TeslaAccountModel
    @EnvironmentObject var authModel: AuthModel
    
    
    
    func makeUIViewController(context: Context) -> TeslaWebLoginViewController {
        let (webloginViewController, result) = teslaSwiftManager.api.authenticateWeb()
        Task { @MainActor in
            do {
                let result = try await result()
                
                if let url = teslaSwiftManager.api.urlToSendPublicKeyToVehicle(domain: Constants.teslaDomain) {
                    await UIApplication.shared.open(url)
                }
                
                try await teslaAccountModel.addTeslaAccount(authToken: result)
                
                
                try await authModel.getProfile()
            } catch let error {
                print("Error", error)
            }
        }
        return webloginViewController!
    }
    
    func updateUIViewController(_ uiViewController: TeslaWebLoginViewController, context: Context) {
    }
    
}
