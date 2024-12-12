//
//  AddPreconditioningScheduleExtension.swift
//  tesync
//
//  Created by Nicolas Ott on 11/20/24.
//

import Foundation
import TeslaSwift

extension TeslaSwift {
    public func addPreconditionSchedule(
        vehicle: Vehicle,
        time: Int,
        days: [String],
        oneTime: Bool,
        latitude: Double,
        longitude: Double
    ) async throws -> Bool {
        // Construct the API endpoint URL
        guard let vehicleVin = vehicle.vin else {
            throw TeslaError.failedToReloadVehicle
        }
        
        let endpoint = "/api/1/vehicles/\(vehicleVin)/command/add_precondition_schedule"
        
        // Build the payload
        let payload: [String: Any] = [
            "days_of_week": days.joined(separator: ","),
            "enabled": true,
            "lat": latitude,
            "lon": longitude,
            "precondition_time": time,
            "one_time": oneTime,
        ]
        
        // Send the request
        let response = try await sendRequest(
            endpoint: endpoint,
            method: .post,
            parameters: payload
        )
        
        // Parse and return the response
        guard let result = response["response"] as? Bool else {
            throw TeslaError.failedToParseData
        }
        
        return result
    }
    
    func sendRequest(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> [String: Any] {
        let baseURL = "https://fleet-api.prd.na.vn.cloud.tesla.com"
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw TeslaError.noCodeInURL
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        print(parameters)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.token?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("TeslaApp/4.30.6", forHTTPHeaderField: "x-tesla-user-agent")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print(String(data: data, encoding: .utf8) ?? "Unable to decode response")
        
        
        // Parse JSON response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw TeslaError.failedToParseData
        }
        
        // Check for "response" key
        guard let nestedResponse = json["response"] as? [String: Any] else {
            throw TeslaError.failedToParseData
        }
        
        return nestedResponse
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
