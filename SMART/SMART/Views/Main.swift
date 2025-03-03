//
//  Untitled.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import HomeKit

struct MainView: View {
    @StateObject private var viewModel = HomeKitViewModel()
    @State private var isShowingAddHomeSheet = false
    @State private var newHomeName = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.homes, id: \.uniqueIdentifier) { home in
                        GroupBox(label:
                            Label(home.name, systemImage: "house.fill")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                // Display the unique identifier as a substitute for a location.
                                Text("ID: \(home.uniqueIdentifier.uuidString)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    // Handle home selection action here.
                                    print("Selected home: \(home.name)")
                                }) {
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
                .padding(.vertical)
            }
            .navigationTitle("Select Your Home")
            .toolbar {
                // Add an SF Symbol button to create a new home.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddHomeSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHomeSheet) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Text("Add New Home")
                            .font(.headline)
                        
                        TextField("Enter home name", text: $newHomeName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .navigationTitle("New Home")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                isShowingAddHomeSheet = false
                                newHomeName = ""
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                viewModel.addHome(name: newHomeName)
                                isShowingAddHomeSheet = false
                                newHomeName = ""
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
