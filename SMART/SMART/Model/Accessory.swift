//
//  Device.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI
import SwiftData


// Sample device model for demonstration
struct Accessory: Identifiable {
    let id = UUID()
    let name: String
    let status: String
}

