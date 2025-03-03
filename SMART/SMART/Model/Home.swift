//
//  Home.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//

import SwiftUI


// Sample data model
struct Home: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let devices : [Accessory]
}
