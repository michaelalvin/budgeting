//
//  TransactionView.swift
//  budgeting
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI
import Combine

struct TransactionView: View {
    @ObservedObject var transactionSums: TransactionSums
    
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var expenseIndex = 0
    @State private var notes: String = "Why are you making this purchase? Buy with intent!"
    public var backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)
            
    init(transactionSums: TransactionSums) {
        self.transactionSums = transactionSums
        
        UITableView.appearance().backgroundColor = UIColor(self.backgroundColor)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            // Form
            Form(content: {
                // Text field
                Section(header: Text("Expense Information").foregroundColor(.white)) {
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
                        ForEach(0 ..< transactionSums.names.count) {
                            Text(self.transactionSums.names[$0])
                        }
                    }
                    TextField("Any other notes here", text: $notes)
                }
                
                Section {
                    Button(action: {
                        print("Perform an action here...")
                                      
                        // Update  mockExpensesSums
                        self.transactionSums.transactions[self.expenseIndex].append(Transaction(name: self.name, amount: self.amount, type: self.transactionSums.names[self.expenseIndex], notes: self.notes))
                        
                        self.transactionSums.values[self.expenseIndex] += Double(self.amount) ?? 0.0
                                                
                        // Clear text fields here
                        self.name = ""
                        self.amount = ""
                    }) {
                        Text("Submit")
                    }
                }
            })
                .navigationBarTitle("Add Expense")
        }
    }
    // NEXT
    // 4. CoreData, or Firebase in Content View
    // 5. Later,
            // a) Add certain categories for actual use or
            // b) connect ApplePay button so they can pay after they add money
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transactionSums: TransactionSums(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], transactions: []))
    }
}

