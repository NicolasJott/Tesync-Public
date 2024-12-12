//
//  VehicleInfoList.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI
import TeslaSwift

struct VehicleInfoList: View {
    var vehicle: VehicleExtended
    var body: some View {
        NavigationStack {
            List {
                NavigationLink{
                    VehicleLocation(vehicle: vehicle)
                } label: {
                    VehicleInfoListRow(icon: "location.fill", title: "Location")
                }
                NavigationLink{
                    VehicleClimate(vehicle: vehicle)
                } label: {
                    VehicleInfoListRow(icon: "fan.fill", title: "Climate")
                }
            }
        }
    }
}

