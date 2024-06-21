//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    let types = ExpenseType.types()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { type in
                    Section(type) {
                        ForEach(expenses.items.filter({ $0.type == type })) { item in
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
                            removeRows(at: indexSet, section: type)
                        })
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                // Push
                .navigationDestination(isPresented: $showingAddExpense, destination: {
                    AddExpenseView(expenses: expenses)
                })
                // Present Sheet
//                .sheet(isPresented: $showingAddExpense, content: {
//                    AddExpenseView(expenses: expenses)
//                })
            }
        }
    }
    
    func removeRows(at offsets: IndexSet, section: String) {
        
        let filteredItems = expenses.items.filter({ $0.type == section })
        
        guard filteredItems.count > 0 else { return }
        
        offsets.forEach { index in
            
            guard index < filteredItems.count else { return }
            
            let removedItemID = filteredItems[index].id
            
            expenses.items.removeAll(where: { $0.id == removedItemID })
        }
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

#Preview {
    ContentView()
}
