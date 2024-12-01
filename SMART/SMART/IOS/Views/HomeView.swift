import SwiftUI

struct HomeView: View {
    @ObservedObject var session = SessionStore.shared
    
    
    
    let column = Array(repeating: GridItem(.flexible()), count: 2);
    
    var body: some View {
        

        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        Text("Hi Maria")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.primaryText)
                    }
                    
                    
                    if let user = session.user {
                        Text("Welcome, \(user.username)!")
                            .font(.title)
                    }
                    
                    WeatherView()
                    
                    
                    VStack {
                        
                        HStack (alignment: .bottom){
                            Text("Your Devices")
                                .font(.title)
                                .bold()
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                Spacer()
                            Button(action: {}) {
                                
                                
                               
                                    
                            }
                                
                                
                        }
                        
                        
                        
                        LazyVGrid(columns: column) {
                            ForEach(0..<6) { index in
                                Button(action: {
                                    // Action for each grid item (currently does nothing)
                                }) {
                                    RoomCardView(deviceCount: 1, roomName: "Don", isSelected: index == 2 ? true: false )
                                        .buttonStyle(PlainButtonStyle())
                                    
                                    
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

