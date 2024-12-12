//
//  HomeView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/12/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var teslaSwiftManager: TeslaSwiftManager
    @Environment(VehicleData.self) var vehicleData
    @EnvironmentObject var authModel: AuthModel

    @State private var teslaAccountModel = TeslaAccountModel()
    
    
    var body: some View {
        
        VStack {
            if let profile = authModel.profile {
                if (profile.teslaAccount == nil) {
                    LinkTeslaAccountView()
                        .environmentObject(teslaAccountModel)
                } else {
                    TeslaHomeView()
                        .environmentObject(teslaAccountModel)
                }
            }
        }
    }

}

#Preview {
    HomeView()
        .environmentObject(SessionManager())
        .environmentObject(TeslaSwiftManager())
        .environmentObject(AuthModel())
}
