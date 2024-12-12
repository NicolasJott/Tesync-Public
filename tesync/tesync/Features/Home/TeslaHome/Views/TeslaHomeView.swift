//
//  TeslaHomeView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/9/24.
//

import SwiftUI
import TeslaSwift


struct TeslaHomeView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var teslaAccountModel: TeslaAccountModel
    
    
    
    var body: some View {
        
        
        VStack {
            if teslaSwiftManager.isAuthenticated {
                TeslaLoggedInView()
            }
            
        }
        .onAppear {
            Task {
                guard let profile = authModel.profile,
                      let teslaAccount = profile.teslaAccount else { return }
                
                
                let success = try await teslaSwiftManager.authenticateTesla(token: teslaAccount.authToken)
                
                if !success {
                    // remove tesla account
                   let removeSuccess = try await teslaAccountModel.removeTeslaAccount(id: teslaAccount.id)
                    
                    // refresh profile
                    if removeSuccess {
                        try await authModel.getProfile()
                    }
                }
            }
        }
    }
}

#Preview {
    TeslaHomeView().environmentObject(SessionManager())
        .environmentObject(TeslaSwiftManager())
}
