//
//  ScheduleView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/15/24.
//

import SwiftUI
import TeslaSwift

struct ScheduleView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @State private var preconditioningSchedules: [PreconditionSchedule]?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var scheduleEnabledStates: [Int: Bool] = [:]
    @State private var selectedSchedule: PreconditionSchedule?
    
    @State private var showingSheet: Bool = false
    @State private var showingEditSheet: Bool = false
    var vehicle: Vehicle
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if let schedules = preconditioningSchedules {
                    if schedules.isEmpty {
                        Text("No preconditioning schedules available.")
                    } else {
                        List(schedules) { schedule in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(schedule.daysOfWeekArray.joined(separator: ", "))")
                                        .font(.headline)
                                    Text("by \(schedule.formattedTime)")
                                    if (!schedule.oneTime) {
                                        Text("Repeat Weekly").font(.subheadline).foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Toggle(isOn: Binding(
                                    get: { scheduleEnabledStates[schedule.id] ?? schedule.enabled },
                                    set: { newValue in
                                        scheduleEnabledStates[schedule.id] = newValue
                                        Task {
                                            do {
                                                try await editPreconditioningSchedule(schedule, enabled: newValue)
                                            } catch {
                                                print("Failed to edit preconditioning schedule: \(error)")
                                            }
                                        }
                                    }
                                )) {
                                    EmptyView()
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .red))
                            }
                            
                            .padding(.vertical, 5)
                            .onTapGesture {
                                selectedSchedule = schedule
                                if !showingEditSheet {
                                    showingEditSheet.toggle()
                                }
                            }
                        }
                    }
                } else {
                    Text("No preconditioning schedule data available.")
                }
            }
            .navigationTitle("Schedule")
            .toolbar {
                Button("Add") { showingSheet.toggle()}
            }
            .onAppear {
                Task {
                    await fetchPreconditioningScheduleData()
                }
            }
            .sheet(isPresented: $showingSheet) {
                NavigationStack {
                    CreateScheduleView(isPresented: $showingSheet, vehicle: vehicle, onScheduleAdded: {
                        Task {
                            await fetchPreconditioningScheduleData()
                        }
                    })
                }
            }
            .sheet(item: $selectedSchedule) { schedule in
                NavigationStack {
                    EditScheduleView( schedule: $selectedSchedule, vehicle: vehicle, onScheduleEdited: {
                        Task {
                            await fetchPreconditioningScheduleData()
                        }
                        selectedSchedule = nil
                    })
                }
            }
        }
    }
    
    
    private func fetchPreconditioningScheduleData() async {
        do {
            guard let vehicleVin = vehicle.vin else {
                self.errorMessage = "Vehicle VIN not found."
                self.isLoading = false
                return
            }
            
            // Get the access token from TeslaSwift
            guard let token = teslaSwiftManager.api.token?.accessToken else {
                self.errorMessage = "Access token not available."
                self.isLoading = false
                return
            }
            
            let urlString = "https://fleet-api.prd.na.vn.cloud.tesla.com/api/1/vehicles/\(vehicleVin)/vehicle_data?endpoints=preconditioning_schedule_data"
            guard let url = URL(string: urlString) else {
                self.errorMessage = "Invalid URL."
                self.isLoading = false
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorData = String(data: data, encoding: .utf8) ?? ""
                self.errorMessage = "HTTP Error \(httpResponse.statusCode): \(errorData)"
                self.isLoading = false
                return
            }
            
            // Parse JSON
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                if let scheduleData = apiResponse.response.preconditioningScheduleData {
                    self.preconditioningSchedules = scheduleData.preconditionSchedules
                    self.scheduleEnabledStates = scheduleData.preconditionSchedules.reduce(into: [:]) { result, schedule in
                        result[schedule.id] = schedule.enabled
                    }
                } else {
                    self.errorMessage = "Preconditioning schedule data not found."
                }
            } catch {
                self.errorMessage = "Failed to parse data: \(error.localizedDescription)"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    private func editPreconditioningSchedule(_ preconditioningSchedule: PreconditionSchedule, enabled: Bool) async throws {
        print(preconditioningSchedule.daysOfWeekArray)
        let payload: [String: Any] = [
            "id": preconditioningSchedule.id,
            "days_of_week": preconditioningSchedule.daysOfWeekArray.count > 0 ? preconditioningSchedule.daysOfWeekArray.joined(separator: ",") : "",
            "enabled": enabled,
            "lat": preconditioningSchedule.latitude,
            "lon": preconditioningSchedule.longitude,
            "precondition_time": preconditioningSchedule.preconditionTime,
            "one_time": preconditioningSchedule.oneTime,
        ]
        
        let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        let success = try await vehicleCommand.sendCommand(command: .addPreconditionSchedule, vin: vehicle.vin ?? "", body: jsonBody)
        
        
        
        if success {
            print("Schedule Edited successfully")
            await fetchPreconditioningScheduleData()
            
        } else {
            print("Failed to add schedule")
        }
    }
}



// MARK: - Model Structures

struct APIResponse: Codable {
    let response: VehicleResponse
}

struct VehicleResponse: Codable {
    let preconditioningScheduleData: PreconditioningScheduleData?
}

struct PreconditioningScheduleData: Codable {
    let preconditionSchedules: [PreconditionSchedule]
    let timestamp: Timestamp?
    let preconditioningScheduleWindow: PreconditioningScheduleWindow?
    let maxNumPreconditionSchedules: Int?
    let nextSchedule: Bool?
}

struct PreconditionSchedule: Codable, Identifiable {
    let id: Int
    let name: String
    let daysOfWeek: Int
    let preconditionTime: Int
    let oneTime: Bool
    let enabled: Bool
    let latitude: Double
    let longitude: Double
    
    // Computed properties for formatted display
    var formattedTime: String {
        let hours = preconditionTime / 60
        let minutes = preconditionTime % 60
        
        // Convert 24-hour time to 12-hour format
        let isPM = hours >= 12
        let hour12 = hours % 12 == 0 ? 12 : hours % 12
        
        return String(format: "%02d:%02d %@", hour12, minutes, isPM ? "PM" : "AM")
    }
    
    var daysOfWeekArray: [String] {
        var days = [String]()
        let dayMappings: [(Int, String)] = [
            (1, "Sun"),
            (2, "Mon"),
            (4, "Tue"),
            (8, "Wed"),
            (16, "Thu"),
            (32, "Fri"),
            (64, "Sat")
        ]
        for (bit, day) in dayMappings {
            if daysOfWeek & bit != 0 {
                days.append(day)
            }
        }
        return days
    }
}

struct Timestamp: Codable {
    let seconds: Int
    let nanos: Int
}

struct PreconditioningScheduleWindow: Codable {
    // Define properties if available
    // If the API provides details for this, include them here
}
