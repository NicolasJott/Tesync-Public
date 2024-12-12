//
//  BatteryRangeView.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/2/24.
//

import SwiftUI
import TeslaSwift

struct BatteryRangeView: View {
    var batteryLevel: Int
    var range: Int
    
    @State private var showPercent: Bool = false
    
    var body: some View {
        ZStack {
            ProgressView(value: Double(batteryLevel) / 100)
                .progressViewStyle(.circular)
                .tint(batteryTintColor)
                .frame(width: 100, height: 100)
            
            VStack {
                Text(!showPercent ? "\(range)" : "\(Int(batteryLevel))%")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold))
                    .offset(y: !showPercent ? 4 : 0)
                
                if !showPercent {
                    Text("mi")
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                        .offset(y: -1)
                    
                }
            }
        }.onTapGesture {
            showPercent = !showPercent
        }.sensoryFeedback(.impact, trigger: showPercent)
    }
    
    var batteryTintColor: Color {
        switch batteryLevel {
        case 51...100: return .green
        case 21...50: return .yellow
        default: return .red
        }
    }
}

#Preview {
    BatteryRangeView(batteryLevel: 80, range:320)
}
