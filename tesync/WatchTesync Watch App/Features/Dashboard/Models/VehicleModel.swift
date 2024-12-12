//
//  VehicleModel.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/3/24.
//

import Foundation
import SwiftUI
import TeslaSwift

class VehicleModel: ObservableObject {
    @Published var vehicle: VehicleExtended?
    @Published var isLoading: Bool = false
    
    var teslaSwiftManager: TeslaSwiftManager?
    var authModel: AuthModel?
    
    func setup(teslaSwiftManager: TeslaSwiftManager, authModel: AuthModel) {
        self.teslaSwiftManager = teslaSwiftManager
        self.authModel = authModel
        Task {
            await reAuthenticate()
        }
    }
    
    func reAuthenticate() async {
        guard let authModel = authModel else { return }
        do {
            try await authModel.reuseToken()
            await fetchVehicles()
        } catch {
            print("Re-authentication failed: \(error)")
        }
    }
    
    func fetchVehicles() async {
        guard let teslaSwiftManager = teslaSwiftManager,
              let authToken = authModel?.profile?.teslaAccount?.authToken else { return }
        
        do {
            try await teslaSwiftManager.authenticateTesla(token: authToken)
        } catch {
            print ("An error occurred while authenticating Tesla: \(error)")
        }
        
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let response = try await teslaSwiftManager.api.getVehicles()
            await getVehicleFullDetails(response[0])
        } catch {
            print("Fetching vehicles failed: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func getVehicleFullDetails(_ vehicleToGet: Vehicle) async {
        guard let teslaSwiftManager = teslaSwiftManager else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let vehicleFullDetails = try await teslaSwiftManager.api.getAllData(vehicleToGet)
            DispatchQueue.main.async {
                self.vehicle = vehicleFullDetails
                self.isLoading = false
            }
        } catch {
            print("Getting vehicle details failed: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func refreshVehicle() {
        Task {
            if let vehicle = self.vehicle {
                await getVehicleFullDetails(vehicle)
            }
        }
    }
}
