import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        
        
        
        VStack(alignment: .leading){
            
            // Weather Card
            HStack(spacing: 16) {
                Image(systemName: "wind") // Use the appropriate SF Symbol
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white) // Set color for icon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Windy")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("BlacksBurg")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("30°")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.cardBackground) // Replace with your preferred background color
            .cornerRadius(16)
            
            // Weather Details Grid
            HStack {
                VStack {
                    Text("30°F")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Temp")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("0.5 in")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Precipitation")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("73%")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("18 mph")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Wind")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.cardBackground) // Same background as the top card
            .cornerRadius(16)
        }
        .padding()
        //.background(Color.cardBackground)
        .edgesIgnoringSafeArea(.all)
    }
    
        
        
}
