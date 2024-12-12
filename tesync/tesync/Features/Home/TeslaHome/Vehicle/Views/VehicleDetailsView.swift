//
//  VehicleDetailsView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/24/24.
//

import SwiftUI
import TeslaSwift

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    @State private var vehicleDetails: VehicleExtended?

    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let vehicleDetails = vehicleDetails,
                   let batteryLevel = vehicleDetails.chargeState?.batteryLevel {
                    HStack(spacing: 8) {
                        BatteryView(percentage: Double(batteryLevel))
                        Text("\(batteryLevel)%")
                            .font(.headline)
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    // Wake up the vehicle
                    let _ = try await teslaSwiftManager.api.wakeUp(vehicle)
                    
                    vehicleDetails = try await teslaSwiftManager.api.getAllData(vehicle)
                } catch {
                    print("Error fetching vehicle details: \(error)")
                }
            }
        }
    }
}

