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
    
    var body: some View {
        NavigationStack {
            DeviceListView(home: home)
        }
    }
}


struct DeviceListView: View {
    let home: HMHome
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Personalized header using the home's name
                Text("Welcome Home, \(home.name)!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .padding(.top)
                
                // Section title
                Text("Connected Devices")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Horizontal scroll view for devices (using the home’s accessories)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(home.accessories, id: \.uniqueIdentifier) { accessory in
                            DeviceCard(accessory: accessory)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Dashboard")
    }
}
