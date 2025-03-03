//
//  DeviceCard.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//

import SwiftUI

// A card view to display each device
struct DeviceCard: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Icon with a material background for depth
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 40))
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
            Text(device.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(device.status)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}
