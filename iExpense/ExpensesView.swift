//
//  ExpensesView.swift
//  iExpense
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    let types = ExpenseType.types()
    
    // MARK: - Life Cycle
    
    init(sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(sort: sortOrder)
    }
    
    // MARK: - Views
    
    var body: some View {
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
    }
    
    // MARK: - Core Methods
    
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
    ExpensesView(sortOrder: [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ])
}
