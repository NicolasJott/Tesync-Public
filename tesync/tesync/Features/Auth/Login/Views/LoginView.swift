//
//  LoginView.swift
//  tesync
//
//  Created by Nicolas Ott on 9/5/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authModel: AuthModel
    @StateObject var viewModel: LoginModel = LoginModel()
    
    @State var shouldPresentSheet = false
    @State var email: String = ""
    @State var password: String = ""
    
    @State var loginError: Error?
    @State var emailError: String? = nil
    @State var passwordError: String? = nil
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 36) {
                
                VStack(alignment: .leading) {
                    Text("Welcome to Tesync")
                        .font(.largeTitle)
                    Text("Sign in to your account to continue.")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                
                
                VStack(alignment: .leading) {
                    if let error = loginError {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    }
                }
                
                
                VStack(spacing: 48) {
                    VStack(alignment: .leading) {
                        TextField("Email", text: $email)
                            .frame(height: 50)
                            .padding([.leading, .trailing], 10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(emailError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1))
                            .tint(.red)
                        if let emailError = emailError {
                            Text(emailError)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        SecureField("Password", text: $password)
                            .frame(height: 50)
                            .padding([.leading, .trailing], 10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(passwordError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1))
                            .tint(.red)
                        if let passwordError = passwordError {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.caption)
                        } 
                    }
                }
                
                
                Button(action: { if validateFields() {Task {
                    do {
                        let token = try await viewModel.login(email: email, password: password)
                        try await authModel.authenticate(token: token)
                    } catch {
                        print(error)
                        loginError = error
                    }
                }}}) {
                    Spacer()
                    if (viewModel.isLoading) {
                        HStack {
                            Text("Signing in...").foregroundStyle(.background)
                            ProgressView().tint(.black)
                        }.padding(8)
                    } else {
                        Text("Sign in").padding(8).foregroundStyle(.background)
                    }
                    Spacer()
                    
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
                .tint(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
           
                
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up").tint(.red)
                    }
                }
            }.padding(30)
        }.navigationBarBackButtonHidden(true)
    }
    
    func validateFields() -> Bool {
        var isValid = true
        emailError = nil
        passwordError = nil
        
        if email.isEmpty {
            emailError = "Email is required."
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required."
            isValid = false
        }
        
        return isValid
    }
    
    func didDismiss() {
        shouldPresentSheet = false
    }
    
}



#Preview {
    LoginView()
}
