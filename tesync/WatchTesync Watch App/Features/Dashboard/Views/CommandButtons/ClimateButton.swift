//
//  ClimateButton.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift

struct ClimateButton: View {
    @State private var showingClimateSheet: Bool = false
    
    var vehicle: VehicleExtended
    
    var body: some View {
        Button(action: {
            WKInterfaceDevice.current().play(.click)
            showingClimateSheet.toggle()
        }) {
            Image(systemName: "fanblades.fill")
                .foregroundColor(.white)
        }.sheet(isPresented: $showingClimateSheet) {
            ClimateControlView(vehicle: vehicle)
        }
    }
}
