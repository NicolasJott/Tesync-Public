//
//  VehicleCommandButton.swift
//  tesync
//
//  Created by Nicolas Ott on 10/24/24.
//

import SwiftUI
import TeslaSwift


struct VehicleCommandButton: View {
    var title: String
    var iconName: String
    var vehicle: Vehicle
    var command: Command
    @State var isLoading: Bool = false
    
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    isLoading = true
                    
                    // Wake up the vehicle
                    let _ = try await teslaSwiftManager.api.wakeUp(vehicle)
                    
                    // Send the command
                    let success = try await vehicleCommand.sendCommand(command: command, vin: vehicle.vin ?? "")
                    
                } catch {
                    print("Error sending command: \(error)")
                }
                
                isLoading = false
            }
        }) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                
                
                if title != "" {
                    Text(title)
                        .foregroundColor(.white)
                }
                
                
                
                
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(.gray.opacity(0.5))
            .cornerRadius(8)
        }
        .disabled(isLoading)
    }
}

