//
//  Untitled.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import HomeKit

struct MainView: View {
    @StateObject private var viewModel = HomeStore()
    @State private var isShowingAddHomeSheet = false
    @State private var newHomeName = ""
    
    var body: some View {
        NavigationStack {
            MainContentView(
                viewModel: viewModel,
                isShowingAddHomeSheet: $isShowingAddHomeSheet,
                newHomeName: $newHomeName
            )
        }
    }
}

// MARK: - Subviews

struct MainContentView: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingAddHomeSheet: Bool
    @Binding var newHomeName: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if !viewModel.authorizationStatus {
                AuthorizationView(errorMessage: viewModel.errorMessage)
            } else {
                HomeListView(
                    viewModel: viewModel,
                    isShowingAddHomeSheet: $isShowingAddHomeSheet,
                    newHomeName: $newHomeName
                )
            }
        }
        .navigationTitle("Select Your Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AddHomeButton(
                    isEnabled: viewModel.authorizationStatus && !viewModel.isLoading,
                    action: { isShowingAddHomeSheet = true }
                )
            }
        }
        .sheet(isPresented: $isShowingAddHomeSheet) {
            AddHomeSheet(
                viewModel: viewModel,
                isShowingSheet: $isShowingAddHomeSheet,
                newHomeName: $newHomeName
            )
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Initializing HomeKit...")
            .progressViewStyle(CircularProgressViewStyle())
    }
}

struct AuthorizationView: View {
    let errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(errorMessage ?? "Waiting for HomeKit authorization...")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct HomeListView: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingAddHomeSheet: Bool
    @Binding var newHomeName: String
    
    var body: some View {
        ScrollView {
            if viewModel.homes.isEmpty {
                EmptyHomeView()
            } else {
                HomeGridView(homes: viewModel.homes)
            }
        }
    }
}

struct EmptyHomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("No Homes Found")
                .font(.headline)
            
            Text("Tap the + button to add a new home")
                .foregroundColor(.secondary)
        }
        .padding(.top, 100)
    }
}

struct HomeGridView: View {
    let homes: [HMHome]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(homes, id: \.uniqueIdentifier) { home in
                HomeCard(home: home)
            }
        }
        .padding(.vertical)
    }
}

struct HomeCard: View {
    let home: HMHome
    
    var body: some View {
        GroupBox(label:
            Label(home.name, systemImage: "house.fill")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text("ID: \(home.uniqueIdentifier.uuidString)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: HomeView(home: home)) {
                    Text("Select")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct AddHomeButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
        }
        .disabled(!isEnabled)
    }
}

struct AddHomeSheet: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingSheet: Bool
    @Binding var newHomeName: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New Home")
                    .font(.headline)
                
                TextField("Enter home name", text: $newHomeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("New Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingSheet = false
                        newHomeName = ""
                        viewModel.errorMessage = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newHomeName.isEmpty {
                            viewModel.addHome(name: newHomeName)
                            isShowingSheet = false
                            newHomeName = ""
                        }
                    }
                    .disabled(newHomeName.isEmpty)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
