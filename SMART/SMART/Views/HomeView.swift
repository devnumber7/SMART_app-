//
//  HomeView.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//

import SwiftUI
import HomeKit

struct HomeView: View {
    let home: HMHome
    @StateObject var homeStore = HomeStore()
    
    var body: some View {
        NavigationStack {
            DeviceListView(home: home, homeStore: homeStore)
                .navigationTitle("Dashboard")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}



struct DeviceListView: View {
    let home: HMHome
    @ObservedObject var homeStore: HomeStore
    @State private var isPresentingScanner = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header section (assumes HeaderSection is defined elsewhere)
                HeaderSection(home: home)
                    .overlay(
                        HStack {
                            Spacer()
                            Button {
                                isPresentingScanner = true
                            } label: {
                                Label("Add Device", systemImage: "qrcode.viewfinder")
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }, alignment: .topTrailing
                    )
                
                Text("Connected Devices")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(homeStore.accessoriesInCurrentHome, id: \.uniqueIdentifier) { accessory in
                            // Assumes DeviceCard is defined elsewhere.
                            DeviceCard(home: home, accessory: accessory, homeStore: homeStore)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(), value: home.accessories)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.15), .indigo.opacity(0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear {
            homeStore.loadAccessories(for: home)
        }
        .sheet(isPresented: $isPresentingScanner) {
            MatterQRCodeScannerView { scannedCode in
                print("Scanned Matter device QR code: \(scannedCode)")
                // Insert your logic here to add the Matter device using HomeKit.
            }
            .presentationDetents([.fraction(0.5)])
        }
    }
}
