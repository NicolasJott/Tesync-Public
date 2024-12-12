//
//  SettingsView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/15/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authModel: AuthModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if let profile = authModel.profile {
                    Text("\(profile.firstName) \(profile.lastName)")
                    Text("\(profile.email)")
                } else {
                    Text("No profile available")
                }
                List {
                    Section{
                        Button("Log Out") {
                            authModel.logout()
                        }
                        .foregroundStyle(.red)
                    }
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SessionManager())
}
