//
//  HeaderSection.swift
//  SMART
//
//  Created by Aryan Palit on 3/6/25.
//

import SwiftUI
import HomeKit
struct HeaderSection: View {
    let home: HMHome
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // A subtle SF Symbol icon
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
            
            Text("Welcome Home, \(home.name)!")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("Here’s a quick look at your devices:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
}
