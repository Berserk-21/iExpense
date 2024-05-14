//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI

struct AddExpenseView: View {
    
    var expense: Expenses
    
    @State private var name = ""
    @State private var type = ""
    @State private var amount = 0.0
    
    let types = ["Business", "Personnal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
        }
    }
}

#Preview {
    AddExpenseView(expense: Expenses())
}
