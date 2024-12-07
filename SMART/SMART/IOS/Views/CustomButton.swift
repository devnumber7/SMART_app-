//
//  CustomButton.swift
//  SMART
//
//  Created by Anson Jiang on 12/7/24.
//
import SwiftUI
struct AddRoom: View {
    var body: some View {
        Button(action: {}) {
            Text("ADD")
                .font(.title)
                
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(width: 100)
                
        }
        .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        .cornerRadius(15)
        
        
    }
    
}

struct AddDevices: View {
    var body: some View {
        Button(action: {}) {
            Text("+")
                .font(.title)
                
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(width: 100)
                
        }
        .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        .cornerRadius(70)
    }
}
