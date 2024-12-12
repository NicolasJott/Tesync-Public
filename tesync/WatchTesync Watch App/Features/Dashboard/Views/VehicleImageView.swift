//
//  VehicleImageView.swift
//  WatchTesync Watch App
//
//  Created by Nicolas Ott on 12/3/24.
//

import SwiftUI

struct VehicleImageView: View {
    var body: some View {
        Image("model3")
            .resizable()
            .scaledToFill()
            .frame(width: 300)
    }
}

#Preview {
    VehicleImageView()
}
