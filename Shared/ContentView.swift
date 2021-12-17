//
//  ContentView.swift
//  Shared
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var transactionSums =
    TransactionSums(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], transactions: [])
    
    var body: some View {
        TabView {
            PieChartView(transactionSums: self.transactionSums)
                .tabItem {
                    Label("Pie Chart", systemImage: "chart.pie")
                }
            
            TransactionView(transactionSums: self.transactionSums)
                .tabItem {
                    Label("Transaction", systemImage: "plus.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Transaction {
    public var name: String
    public var amount: String
    public var type: String
    public var notes: String
    
    public init(name: String, amount: String, type: String, notes: String) {
        self.name = name
        self.amount = amount
        self.type = type
        self.notes = notes
    }
}

class TransactionSums: ObservableObject {
//values: [1300, 500, 300], names: ["Rent", "Transport", "Education"]
    @Published var values: [Double]
    @Published var names: [String]
    @Published var transactions: [Transaction]
    
    public init(values: [Double], names: [String], transactions: [Transaction]) {
        self.values = values
        self.names = names
        self.transactions = transactions
    }
}

