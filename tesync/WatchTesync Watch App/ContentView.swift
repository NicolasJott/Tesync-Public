//
//  ContentView.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 11/5/24.
//

import SwiftUI
import TeslaSwift

struct ContentView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var authModel: AuthModel
    @StateObject var vehicleModel = VehicleModel() 
    
    var body: some View {
        VStack {
            if !authModel.isAuthenticated {
                Text("Login on the Tesync App to continue")
            } else if let currentVehicle = vehicleModel.vehicle {
                WatchDashboardView(vehicle: currentVehicle)
            } else if vehicleModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text("No vehicle data available.")
            }
        }
        .environmentObject(vehicleModel)
        .onAppear {
            vehicleModel.setup(teslaSwiftManager: teslaSwiftManager, authModel: authModel)
        }
    }
}



