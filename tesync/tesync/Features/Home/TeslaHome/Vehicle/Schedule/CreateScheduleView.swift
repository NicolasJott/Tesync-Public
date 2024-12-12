//
//  CreateScheduleView.swift
//  tesync
//
//  Created by Nicolas Ott on 11/14/24.
//

import SwiftUI
import TeslaSwift

struct CreateScheduleView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    @Binding var isPresented: Bool
    
    // inputs
    var vehicle: Vehicle
    var onScheduleAdded: () -> Void
    
    @State private var time: Date = Date()
    @State private var repeatWeekly: Bool = true
    @State private var selectedDays: [ScheduleDay] = []
    
    @State private var addLoading: Bool = false
    
    var body: some View {
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
                    await addPreconditioningSchedule()
                }}) {
                    Spacer()
            
                    if (addLoading) {
                        HStack {
                            Text("Saving Schedule...")
                            ProgressView().tint(.white)
                        }.padding(8)
                    } else {
                        Text("Save Schedule").padding(8)
                    }
                   
                    Spacer()
                }.disabled(selectedDays.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .tint(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            
        }.navigationTitle("Add Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") { self.isPresented.toggle()}
            }
            .padding(24)
    }
    
    private func toggleDay(_ day: ScheduleDay) {
        if let index = selectedDays.firstIndex(of: day) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(day)
        }
    }
    
    private func addPreconditioningSchedule() async {
        addLoading = true
        defer { addLoading = false }
        
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
            
            let payload: [String: Any] = [
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
                print("Schedule added successfully")
                
                // callback for schedule added
                onScheduleAdded()
                
                // close sheet
                isPresented.toggle()
            } else {
                print("Failed to add schedule")
            }
        } catch {
            print("Error occurred while adding schedule: \(error)")
        }
    }
    
    
    
    
}


// MARK: - Model Structures
enum ScheduleDay: String, CaseIterable, Identifiable {
    case sun = "Sun",
         mon = "Mon",
         tue = "Tue",
         wed = "Wed",
         thu = "Thu",
         fri = "Fri",
         sat = "Sat"
    var id: Self { self }
    
    var description: String {
        get {
            switch self {
            case .sun:
                return "Sun"
            case .mon:
                return "Mon"
            case .tue:
                return "Tue"
            case .wed:
                return "Wed"
            case .thu:
                return "Thu"
            case .fri:
                return "Fri"
            case .sat:
                return "Sat"
            }
        }
    }
}
