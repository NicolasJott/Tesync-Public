//
//  SeatView.swift
//  tesync
//
//  Created by Nicolas Ott on 12/12/24.
//

import SwiftUI

struct SeatView: View {
    var seatName: String
    var heaterLevel: Int
    var tapAction: () -> Void
    
    var body: some View {
        Button(action: tapAction) {
            VStack(spacing: 8) {
                Text(seatName)
                    .font(.caption)
                    .foregroundColor(.white)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor(for: heaterLevel))
                    
                    HStack(spacing: 4) {
                        ForEach(1...3, id: \.self) { level in
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                                .foregroundColor(level <= heaterLevel ? .red : .gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func backgroundColor(for level: Int) -> Color {
        switch level {
        case 0:
            return Color.gray.opacity(0.3)
        case 1:
            return Color.orange.opacity(0.3)
        case 2:
            return Color.orange.opacity(0.5)
        case 3:
            return Color.red.opacity(0.5)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

