//
//  ContentView.swift
//  iExpense
//
//  Created by Berserk on 14/05/2024.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    @State private var user = User()
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Button("Show sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet, content: {
                SecondView(text: "Dismiss me")
            })
        }
        .padding()
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
