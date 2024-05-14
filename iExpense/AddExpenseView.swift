//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
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
            .toolbar {
                Button("Save") {
                    let expenseItem = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(expenseItem)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpenseView(expenses: Expenses())
}
