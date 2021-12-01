//
//  TransactionView.swift
//  budgeting
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI
import Combine

struct TransactionView: View {
    @State private var name: String = ""
    @State private var amount: String = ""
    
    @State private var expenseIndex = 0
    public var expenseOptions = ["edu", "transp", "rent"]
    
    @State private var notes: String = ""
    public var backgroundColor: Color
    
    @State private var mockExpenses: [Transaction] = []
    
    public init(backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)) {
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        NavigationView {
            // Form
            Form(content: {
                // Text field
                Section(header: Text("Expense Information")) {
                    TextField("Expense Name", text: $name)
                    TextField("Expense Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onReceive(Just(amount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }
                    Picker(selection: $expenseIndex, label: Text("Expense Type")) {
                        ForEach(0 ..< expenseOptions.count) {
                            Text(self.expenseOptions[$0])
                        }
                    }
                    TextField("Any other notes here", text: $notes)
                }
                
                Section {
                    Button(action: {
                        print("Perform an action here...")
                        self.mockExpenses.append(Transaction(name: self.name, amount: self.amount, notes: self.notes))
                        
                        //                        Clear text fields here
                        self.name = ""
                    }) {
                        Text("Submit")
                    }
                }
                
                List {
                    
                    ForEach(0..<mockExpenses.count, id: \.self) { Text(self.mockExpenses[$0].name)
                        
                    }
                }
            })
                .navigationBarTitle("Add Expense")
        }
        
    }
    // NEXT
    // 2. Show list on this page on the bottom half with the list of transactions
    // 3. Connect transactions on this tab and the other tab
    // 4. CoreData
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

struct Transaction {
    public var name: String
    public var amount: String
    public var notes: String
    
    public init(name: String, amount: String, notes: String) {
        self.name = name
        self.amount = amount
        self.notes = notes
    }
}
