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
    @State private var type = ExpenseType.business
    @State private var amount = 0.0
    
    let types = [ExpenseType.business, ExpenseType.personnal]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
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

struct ExpenseType {
    static let business: String = "Business"
    static let personnal: String = "Personnal"
}

#Preview {
    AddExpenseView(expenses: Expenses())
}
