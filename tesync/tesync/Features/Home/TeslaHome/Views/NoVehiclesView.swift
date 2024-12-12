//
//  NoVehiclesView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/15/24.
//

import SwiftUI

struct NoVehiclesView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var authModel: AuthModel

    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text("You dont have any vehicles.")
                    .font(.largeTitle)
                Text("Add a vehicles to your Tesla account to continue to Tesync.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button("Logout") {
                authModel.logout()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
        }
        .padding(24)
    }
}

#Preview {
    NoVehiclesView()
        .environmentObject(SessionManager())
}
