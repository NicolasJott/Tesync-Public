//
//  tesyncApp.swift
//  tesync
//
//  Created by Nicolas Ott on 8/29/24.
//

import SwiftUI


@main
struct tesyncApp: App {
    @State private var sessionManager = SessionManager()
    @State private var teslaSwiftManager = TeslaSwiftManager()
    @State private var authModel = AuthModel()
    @State private var vehicleCommandModel = VehicleCommandModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
                .environmentObject(teslaSwiftManager)
                .environmentObject(authModel)
                .environmentObject(vehicleCommandModel)
                .onAppear{ Task{
                    try await authModel.reuseToken()
                }
                }
            
        }
    }
}
