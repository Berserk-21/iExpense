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
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(ExpenseType.business) {
                    ForEach(expenses.items.filter({ $0.type == ExpenseType.business })) { item in
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
                        removeRows(at: indexSet, section: ExpenseType.business)
                    })
                }
                
                Section(ExpenseType.personnal) {
                    ForEach(expenses.items.filter({ $0.type == ExpenseType.personnal })) { item in
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
                        removeRows(at: indexSet, section: ExpenseType.personnal)
                    })
                }
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

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

#Preview {
    ContentView()
}
