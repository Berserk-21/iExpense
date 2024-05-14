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
    @State private var showingAddExpense = false
    @AppStorage("TapCount") private var tapCount = 0
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        })
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .modifier(AmountStyleModifier(amount: item.amount))
                    }
                }
                .onDelete(perform: { indexSet in
                    removeRows(at: indexSet)
                })
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                .sheet(isPresented: $showingAddExpense, content: {
                    AddExpenseView(expenses: expenses)
                })
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

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

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            // Saves to UserDefaults each new expense item.
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        // Loads expense items from UserDefaults at init.
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

#Preview {
    ContentView()
}
