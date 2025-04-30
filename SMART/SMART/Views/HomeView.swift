//
//  DeviceRowView.swift
//  SMART
//
//  Created by Aryan Palit on 4/29/25.
//
import SwiftUI
import SwiftData

@Model
final class Room {
    var name: String
    @Attribute(.unique) var id: UUID

    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var rooms: [Room]
    @State private var isAddingNewRoom = false
    @State private var newRoomName = ""

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack { // Added bottom padding here
                Text("Your Smart Home")
                    .font(.largeTitle)
                    .padding(.top)
                    .bold()

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(rooms) { room in
                            NavigationLink(destination: RoomDetailView(room: room)) {
                                RoomCardView(room: room)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteRoom(room)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }

                Button {
                    isAddingNewRoom = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Room")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.bottom, 65) // Add bottom padding to make space for the tab bar
            }
            .sheet(isPresented: $isAddingNewRoom) {
                VStack {
                    Text("Add New Room")
                        .font(.title2)
                        .padding()

                    TextField("Room Name", text: $newRoomName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled()
                    

                    HStack {
                        Button("Cancel") {
                            isAddingNewRoom = false
                            newRoomName = ""
                        }
                        .padding()

                        Button("Add") {
                            addRoom()
                            isAddingNewRoom = false
                            newRoomName = ""
                        }
                        .padding()
                        .bold()
                    }
                }
                .presentationDetents([.medium])
            }
            .navigationTitle("Home")
        }
    }

    func addRoom() {
        let newRoom = Room(name: newRoomName)
        modelContext.insert(newRoom)
    }

    func deleteRoom(_ room: Room) {
        modelContext.delete(room)
    }
}

struct RoomCardView: View {
    let room: Room

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 120)
            .overlay(
                Text(room.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            )
            .padding(5)
    }
}


#Preview {
    let config = ModelConfiguration()
    let container = try! ModelContainer(for: Room.self, configurations: config)
    return HomeView()
        .modelContainer(container)
}
