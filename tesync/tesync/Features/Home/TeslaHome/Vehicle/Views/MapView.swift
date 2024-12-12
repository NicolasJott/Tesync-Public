//
//  MapView.swift
//  tesync
//
//  Created by Nicolas Ott on 11/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(position: .constant(.region(region))) {
                Marker("Vehicle Location", coordinate: coordinate )
                    .tint(.red)
        }
    }
    
    private var region: MKCoordinateRegion {
           MKCoordinateRegion(
               center: coordinate,
               span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
           )
       }
}

