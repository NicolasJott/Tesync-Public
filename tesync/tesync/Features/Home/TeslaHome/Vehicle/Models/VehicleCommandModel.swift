//
//  VehicleCommandModel.swift
//  tesync
//
//  Created by Nicolas Ott on 10/24/24.
//

import Foundation
import KeychainAccess

enum Command: Int {
    case flashLights
    case honkHorn
    case doorLock
    case doorUnlock
    case actuateTrunk
    case autoConditioningStart
    case autoConditioningStop
    case cancelSoftwareUpdate
    case chargeMaxRange
    case chargePortDoorOpen
    case chargePortDoorClose
    case addPreconditionSchedule
    case removePreconditionSchedule
    case setTemps
    case chargeStart
    case chargeStop
    case remoteSeatHeaterRequest
}



class VehicleCommandModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    let keychain = Keychain(service: "com.nicolasjott.tesync", accessGroup: "ZH8B3J7N69.com.nicolasjott.shared")
    
    let apiUrl: String = "\(Constants.apiURL)/api"
    
    func sendCommand(command: Command, vin: String, body: Data? = nil) async throws -> Bool {
        isLoading = true
        
        guard let url = URL(string: "\(apiUrl)/profile/command?vehicleVin=\(vin)&vehicleCommand=\(command.rawValue)") else {
            self.isLoading = false
            
            throw CommandError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(keychain["authToken"]!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        request.httpBody = body ?? "{}".data(using: .utf8)
   
        _ = try await URLSession.shared.data(for: request)
        
        isLoading = false
        
        return true
    }
}

enum CommandError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
            case .invalidUrl:
                return "The command URL is invalid."
            case .invalidResponse:
                return "The server responded with an error."
            case .invalidData:
                return "Unable to process the server response."
        }
    }
}
