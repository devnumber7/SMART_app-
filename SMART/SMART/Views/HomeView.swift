//
//  HomeView.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//

import SwiftUI
import HomeKit

// MARK: - Home View
struct HomeView: View {
    @State var home: HMHome
    @StateObject var homeStore = HomeStore()
    
    var body: some View {
        NavigationStack {
            DeviceListView(home: home, homeStore: homeStore)
                .navigationTitle("Dashboard")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .refreshable {
            // Asynchronously fetch updated homes from HomeStore.
            await homeStore.fetchHomes()
            // Find the updated home (with new rooms, if any) based on uniqueIdentifier.
            if let updatedHome = homeStore.homes.first(where: { $0.uniqueIdentifier == home.uniqueIdentifier }) {
                home = updatedHome
            }
        }
    }
}

// MARK: - Device List View with Room Feature
struct DeviceListView: View {
    let home: HMHome
    @ObservedObject var homeStore: HomeStore
    @State private var isPresentingScanner = false
    @State private var selectedRoom: HMRoom? = nil
    @State private var isPresentingAddRoomSheet = false

    // Filter accessories by the selected room (if any)
    var filteredAccessories: [HMAccessory] {
        if let room = selectedRoom {
            // Hypothetical filtering logic using a room property.
            // In HomeKit, you might instead perform a lookup with home.roomForAccessory(accessory).
            return homeStore.accessoriesInCurrentHome.filter { accessory in
                accessory.room == room
            }
        } else {
            return homeStore.accessoriesInCurrentHome
        }
    }

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
                
                // Room selector section
                RoomSelectorView(
                    rooms: home.rooms,
                    selectedRoom: $selectedRoom,
                    onAddRoom: {
                        isPresentingAddRoomSheet = true
                    },
                    onDeleteRoom: { room in
                        // Delete the room using HomeKit API.
                        home.removeRoom(room) { error in
                            if let error = error {
                                print("Error deleting room \(room.name): \(error.localizedDescription)")
                            } else {
                                print("Room \(room.name) deleted successfully.")
                                // Clear the selection if the deleted room was selected.
                                if selectedRoom?.uniqueIdentifier == room.uniqueIdentifier {
                                    selectedRoom = nil
                                }
                            }
                        }
                    }
                )
                .padding(.horizontal)
                
                Text("Connected Devices")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(filteredAccessories, id: \.uniqueIdentifier) { accessory in
                            // Assumes DeviceCard is defined elsewhere.
                            DeviceCard(home: home, accessory: accessory, homeStore: homeStore)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(), value: filteredAccessories)
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
        .sheet(isPresented: $isPresentingAddRoomSheet) {
            AddRoomSheet(home: home)
        }
    }
}

// MARK: - Room Selector View
struct RoomSelectorView: View {
    let rooms: [HMRoom]
    @Binding var selectedRoom: HMRoom?
    let onAddRoom: () -> Void
    let onDeleteRoom: (HMRoom) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "All" button to show accessories from all rooms.
                Button(action: {
                    selectedRoom = nil
                }) {
                    Text("All")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(selectedRoom == nil ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                // List available rooms.
                ForEach(rooms, id: \.uniqueIdentifier) { room in
                    Button(action: {
                        selectedRoom = room
                    }) {
                        Text(room.name)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedRoom?.uniqueIdentifier == room.uniqueIdentifier ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    // Add a context menu for deleting a room.
                    .contextMenu {
                        Button(role: .destructive) {
                            onDeleteRoom(room)
                        } label: {
                            Label("Delete Room", systemImage: "trash")
                        }
                    }
                }
                
                // Button to add a new room.
                Button(action: {
                    onAddRoom()
                }) {
                    Image(systemName: "plus")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - Add Room Sheet
struct AddRoomSheet: View {
    let home: HMHome
    @Environment(\.dismiss) var dismiss
    @State private var roomName: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter room name", text: $roomName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Add Room") {
                    home.addRoom(withName: roomName) { room, error in
                        if let error = error {
                            print("Error adding room: \(error)")
                        } else {
                            // Optionally refresh rooms if needed.
                        }
                    }
                    dismiss()
                }
                .disabled(roomName.isEmpty)
                Spacer()
            }
            .navigationTitle("Add New Room")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

