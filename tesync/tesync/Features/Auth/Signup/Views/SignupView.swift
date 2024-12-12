//
//  SignupView.swift
//  tesync
//
//  Created by Nicolas Ott on 10/2/24.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authModel: AuthModel
    @StateObject var viewModel: SignupModel = SignupModel()
    
    @State var shouldPresentSheet = false
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var signupError: Error?
    @State var nameError: String? = nil
    @State var emailError: String? = nil
    @State var passwordError: String? = nil
    @State var confirmPasswordError: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 36) {
                    
                    VStack(alignment: .leading) {
                        Text("Create an account")
                            .font(.largeTitle)
                        Text("Get started with Tesync.")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        if let error = signupError {
                            Text(error.localizedDescription)
                                .foregroundColor(.red)
                        }
                    }
                    
                    
                    VStack(spacing: 36) {
                        VStack(alignment: .leading){
                            Text("Name")
                            TextField("", text: $name)
                                .frame(height: 50)
                                .padding([.leading, .trailing], 10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(nameError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1)).tint(.red)
                            if let nameError = nameError {
                                Text(nameError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                            TextField("", text: $email)
                                .frame(height: 50)
                                .padding([.leading, .trailing], 10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(emailError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1)).tint(.red)
                            if let emailError = emailError {
                                Text(emailError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                            SecureField("", text: $password)
                                .frame(height: 50)
                                .padding([.leading, .trailing], 10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(passwordError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1)).tint(.red)
                            if let passwordError = passwordError {
                                Text(passwordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Confirm Password")
                            SecureField("", text: $confirmPassword)
                                .frame(height: 50)
                                .padding([.leading, .trailing], 10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(confirmPasswordError == nil ? .gray.opacity(0.4) : .red, lineWidth: 1)).tint(.red)
                            if let confirmPasswordError = confirmPasswordError {
                                Text(confirmPasswordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    
                    Button(action: { if validateFields() { Task {
                        do {
                            let token = try await viewModel.signup(email: email, password: password, name: name)
                            try await authModel.authenticate(token: token)
                        } catch {
                            signupError = error
                        }
                    }}}) {
                        Spacer()
                        if (viewModel.isLoading) {
                            HStack {
                                Text("Signing in...").foregroundStyle(.background)
                                ProgressView().tint(.black)
                            }.padding(8)
                        } else {
                            Text("Sign up").padding(8).foregroundStyle(.background)
                        }
                        Spacer()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .tint(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    
                    HStack {
                        Text("Already have an account?")
                        NavigationLink(destination: LoginView()) {
                            Text("Sign in").tint(.red)
                        }
                    }
                    
                }
            }.padding(30)
            
        }.navigationBarBackButtonHidden(true)
    }
    
    func validateFields() -> Bool {
        var isValid = true
        nameError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        
        if name.isEmpty {
            nameError = "Name is required."
            isValid = false
        }
        
        if email.isEmpty {
            emailError = "Email is required."
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required."
            isValid = false
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required."
            isValid = false
        }
        
        if confirmPassword != password && !confirmPassword.isEmpty {
            confirmPasswordError = "Passwords do not match."
            isValid = false
        }
        
        return isValid
    }
    
}

#Preview {
    SignupView()
}
