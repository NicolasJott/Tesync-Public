//
//  TeslaLoggedInView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/10/24.
//

import SwiftUI
import TeslaSwift

struct TeslaLoggedInView: View {
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @EnvironmentObject var authModel: AuthModel
    
    @StateObject var vehicleModel = VehicleModel()
    
    
    var body: some View {
        VStack {
            if let currentVehicle = vehicleModel.vehicle {
                VehicleTabView(vehicle: currentVehicle)
            } else if vehicleModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                NoVehiclesView()
            }
        }
        .environmentObject(vehicleModel)
        .onAppear {
            Task {
                vehicleModel.setup(teslaSwiftManager: teslaSwiftManager, authModel: authModel)
            }
        }
        
    }
}

#Preview {
    TeslaLoggedInView()
}
