//
//  Untitled.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
// Main View remains largely unchanged

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
            .navigationTitle("Select Your Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddHomeButton(
                        isEnabled: viewModel.authorizationStatus && !viewModel.isLoading,
                        action: { isShowingAddHomeSheet = true }
                    )
                }
            }
        }
        // Use .primary as accent, or customize
        .accentColor(.primary)
        // Use a custom background gradient
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.indigo.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        // Modern iOS 16 style for list/scroll backgrounds
        .scrollContentBackground(.hidden)
        // Bind the sheet presentation to our boolean
        .sheet(isPresented: $isShowingAddHomeSheet) {
            AddHomeSheet(
                viewModel: viewModel,
                isShowingSheet: $isShowingAddHomeSheet,
                newHomeName: $newHomeName
            )
        }
    }
}

// MARK: - Main Content and Loading/Authorization Views

struct MainContentView: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingAddHomeSheet: Bool
    @Binding var newHomeName: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
                    .transition(.opacity)
            } else if !viewModel.authorizationStatus {
                AuthorizationView(errorMessage: viewModel.errorMessage)
                    .transition(.slide)
            } else {
                HomeListView(
                    viewModel: viewModel,
                    isShowingAddHomeSheet: $isShowingAddHomeSheet,
                    newHomeName: $newHomeName
                )
                .transition(.move(edge: .bottom))
            }
        }
        // Extra spacing & safe area insets
        .padding(.top, 8)
        .animation(.easeInOut, value: viewModel.isLoading)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Initializing HomeKit...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }
}

struct AuthorizationView: View {
    let errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "house.circle")
                .font(.system(size: 70))
                .foregroundStyle(.primary)
                .padding(.top, 40)
            
            Text(errorMessage ?? "Waiting for HomeKit authorization...")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            Button {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            } label: {
                Text("Open Settings")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .cornerRadius(16)
        .padding()
    }
}

// MARK: - Home List with Deletion Confirmation

struct HomeListView: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingAddHomeSheet: Bool
    @Binding var newHomeName: String
    
    // State for deletion confirmation
    @State private var homePendingDeletion: HMHome? = nil
    
    var body: some View {
        ScrollView {
            if viewModel.homes.isEmpty {
                EmptyHomeView()
                    .padding(.top, 80)
            } else {
                HomeGridView(homes: viewModel.homes) { home in
                    homePendingDeletion = home
                }
            }
        }
        // Pull-to-refresh
        .refreshable {
            await viewModel.fetchHomes()
        }
        // Confirmation dialog for deletion
        .confirmationDialog("Delete Home",
                            isPresented: Binding<Bool>(
                                get: { homePendingDeletion != nil },
                                set: { if !$0 { homePendingDeletion = nil } }
                            ),
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let home = homePendingDeletion {
                    viewModel.deleteHome(home: home)
                }
                homePendingDeletion = nil
            }
            Button("Cancel", role: .cancel) {
                homePendingDeletion = nil
            }
        }
    }
}

struct EmptyHomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(.blue)
            
            Text("No Homes Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add a new home")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 100)
    }
}

// MARK: - Grid & Card with Deletion Support

struct HomeGridView: View {
    let homes: [HMHome]
    let onDelete: (HMHome) -> Void
    
    // Adaptive grid layout for modern responsiveness
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150), spacing: 16)]
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(homes, id: \.uniqueIdentifier) { home in
                HomeCard(home: home) {
                    onDelete(home)
                }
                // Animate each card’s appearance slightly
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .animation(.spring(), value: homes)
    }
}

struct HomeCard: View {
    let home: HMHome
    var deleteAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Label {
                Text(home.name)
                    .font(.headline)
            } icon: {
                Image(systemName: "house.fill")
            }
            .foregroundStyle(.primary)
            
            // ID or any extra info
            Text("ID: \(home.uniqueIdentifier.uuidString)")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            // Navigation to detail
            NavigationLink(destination: HomeView(home: home)) {
                Text("Select")
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        // Glassy material background
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
        // Context menu for quick delete
        .contextMenu {
            Button(role: .destructive) {
                deleteAction?()
            } label: {
                Label("Delete Home", systemImage: "trash")
            }
        }
    }
}

// MARK: - Toolbar Add Button

struct AddHomeButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.headline)
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Add Home Sheet

struct AddHomeSheet: View {
    @ObservedObject var viewModel: HomeStore
    @Binding var isShowingSheet: Bool
    @Binding var newHomeName: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New Home")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                TextField("Enter home name", text: $newHomeName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newHomeName.isEmpty {
                            viewModel.addHome(name: newHomeName)
                            dismissSheet()
                        }
                    }
                    .disabled(newHomeName.isEmpty)
                }
            }
        }
        // Use a medium detent for a compact sheet
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    private func dismissSheet() {
        isShowingSheet = false
        newHomeName = ""
        viewModel.errorMessage = nil
    }
}

