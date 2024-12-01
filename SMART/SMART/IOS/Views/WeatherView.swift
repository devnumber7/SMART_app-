import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        
        
        
        VStack(alignment: .leading){
            
            // Weather Card
            HStack(spacing: 16) {
                Image(systemName: "cloud.sun.fill") // Use the appropriate SF Symbol
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow) // Set color for icon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mostly Cloudy")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Sydney, Australia")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("22°")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.cardBackground) // Replace with your preferred background color
            .cornerRadius(16)
            
            // Weather Details Grid
            HStack {
                VStack {
                    Text("27°C")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Sensible")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("4%")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Precipitation")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("66%")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("16 km/h")
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
