//
//  LockCommandButton.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import TeslaSwift

struct TrunkCommandButton: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    
    var vehicle: VehicleExtended
    
    @State var isLoading: Bool = false
    @State var isOpen: Bool = false
    
    
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
                    Image(systemName: "car.side.rear.open.crop").foregroundStyle(isOpen ? .white : .gray)
                        
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
            if let vehicleState = vehicle.vehicleState, let rearTrunkOpen = vehicleState.rearTrunkOpen {
                isOpen = rearTrunkOpen
            }
        }
    }
    
    private func performCommand() async throws {
        isOpen.toggle()
        isLoading = true
        defer { isLoading = false }
        do {
            guard let vin = vehicle.vin else { return }
            
            // Wake up the vehicle
            let _ = try await teslaSwiftManager.api.wakeUp(vehicle)
            
            // Send the command
            let success = try await vehicleCommand.sendCommand(command: .actuateTrunk, vin: vin)
            
            if success {
                vehicleModel.refreshVehicle()
            } else {
                isOpen.toggle()
            }
            
        } catch {
            print("Error sending command: \(error)")
        }
    }
}

