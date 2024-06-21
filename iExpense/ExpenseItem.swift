//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Berserk on 21/06/2024.
//

import Foundation
import SwiftData

@Model
class ExpenseItem: Codable {
    
    enum CodingKeys: CodingKey {
        case name
        case type
        case amount
    }
    
    let name: String
    let type: String
    let amount: Double
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.amount = try container.decode(Double.self, forKey: .amount)
    }
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(amount, forKey: .amount)
    }
}
