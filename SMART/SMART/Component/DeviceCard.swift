//
//  DeviceCard.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import HomeKit

struct DeviceCard: View {
    var home : HMHome
    var accessory: HMAccessory
    @ObservedObject var homeStore: HomeStore
    @State private var isOn: Bool = false // Local state to reflect current power state
    
    var body: some View {
        VStack(spacing: 16) {
            // Device name
            Text(accessory.name)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            
            // Icon or illustration for the device (example system image)
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 36))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(isOn ? .yellow : .gray)
                .padding(.vertical, 6)
                .scaleEffect(isOn ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isOn)
            
            // Toggle button
            Button {
                homeStore.toggleAccessoryState(for: accessory) { success in
                    if success {
                        withAnimation {
                            isOn.toggle()
                        }
                    }
                }
            } label: {
                Text(isOn ? "Turn Off" : "Turn On")
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(isOn ? .red.opacity(0.2) : .blue.opacity(0.2))
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(width: 160)
        // Glass-like background
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            // Rounded border for extra definition
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(isOn ? Color.yellow.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
        }
        .contextMenu {
            Button(role: .destructive) {
                homeStore.removeAccessory(home: home, accessory: accessory)
            } label: {Label("Delete Accessory", systemImage: "trash")}
        }
        
        .shadow(radius: 3)
        // A slight scale effect on press
        .animation(.easeInOut, value: isOn)
        .padding(.vertical, 8)
        .onAppear {
            // Initialize with the accessory’s actual state if needed
            // For example:
            // isOn = homeStore.isAccessoryOn(accessory)
        }
        
    }
}
