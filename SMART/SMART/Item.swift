//
//  Item.swift
//  SMART
//
//  Created by Aryan Palit on 9/19/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
