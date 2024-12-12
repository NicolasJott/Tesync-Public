//
//  ContentView.swift
//  tesync
//
//  Created by Nicolas Ott on 8/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var authModel: AuthModel


    
    var body: some View {
        if authModel.isLoading {
            VStack {
                ProgressView()
            }
        }
        if authModel.isAuthenticated  {
            HomeView()
                .environment(VehicleData(manager: teslaSwiftManager))
        }
        
        if !authModel.isAuthenticated && !authModel.isLoading {
            LoginView()
                .environmentObject(authModel)
        }
        
    }
}


