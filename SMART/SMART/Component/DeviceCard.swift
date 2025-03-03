//
//  DeviceCard.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import HomeKit

struct DeviceCard: View {
    let accessory: HMAccessory

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Device name using a dynamic, accessible font
            Text(accessory.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .accessibilityLabel("Device name")
                .accessibilityValue(accessory.name)
            
            // Connectivity status indicator (if applicable)
            HStack(spacing: 4) {
                Image(systemName: accessory.isReachable ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(accessory.isReachable ? .green : .yellow)
                    .accessibilityHidden(true)
                Text(accessory.isReachable ? "Connected" : "Not Connected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

