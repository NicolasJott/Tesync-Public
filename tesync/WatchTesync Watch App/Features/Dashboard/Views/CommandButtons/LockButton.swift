//
//  LockButton.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift


struct LockButton: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    
    var vehicle: VehicleExtended
    
    @State private var isLoading: Bool = false
    @State private var isLocked: Bool = false
    
    var body: some View {
        if let state = vehicle.vehicleState {
            Button(action: {
                Task {
                    WKInterfaceDevice.current().play(.click)
                    isLoading = true
                    guard let vin = vehicle.vin else { return }
                    let success = try await vehicleCommand.sendCommand(command: isLocked ? .doorUnlock : .doorLock, vin: vin)
                    
                    if success {
                        isLocked.toggle()
                        vehicleModel.refreshVehicle()
                    }
                    
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                        .foregroundColor(isLocked ? .gray : .white)
                }
            }
            .onAppear {
                if let locked = state.locked {
                    isLocked = locked
                    print("IsLocked: \(isLocked)")
                }
            }
            
        }
    }
}

