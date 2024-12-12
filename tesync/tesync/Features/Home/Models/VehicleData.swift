//
//  VehicleData.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import Foundation
import TeslaSwift

@Observable
class VehicleData {
    var vehicles: [Vehicle] = []
    private var manager: TeslaSwiftManager
    
    init(manager: TeslaSwiftManager) {
        self.manager = manager
        print(manager.isAuthenticated)
    }
    
    func getVehicles() async {
        do {
            let vehicles = try await manager.api.getVehicles()
            self.vehicles = vehicles
        } catch let error {
            print("Error occured while fetching vehicles: \(error)")
        }
        
    }
}
