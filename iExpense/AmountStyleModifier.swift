//
//  AmountStyleModifier.swift
//  iExpense
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI

struct AmountStyleModifier: ViewModifier {
    
    let amount: Double
    
    func body(content: Content) -> some View {
        
        if amount < 10 {
            content
                .font(.title)
                .foregroundStyle(.green)
        } else if amount < 100 {
            content
                .font(.title)
                .foregroundStyle(.orange)
        } else {
            content
                .font(.title)
                .foregroundStyle(.red)
        }
    }
}
