//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @State private var name = ""
    @State private var type = ExpenseType.business
    @State private var amount = 0.0
    
    let types = ExpenseType.types()
    
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
                    modelContext.insert(expenseItem)
                    
                    dismiss()
                }
            }
            // In case its a push navigation. 
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct ExpenseType {
    static let business: String = "Business"
    static let personnal: String = "Personnal"
    
    static func types() -> [String] {
        
        return [business, personnal]
    }
}

#Preview {
    AddExpenseView()
}
