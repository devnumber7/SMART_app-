//
//  Card.swift
//  SMART
//
//  Created by Aryan Palit on 4/30/25.
//

import Foundation
import SwiftUI

struct Card: Hashable, Identifiable{
    var id: String = UUID().uuidString
    var image: String
    
}



let cards : [Card] = [
    .init(image: "Pic 1"),
    .init(image: "Pic 2"),
    .init(image: "Pic 3"),
    .init(image: "Pic 4")
    
]
