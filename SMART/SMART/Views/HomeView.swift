//
//  HomeView.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            DeviceListView()
        }
    }
}

// Example sample data
let sampleDevices = [
    Device(name: "Living Room TV", status: "Active"),
    Device(name: "Bedroom Speaker", status: "Idle"),
    Device(name: "Kitchen Fridge", status: "Active")
]


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct DeviceListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Welcome Home!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .padding(.top)
                
                // Section Title
                Text("Connected Devices")
                    .font(.headline)
                    .foregroundColor(.secondary)
        
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(sampleDevices) { device in
                            DeviceCard(device: device)
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
