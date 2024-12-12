//
//  ChargingButton.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/4/24.
//

import SwiftUI
import TeslaSwift

struct ChargingButton: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    
    var vehicle: VehicleExtended
    
    @State private var isLoading: Bool = false
    @State private var isCharging: Bool = false
    
    var body: some View {
        if let state = vehicle.chargeState {
            Button(action: {
                Task {
                    WKInterfaceDevice.current().play(.click)
                    isLoading = true
                    guard let vin = vehicle.vin else { return }
                    let success = try await vehicleCommand.sendCommand(command: isCharging ? .chargeStop : .chargeStart, vin: vin)
                    
                    if success {
                        isCharging.toggle()
                        vehicleModel.refreshVehicle()
                    }
                    
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Image(systemName: "ev.plug.dc.nacs")
                        .foregroundColor(isCharging ? .green : .gray)
                }
            }
            .onAppear {
                isCharging  = state.chargingState == .charging
            }
            
        }
    }
}
