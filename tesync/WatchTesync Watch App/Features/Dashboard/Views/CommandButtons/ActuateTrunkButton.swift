//
//  ActuateTrunkButton.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift
import WatchKit

struct ActuateTrunkButton: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    
    var vehicle: VehicleExtended
    @State private var isLoading: Bool = false
    @State private var trunkOpen: Bool = false
    
    var body: some View {
        Button(action: {
            Task {
                WKInterfaceDevice.current().play(.click)
                isLoading = true
                guard let vin = vehicle.vin else {return}
                
                let payload: [String: Any] = [
                    "which_trunk": "rear",
                ]
                
                let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
                let _ = try await vehicleCommand.sendCommand(command: .actuateTrunk, vin: vin, body: jsonBody)
                isLoading = false
            }
        }) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Image(systemName: "car.side.rear.open.crop")
                    .foregroundColor(trunkOpen ? .white : .gray)
            }
            
        }
        .onAppear {
            if let vehicleState = vehicle.vehicleState, let rearTrunkOpen = vehicleState.rearTrunkOpen {
                trunkOpen = rearTrunkOpen
            }
        }
    }
}

