//
//  RoomCardView.swift
//  SMART
//
//  Created by Anson Jiang on 11/28/24.
//


import SwiftUI


struct RoomCardView: View {
    var deviceCount: Int
    var roomName : String
    var isSelected : Bool
    var body: some View {
        
        ZStack {
            // Rectangle with gradient border
            Color.cardBackground
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            isSelected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.accentGradientStart, .accentGradientEnd]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                : AnyShapeStyle(Color.clear),
                            lineWidth: 2
                        )
                )
            
            VStack (spacing: 10){
                Image(systemName: "bed.double.fill") // Placeholder image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                Text(roomName)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                
                Text("\(deviceCount) Devices")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
            }
            .padding()
            
        }
        
    }
    
}

