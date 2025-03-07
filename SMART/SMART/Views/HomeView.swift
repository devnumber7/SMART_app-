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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero-like header with a large “Welcome” text
                HeaderSection(home: home)
                
                // Horizontal scroll for devices (accessories)
                Text("Connected Devices")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(homeStore.accessoriesInCurrentHome, id: \.uniqueIdentifier) { accessory in
                            DeviceCard(home: home,
                                       accessory: accessory,
                                       homeStore: homeStore)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(), value: home.accessories)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        // Remove default scroll background on iOS 16+
        .scrollContentBackground(.hidden)
        .background(
            // A subtle gradient background
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.15), .indigo.opacity(0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        ).onAppear{
            homeStore.loadAccessories(for: home)
        }
    }
}



