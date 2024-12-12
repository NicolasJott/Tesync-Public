//
//  BatteryView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/24/24.
//

import SwiftUI

struct BatteryView: View {
    var percentage: Double

    var body: some View {
        HStack(spacing: 1) {
            ZStack(alignment: .leading) {
                // Battery outline
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.primary, lineWidth: 1)
                    .frame(width: 24, height: 12)
                
                // Battery fill based on percentage
                RoundedRectangle(cornerRadius: 2)
                    .fill(batteryColor)
                    .frame(width: fillWidth, height: 10)
                    .padding(.leading, 1)
            }
            // Battery terminal
            Rectangle()
                .fill(Color.primary)
                .frame(width: 2, height: 6)
        }
    }
    
    // Calculate the fill width based on the percentage
    private var fillWidth: CGFloat {
        max(0, min(CGFloat(percentage / 100) * 22, 22))
    }
    
    // Change the battery color based on the percentage
    private var batteryColor: Color {
        switch percentage {
        case 0..<20:
            return .red
        case 20..<50:
            return .orange
        default:
            return .green
        }
    }
}
