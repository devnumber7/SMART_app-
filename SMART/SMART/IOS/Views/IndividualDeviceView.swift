//
//  IndividualDeviceView.swift
//  SMART
//
//  Created by Anson Jiang on 12/7/24.
//
import SwiftUI
struct devices: View {
    @State var isSwitchOn: Bool = true
    
    
    var body: some View {
            ZStack {
                
                Color.cardBackground
                    .cornerRadius(15)

                VStack (spacing: 10){
                    Image(systemName: "bed.double.fill") // Placeholder image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    Text("DeviceName")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    Text(" Devices")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                    
                    HStack {
                                Toggle("Switch", isOn: $isSwitchOn)
                                    .toggleStyle(CustomToggle())
                                    .foregroundStyle(.white)
                            }
                    
                }
                .padding()
                
            }
            
        }
        
        
    
    
}

