//
//  RoomView.swift
//  SMART
//
//  Created by Anson Jiang on 12/7/24.
//

import SwiftUI
struct RoomView: View {
    let column = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2);
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.darkBackground
                .ignoresSafeArea()
            VStack {
                
                
                VStack {
                    
                    
                    
                    LazyVGrid(columns: column, spacing: 20) {
                        Devices()
                        
                    }
                    .padding()
                    
                }
                
                AddDevices()
                
            }
            
            
          
 
                
                
            
            
            
        }
        
        
    }
}
