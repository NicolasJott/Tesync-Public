//
//  VehicleInfoListRow.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI

struct VehicleInfoListRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.title2)
            VStack {
                Text(title)
                    .font(.title2)
            }
            
            Spacer()
        }.padding(12)
    }
}

#Preview {
    VehicleInfoListRow(icon: "location.fill", title: "Location")
}
