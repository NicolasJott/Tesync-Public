//
//  HeatedCooledSeatsView.swift
//  tesync
//
//  Created by Nicolas Ott on 12/12/24.
//

import SwiftUI
import TeslaSwift

struct HeatedCooledSeatsView: View {
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @EnvironmentObject var vehicleModel: VehicleModel
    var vehicle: VehicleExtended
    
    private let frontSeats: [(id: Int, name: String)] = [
        (0, "Driver"),
        (1, "Passenger")
    ]
    
    private let rearSeats: [(id: Int, name: String)] = [
        (2, "Rear Left"),
        (4, "Rear Middle"),
        (5, "Rear Right")
    ]
    
    @State private var seatHeaterLevels: [Int: Int] = [:]
    @State private var isLoading: Bool = false
    
    var body: some View {
           VStack(spacing: 20) {
               Text("Seat Heating")
                   .font(.headline)
                   .padding(.top, 10)
               
               // Front row (2 seats)
               HStack(spacing: 20) {
                   ForEach(frontSeats, id: \.id) { seat in
                       SeatView(
                           seatName: seat.name,
                           heaterLevel: seatHeaterLevels[seat.id] ?? 0,
                           tapAction: { didTapSeat(seatId: seat.id) }
                       )
                   }
               }
               .frame(maxWidth: .infinity, alignment: .center)
               
               // Back row (3 seats)
               HStack(spacing: 20) {
                   ForEach(rearSeats, id: \.id) { seat in
                       SeatView(
                           seatName: seat.name,
                           heaterLevel: seatHeaterLevels[seat.id] ?? 0,
                           tapAction: { didTapSeat(seatId: seat.id) }
                       )
                   }
               }
               .frame(maxWidth: .infinity, alignment: .center)
           }
           .padding()
           .frame(maxWidth: .infinity, alignment: .center)
           .onAppear {
               loadCurrentSeatHeaterLevels()
           }
       }
    
    private func loadCurrentSeatHeaterLevels() {
        guard let climate = vehicle.climateState else { return }
    
        
        seatHeaterLevels[0] = climate.seatHeaterLeft ?? 0
        seatHeaterLevels[1] = climate.seatHeaterRight ?? 0
        seatHeaterLevels[2] = climate.seatHeaterRearLeft ?? 0
        seatHeaterLevels[4] = climate.seatHeaterRearCenter ?? 0
        seatHeaterLevels[5] = climate.seatHeaterRearRight ?? 0
    }
    
    private func didTapSeat(seatId: Int) {
        var currentLevel = seatHeaterLevels[seatId] ?? 0
        if currentLevel < 3 {
            currentLevel += 1
        } else {
            currentLevel = 0
        }
        Task {
            await setSeatHeater(seatId: seatId, level: currentLevel)
        }
    }
    
    private func setSeatHeater(seatId: Int, level: Int) async {
        guard let vin = vehicle.vin else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let payload: [String: Any] = [
                "level": level,
                "heater": seatId,
            ]
            
            print(payload)
            let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            let success = try await vehicleCommand.sendCommand(command: .remoteSeatHeaterRequest, vin: vin, body: jsonBody)
            
            if success {
                seatHeaterLevels[seatId] = level
                vehicleModel.refreshVehicle()
            }
        } catch {
            print("Error setting seat heater: \(error)")
        }
    }
}

