//
//  LoginView.swift
//  SMART
//
//  Created by Anson Jiang on 11/13/24.
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showingRegister = false
    @Binding var roomCount: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    viewModel.mockLogin()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                
                Spacer()
                
                Button(action: {
                    showingRegister = true
                }) {
                    Text("Don't have an account? Register")
                }
                .sheet(isPresented: $showingRegister) {
                    RegisterView(viewModel: viewModel)
                }
                
                // NavigationLink to HomeView, triggered by isLoggedIn
                NavigationLink(
                    destination: HomeView(session: viewModel.session, roomCount: $roomCount),
                    isActive: $viewModel.isAuthenticated
                ) {
                    EmptyView()  // Invisible link, activated programmatically
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
