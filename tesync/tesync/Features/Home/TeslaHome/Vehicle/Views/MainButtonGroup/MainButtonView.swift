//
//  MainButtonView.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import TeslaSwift


struct MainButtonView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    
    var icon: String
    var command: Command
    var vehicle: Vehicle
    
    @State var isLoading: Bool = false
    
    
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
                    Image(systemName: icon).foregroundStyle(.gray)
                        
                }
            }
            .foregroundStyle(.gray)
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
            .padding(4)
            
        }
        .buttonStyle(.bordered)
        .tint(.gray.opacity(0.5))
    }
    
    private func performCommand() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            
            
            // Wake up the vehicle
            let _ = try await teslaSwiftManager.api.wakeUp(vehicle)
            
            // Send the command
            let success = try await vehicleCommand.sendCommand(command: command, vin: vehicle.vin ?? "")
            
        } catch {
            print("Error sending command: \(error)")
        }
    }
}
