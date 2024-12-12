//
//  EditScheduleView.swift
//  tesync
//
//  Created by Nicolas Ott on 11/29/24.
//

import SwiftUI
import TeslaSwift

struct EditScheduleView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @Binding var schedule: PreconditionSchedule?
    
    // inputs
    var vehicle: Vehicle
    
    var onScheduleEdited: () -> Void
    
    @State private var time: Date = Date()
    @State private var repeatWeekly: Bool = false
    @State private var selectedDays: [ScheduleDay] = [.mon]
    
    @State private var editLoading: Bool = false
    @State private var deleteLoading: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(ScheduleDay.allCases) { day in
                            Button(action: {
                                toggleDay(day)
                            }) {
                                Text(day.description)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedDays.contains(day) ? Color.red : Color.gray.opacity(0.0))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }.background(Color.gray.opacity(0.2)).cornerRadius(8)
                    
                    
                    DatePicker("Time",
                               selection: $time,
                               displayedComponents: .hourAndMinute
                    )
                    Toggle("Repeat Weekly", isOn: $repeatWeekly)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 24) {
                    Button(action: {Task {
                        await editPreconditioningSchedule()
                    }}) {
                        Spacer()
                
                        if (editLoading) {
                            HStack {
                                Text("Updating Schedule...")
                                ProgressView().tint(.white)
                            }.padding(8)
                        } else {
                            Text("Update Schedule").padding(8)
                        }
                       
                        Spacer()
                    }.disabled(selectedDays.isEmpty)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .tint(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    
                    Button(action: {
                        Task {
                            await deleteSchedule()
                        }
                    }) {
                        Spacer()
                
                        if (deleteLoading) {
                            HStack {
                                Text("Deleting Schedule...").tint(.red)
                                ProgressView().tint(.red)
                            }.padding(8)
                        } else {
                            Text("Delete Schedule").padding(8).foregroundStyle(.red)
                        }
                       
                        Spacer()
                    }.disabled(selectedDays.isEmpty)
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                
            }
        }
        .navigationTitle("Edit Schdule")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Cancel") { schedule = nil}
        }
        .padding(24)
        .onAppear {
            setup()
        }
    }
    
    
    private func setup() {
        guard let preconditionSchedule = schedule else { return }
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        time = Date(timeInterval: TimeInterval(preconditionSchedule.preconditionTime * 60), since: todayStart)
        repeatWeekly = !preconditionSchedule.oneTime
        selectedDays = preconditionSchedule.daysOfWeekArray.compactMap { ScheduleDay(rawValue: $0) }
    }
    
    private func toggleDay(_ day: ScheduleDay) {
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
    }
    
    private func editPreconditioningSchedule() async {
        editLoading = true
        defer {
            editLoading = false
        }
        guard !selectedDays.isEmpty else {
            print("Please select at least one day")
            return
        }
        
        let commaSeparatedDays = selectedDays.map { $0.rawValue.capitalized }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        guard let hour = components.hour, let minute = components.minute else {
            print("Failed to extract time components.")
            return
        }
        
        let preconditionTime = (hour * 60) + minute
        
        do {
            // Fetch vehicle location
            let vehicleData = try await teslaSwiftManager.api.getAllData(vehicle, endpoints: [.locationData])
            guard let latitude = vehicleData.driveState?.latitude,
                  let longitude = vehicleData.driveState?.longitude else {
                print("Unable to retrieve vehicle location")
                return
            }
            
            guard let preconditionSchedule = schedule else {
                return
            }
            
            let payload: [String: Any] = [
                "id": preconditionSchedule.id,
                "days_of_week": commaSeparatedDays.joined(separator: ","),
                "enabled": true,
                "lat": latitude,
                "lon": longitude,
                "precondition_time": preconditionTime,
                "one_time": !repeatWeekly,
            ]
            
            
            let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            let success = try await vehicleCommand.sendCommand(command: .addPreconditionSchedule, vin: vehicle.vin ?? "", body: jsonBody)
            
            
            
            if success {
                
                // callback for schedule added
                onScheduleEdited()
                
                // close sheet
                schedule = nil
            } else {
                print("Failed to edit schedule")
            }
        } catch {
            print("Error occurred while editing schedule: \(error)")
        }
    }
    
    private func deleteSchedule() async {
        deleteLoading = true
        defer {
            deleteLoading = false
        }
        
        do {
            guard let precondtionSchedule = schedule else { return }
            
            let payload: [String: Any] = [
                "id": precondtionSchedule.id
            ]
            let jsonBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            let success = try await vehicleCommand.sendCommand(command: .removePreconditionSchedule, vin: vehicle.vin ?? "", body: jsonBody)
            
            if success {
                print("Schedule added successfully")
                
                // callback for schedule added
                onScheduleEdited()
                
                // close sheet
                schedule = nil
            } else {
                print("Failed to add schedule")
            }
        } catch {
            print("error deleting schedule\(error)")
        }
    }
    
}


