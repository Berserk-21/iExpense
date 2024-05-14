//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var showingSheet = false
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    @AppStorage("TapCount") private var tapCount = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: { indexSet in
                        removeRows(at: indexSet)
                    })
                }
                
                Button("Add number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .padding()
            .toolbar {
                EditButton()
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

// A class has to be observable to allow the view to watch changes of objects from this class.
@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

#Preview {
    ContentView()
}
