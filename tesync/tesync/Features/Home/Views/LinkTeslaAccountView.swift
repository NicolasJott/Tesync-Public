//
//  LinkTeslaAccountView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/3/24.
//

import SwiftUI

struct LinkTeslaAccountView: View {
    @State var shouldPresentSheet: Bool = false
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 48) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("You have't linked your Tesla account yet.").font(.title2)
                    Text("Link your Tesla account to start using Tesync.").font(.subheadline).foregroundStyle(.gray)
                }
                
                Button(action: { shouldPresentSheet.toggle()}) {
                    Spacer()
                    
                    Text("Link Tesla Account").padding(8)
                    
                    Spacer()
                    
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
                .tint(.red)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                .sheet(isPresented: $shouldPresentSheet, onDismiss: didDismiss) {
                    TeslaWebLogin()
                }
            }
            .navigationTitle("Link Tesla Account")
            .toolbar {
                Button("Log out") {
                    authModel.logout()
                }
            }
            .padding()
        }
        
    }
    
    func didDismiss() {
        shouldPresentSheet = false
    }
}

#Preview {
    LinkTeslaAccountView().environmentObject(TeslaSwiftManager())
}
