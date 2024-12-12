//
//  MainButtonsView.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import TeslaSwift

struct MainButtonsView: View {
    var vehicle: VehicleExtended
    
    var body: some View {
        HStack(alignment: .center) {
            LockCommandButton(vehicle: vehicle)
            TrunkCommandButton(vehicle: vehicle)
            ChargingCommandButton(vehicle: vehicle)
            MainButtonView(icon: "lightbulb", command: .flashLights, vehicle: vehicle)
            MainButtonView(icon: "speaker.3", command: .honkHorn, vehicle: vehicle)
        }.offset(y: -50)
    }
}


