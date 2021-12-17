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
    
    @State private var notes: String = "Why are you making this purchase? Buy with intent!"
    public var backgroundColor: Color
    
    @State private var mockExpenseSums: TransactionSums
    
    public init(backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)) {
        self.backgroundColor = backgroundColor
        
        self.mockExpenseSums = TransactionSums(values: [Double](repeating: 0.0, count: self.expenseOptions.count), names: self.expenseOptions, transactions: [])
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
                                      
                        // Update  mockExpensesSums
                        self.mockExpenseSums.transactions.append(Transaction(name: self.name, amount: self.amount, type: self.expenseOptions[self.expenseIndex], notes: self.notes))
                        
                        self.mockExpenseSums.values[self.expenseIndex] += Double(self.amount) ?? 0.0
                                                
                        // Clear text fields here
                        self.name = ""
                    }) {
                        Text("Submit")
                    }
                }
                
                List {
                    
                    ForEach(0..<self.mockExpenseSums.transactions.count, id: \.self) { Text(self.mockExpenseSums.transactions[$0].name)
                        Text(self.mockExpenseSums.transactions[$0].type)
                    }
                }
            })
                .navigationBarTitle("Add Expense")
        }
        
    }
    // NEXT
    // 2. Show list on this page on the bottom half with the list of transactions
    // 3. Connect transactions on this tab and the other tab
        // Change PieChartview to use values,names --> transactions
        // Use observed object, look at project sa @ObservedObject
        // TransactionView has per transaction whereas
        // PieChartView has per transaction type,
        // need to connect the two up
    // 4. CoreData, or Firebase in Content View
    // *. Then, try to see if you can add real money to app to certain categories for actual use
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
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

struct TransactionSums {
//values: [1300, 500, 300], names: ["Rent", "Transport", "Education"]
    public var values: [Double]
    public var names: [String]
    public var transactions: [Transaction]
}

