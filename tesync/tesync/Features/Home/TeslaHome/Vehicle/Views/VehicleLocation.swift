//
//  VehicleLocation.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import MapKit
import TeslaSwift

struct VehicleLocation: View {
    
    var vehicle: VehicleExtended
    
    var body: some View {
        if let driveState = vehicle.driveState, let latitude = driveState.latitude, let longitude = driveState.longitude {
            MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
      
    }
}

