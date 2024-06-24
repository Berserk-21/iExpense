//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\ExpenseItem.name), SortDescriptor(\ExpenseItem.amount)]) var expenses: [ExpenseItem]
    
    @State private var showingAddExpense = false
    
    let types = ExpenseType.types()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { type in
                    Section(type) {
                        ForEach(expenses.filter({ $0.type == type })) { item in
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
        
        let filteredItems = expenses.filter({ $0.type == section })
        
        guard filteredItems.count > 0 else { return }
        
        offsets.forEach { index in
            
            guard index < filteredItems.count else { return }
            
            let item = expenses[index]
            
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
}
