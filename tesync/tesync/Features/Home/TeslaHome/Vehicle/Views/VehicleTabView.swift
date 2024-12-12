//
//  VehicleTabView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import SwiftUI
import TeslaSwift

struct VehicleTabView: View {
    
    @State private var vehicleCommand = VehicleCommandModel()
    var vehicle: VehicleExtended
    
    var body: some View {
            TabView {
                VehicleView(vehicle: vehicle)
                    .tabItem { Label("Vehicle", systemImage: "car") }
                    .environmentObject(vehicleCommand)
                
                
                ScheduleView(vehicle: vehicle)
                    .tabItem { Label("Schedule", systemImage: "calendar") }
                    .environmentObject(vehicleCommand)
              
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                
            }
            .tint(.red)

    }
}




