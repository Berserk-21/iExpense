//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var showingSheet = false
    @AppStorage("TapCount") private var tapCount = 0
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: { indexSet in
                    removeRows(at: indexSet)
                })
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                }
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct SecondView: View {
    
    let text: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(text) {
            dismiss()
        }
    }
}

@Observable
class Expenses {
    var items = [ExpenseItem]()
}

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

#Preview {
    ContentView()
}
