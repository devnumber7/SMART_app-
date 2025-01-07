import SwiftUI



struct HomeView: View {
    @ObservedObject var session = SessionStore.shared
    
    @Binding var roomCount: Int
    
    let column = Array(repeating: GridItem(.flexible()), count: 2);
    
    var body: some View {
        
        NavigationView {
            
            
            
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading) {
                            Text("Hi Ethan")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.primaryText)
                        }
                        
                        
                        if let user = session.user {
                           
                        }
                        
                        WeatherView()
                        
                        
                        VStack {
                            
                            HStack (alignment: .bottom){
                                Text("Your Rooms")
                                    .font(.title)
                                    .bold()
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                Spacer()
                                AddRoom(roomCount: $roomCount)
                                
                                
                            }
                            
                            
                            
                            LazyVGrid(columns: column) {
                                
                                
                                ForEach(0..<roomCount, id: \.self) { index in
                                    
                                    NavigationLink(destination: RoomView()) {
                                        
                                        RoomCardView(deviceCount: 2, roomName: "Room \(index + 1)" , isSelected: index == 2)
                                    }
                                }
                                .padding()
                                
                                
                            }
                            
                            Button(action: {
                                session.token = nil
                                session.user = nil
                            }) {
                                Text("Logout")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(5)
                            }
                            
                            
                        }
                        .padding()
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
        }
    }
}

