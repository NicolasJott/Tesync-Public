//
//  ClimateControlView.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift

struct ClimateControlView: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    
    @State private var climateControlTemp: Int = 15
    @State private var climateControlOn: Bool = false
    @State private var isLoading: Bool = false
    var vehicle: VehicleExtended
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        Task {
                            WKInterfaceDevice.current().play(.click)
                            try await handleTempChange(increment: false)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .clipShape(.circle)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text(climateControlTempFormatted)
                        .foregroundStyle(.white)
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            WKInterfaceDevice.current().play(.click)
                            try await handleTempChange(increment: true)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .clipShape(.circle)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        WKInterfaceDevice.current().play(.click)
                        try await toggleClimateControl()
                    }
                }) {
                    VStack {
                        ZStack {
                            Image(systemName: "power")
                                .font(.title2)
                                .foregroundStyle(climateControlOn ? .white : .gray)
                                .clipShape(.circle)
                                .opacity(isLoading ? 0 : 1)
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .font(.title2)
                            }
                        }
                        .frame(width: 40, height: 40)
                        
                        Text(climateControlOn ? "On" : "Off")
                            .font(.caption)
                            .foregroundStyle(climateControlOn ? .white : .gray)
                    }
                }
                .buttonStyle(.plain)
                
                
            }.navigationTitle("Climate Control")
                .onAppear {
                    setupClimateControl()
                }
        }
        
    }
    
    private var climateControlTempFormatted: String {
        guard let climateState = vehicle.climateState, let maxAvailableTemperature = climateState.maxAvailableTemperature, let minAvailableTemperature = climateState.minAvailableTemperature else { return "nil°" }
        
        
        if climateControlTemp == Int(maxAvailableTemperature.fahrenheit.rounded(.toNearestOrAwayFromZero)) {
            return "Hi"
        }
        
        if climateControlTemp == Int(minAvailableTemperature.fahrenheit.rounded(.toNearestOrAwayFromZero)) {
            return "Lo"
        }
        
        return "\(climateControlTemp)°"
    }
    
    private func setupClimateControl() {
        if let climateState = vehicle.climateState,
           let isClimateOn = climateState.isClimateOn,
           let driverTemperatureSetting = climateState.driverTemperatureSetting  {
            climateControlOn = isClimateOn
            climateControlTemp = Int(driverTemperatureSetting.fahrenheit.rounded(.toNearestOrAwayFromZero))
            
        }
    }
    
    private func toggleClimateControl() async throws {
        guard let vin = vehicle.vin else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let success = try await vehicleCommand.sendCommand(command: climateControlOn ? .autoConditioningStop : .autoConditioningStart, vin: vin)
            
            if success {
                climateControlOn.toggle()
                vehicleModel.refreshVehicle()
            }
            
        } catch {
            print("An error occured toggling climate control: \(error)")
        }
        
    }
    
    private func handleTempChange(increment: Bool) async throws{
        guard let climateState = vehicle.climateState, let maxAvailableTemperature = climateState.maxAvailableTemperature, let minAvailableTemperature = climateState.minAvailableTemperature else { return }
        
      
        
        if increment {
            if climateControlTemp == Int(maxAvailableTemperature.fahrenheit.rounded(.toNearestOrAwayFromZero)) { return }
            climateControlTemp += 1
        } else {
            if climateControlTemp == Int(minAvailableTemperature.fahrenheit.rounded(.toNearestOrAwayFromZero)) { return }
            climateControlTemp -= 1
        }
        
        try await setTemp()
    }
    
    private func setTemp() async throws {
        guard let vin = vehicle.vin else { return }
        
        if !climateControlOn {
            try await toggleClimateControl()
        }
        
        print(climateControlTemp)
        
        let tempCelcius = (Double(climateControlTemp - 32) * (5.0 / 9.0)).rounded()
        print(tempCelcius)
        
        do {
            let payload: [String: Any] = [
                "driver_temp": tempCelcius,
                "passenger_temp": tempCelcius
            ]
      
            let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            let success = try await vehicleCommand.sendCommand(command: .setTemps, vin: vin, body: jsonBody)
            
            if success {
                vehicleModel.refreshVehicle()
            }
        } catch {
            print("An error occured setting temperature: \(error)")
        }
    }
}

