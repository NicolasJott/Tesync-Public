//
//  WatchDashboardView.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift

struct WatchDashboardView: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    
    var vehicle: VehicleExtended
    
    @State private var isLocked: Bool?
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VehicleImageView()
                
                if let driveState = vehicle.driveState {
                    Text(driveState.shiftState == .drive ? "Driving" : "Parked")
                        .foregroundColor(.secondary)
                        .offset(y: -50)
                }
                Spacer()
                
            }
            .padding(.horizontal)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle(vehicleName)
            .toolbar {
                // Menu button
                ToolbarItem(placement: .cancellationAction) {
                    ChargingButton(vehicle: vehicle)
                }
                
                // Lock button
                ToolbarItem(placement: .confirmationAction) {
                    LockButton(vehicle: vehicle)
                }
                
                
                ToolbarItemGroup(placement: .bottomBar) {
                    ActuateTrunkButton(vehicle: vehicle)
                    
                    
                    
                    if let chargeState = vehicle.chargeState, let batteryLevel = chargeState.batteryLevel, let range = chargeState.ratedBatteryRange {
                        BatteryRangeView(batteryLevel: batteryLevel, range: Int(range.miles))
                    }
                    
                    
                    ClimateButton(vehicle: vehicle)
                }
            }
        }.onAppear {
            Task {
                try await teslaSwiftManager.api.wakeUp(vehicle)
            }
        }
        
    }
    private var vehicleName: String {
        if let vehicleState = vehicle.vehicleState, let vehicleName = vehicleState.vehicleName {
            return vehicleName
        }
        return "Tesla"
    }
}


