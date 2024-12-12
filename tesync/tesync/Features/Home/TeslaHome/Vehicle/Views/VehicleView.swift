//
//  VehicleView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/15/24.
//

import SwiftUI
import TeslaSwift

struct VehicleView: View {
    var vehicle: VehicleExtended
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var vehicleCommand: VehicleCommandModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 2) {
                VStack {
                    HStack {
                        VehicleDetailsView(vehicle: vehicle)
                        Spacer()
                    }
                    
                    VStack(alignment: .center) {
                        VehicleImgView()
                        MainButtonsView(vehicle: vehicle)
                    }.offset(y: -10)
                }.padding()
                VehicleInfoList(vehicle: vehicle)
                    .offset(y: -50)
            }
            .navigationTitle(vehicleName)
        }
    }
    
    private var vehicleName: String {
        if let vehicleState = vehicle.vehicleState, let vehicleName = vehicleState.vehicleName {
            return vehicleName
        }
        
        return "Tesla"
    }
}


