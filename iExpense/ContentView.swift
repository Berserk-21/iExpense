//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name), SortDescriptor(\ExpenseItem.amount)]
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down", content: {
                    Picker("Sort", selection: $sortOrder) {
                        Text("By Name")
                            .tag([SortDescriptor(\ExpenseItem.name), SortDescriptor(\ExpenseItem.amount)])
                        Text("By Amount")
                            .tag([SortDescriptor(\ExpenseItem.amount, order: .reverse), SortDescriptor(\ExpenseItem.name)])
                    }
                })
                // Push
                .navigationDestination(isPresented: $showingAddExpense, destination: {
                    AddExpenseView()
                })
                // Present Sheet
//                .sheet(isPresented: $showingAddExpense, content: {
//                    AddExpenseView()
//                })
            }
        }
    }
}

#Preview {
    ContentView()
}
