
import SwiftUI

struct Devices: View {
    let column = Array(repeating: GridItem(.flexible()), count: 2);
    
    
    var body: some View {
        
        
        HStack(spacing: 20) {
            Spacer()
            // Example for Device 1
            VStack (spacing: 20) {
                
                
                
                ZStack {
                    Color.cardBackground
                        .cornerRadius(15)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "lamp.desk.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                  
                            .foregroundColor(.white)
                        
                        Text("Bedroom Light")
                            .font(.headline)
                            .foregroundColor(.white)
                            
                        
                        CustomToggleView(deviceId: "1") // Device ID for Bedroom Light
                    }
                    .padding()
                }
                .frame(width: 200, alignment: .center)
                
                
                // Example for Device 2
                ZStack {
                    
                    
                    Color.cardBackground
                        .cornerRadius(15)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "fan.desk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            
                            .foregroundColor(.white)
                        
                        Text("Living Room Fan")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        CustomToggleView(deviceId: "2") // Device ID for Living Room TV
                    }
                    .padding()
                    .frame(width: 200, alignment: .center)
                    
                }
            }
            .padding(.leading)
            .frame(alignment: .center)
           
                
                
                
                
            }
        .padding(.leading, 150)
        
            
        
    }
}
