//
//  LockCommandButton.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import TeslaSwift

struct LockCommandButton: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    
    var vehicle: VehicleExtended
    
    @State var isLoading: Bool = false
    @State var isLocked: Bool = false
    
    
    var body: some View {
        Button(action: {
            Task {
                try await performCommand()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular).tint(.white)
                } else {
                    Image(systemName: isLocked ? "lock" : "lock.open").foregroundStyle(isLocked ? .gray : .white)
                        
                }
            }
            .foregroundStyle(.gray)
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
            .padding(4)
            
        }
        .buttonStyle(.bordered)
        .tint(.gray.opacity(0.5))
        .onAppear {
            if let vehicleState = vehicle.vehicleState, let locked = vehicleState.locked {
                isLocked = locked
            }
        }
    }
    
    private func performCommand() async throws {
        isLocked.toggle()
        isLoading = true
        defer { isLoading = false }
        do {
            guard let vin = vehicle.vin else { return }
            
            // Wake up the vehicle
            let _ = try await teslaSwiftManager.api.wakeUp(vehicle)
            
            // Send the command
            let success = try await vehicleCommand.sendCommand(command: isLocked ? .doorUnlock : .doorLock, vin: vin)
            
            if success {
                vehicleModel.refreshVehicle()
            } else {
                isLocked.toggle()
            }
            
        } catch {
            print("Error sending command: \(error)")
        }
    }
}

