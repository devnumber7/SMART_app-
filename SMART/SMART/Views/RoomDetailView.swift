//
//  RoomDetailView.swift
//  SMART
//
//  Created by Aryan Palit on 4/30/25.
//

import SwiftUI
import SwiftData

struct RoomDetailView: View {
    let room: Room
    @State private var activeDevices: [String] = ["Smart Bulb", "Thermostat", "Security Camera"] // Placeholder
    @State private var connectedDevices: [String] = ["Smart Lock", "Speaker", "Smart Plug"] // Placeholder
    @State private var isAddingNewDevice = false
    @State private var newDeviceName = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Room Name Header
                Text(room.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                // Active Devices Section
                Section(header: Text("Active Devices")
                    .font(.headline)
                    .padding(.vertical)) {
                    if activeDevices.isEmpty {
                        Text("No active devices currently.")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(activeDevices, id: \.self) { deviceName in
                                    DeviceCardView(deviceName: deviceName, isActive: true)
                                        .padding(.trailing, 10)
                                }
                                Button {
                                    isAddingNewDevice = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)

                // Connected Devices Section
                Section(header: Text("Connected Devices")
                    .font(.headline)
                    .padding(.vertical)) {
                    if connectedDevices.isEmpty {
                        Text("No devices connected to this room.")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(connectedDevices, id: \.self) { deviceName in
                                    DeviceCardView(deviceName: deviceName, isActive: false)
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)

                // Room Settings
                Section(header: Text("Room Settings")
                    .font(.headline)
                    .padding(.vertical)) {
                    List {
                        NavigationLink("Automation") {
                            Text("Automation Settings for \(room.name)")
                        }
                        NavigationLink("Scenes") {
                            Text("Scene Settings for \(room.name)")
                        }
                        NavigationLink("Room Information") {
                            Text("Information about \(room.name)")
                        }
                    }
                }
                .padding(.bottom)

                // History/Logs (Example of another scrollable section)
                Section(header: Text("Recent Activity")
                    .font(.headline)
                    .padding(.vertical)) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(0..<5) { i in
                                Text("\(Date().formatted(date: .numeric, time: .shortened)): \(activeDevices.randomElement() ?? "Device") status updated.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 2)
                            }
                        }
                    }
                    .frame(height: 80)
                }
                .padding(.bottom)
            }
            .padding()
        }
        .navigationTitle(room.name)
        .sheet(isPresented: $isAddingNewDevice) {
            VStack {
                Text("Add New Device")
                    .font(.title2)
                    .padding()
                TextField("Device Name", text: $newDeviceName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button("Cancel") {
                        isAddingNewDevice = false
                        newDeviceName = ""
                    }
                    .padding()
                    Button("Add") {
                        if !newDeviceName.isEmpty {
                            // In a real app, you'd have logic to determine if it's active/connected
                            connectedDevices.append(newDeviceName)
                            newDeviceName = ""
                            isAddingNewDevice = false
                        }
                    }
                    .padding()
                    .bold()
                }
            }
            .presentationDetents([.medium])
        }
    }
}

// Individual Device Card in the horizontal scroll view
struct DeviceCardView: View {
    let deviceName: String
    let isActive: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isActive ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            .frame(width: 120, height: 80)
            .overlay(
                VStack {
                    Image(systemName: getRandomDeviceIcon(isActive: isActive))
                        .font(.title2)
                        .foregroundColor(isActive ? .blue : .gray)
                    Text(deviceName)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            )
            .padding(.trailing, 10)
    }

    // Placeholder function to get random device icons based on active state
    func getRandomDeviceIcon(isActive: Bool) -> String {
        let activeIcons = ["lightbulb.fill", "thermometer", "camera.fill"]
        let connectedIcons = ["lock.fill", "speaker.fill", "powerplug.fill"]
        return isActive ? (activeIcons.randomElement() ?? "checkmark.circle.fill") : (connectedIcons.randomElement() ?? "link")
    }
}

#Preview {
    let config = ModelConfiguration()
    let container = try! ModelContainer(for: Room.self, configurations: config)
    NavigationStack {
        RoomDetailView(room: Room(name: "Bedroom"))
            .modelContainer(container)
    }
}
