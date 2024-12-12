//
//  VehicleImageView.swift
//  tesync
//
//  Created by Nicolas Ott on 12/5/24.
//

import SwiftUI

struct VehicleImgView: View {
    var body: some View {
        Image("model3")
            .resizable()
            .scaledToFit()
            .frame(width: 500)
    }
}

#Preview {
    VehicleImgView()
}
