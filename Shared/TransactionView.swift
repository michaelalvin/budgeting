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
    public var expenseOptions = ["Rent", "Transport", "Education"]
    
    @State private var notes: String = "Why are you making this purchase? Buy with intent!"
    public var backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)
            
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
                        self.transactionSums.transactions.append(Transaction(name: self.name, amount: self.amount, type: self.expenseOptions[self.expenseIndex], notes: self.notes))
                        
                        self.transactionSums.values[self.expenseIndex] += Double(self.amount) ?? 0.0
                                                
                        // Clear text fields here
                        self.name = ""
                    }) {
                        Text("Submit")
                    }
                }
                
                List {
                    ForEach(0..<self.transactionSums.transactions.count, id: \.self) {
                        
                        Text(self.transactionSums.transactions[$0].name)
                    
                    }
                }
            })
                .navigationBarTitle("Add Expense")
        }
        
    }
    // NEXT
    // 3. Connect transactions on this tab and the other tab
        // TODO: Look at PieCharTview and TransactionView to look and read at ObservedObject correctly
                // Fix expenseOptions
                // Starting at 0,0,0 piechart error
                // Show transactions data on list when pie chart is selected
    
    // 4. CoreData, or Firebase in Content View
    // *. Then, try to see if you can add real money to app to certain categories for actual use
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transactionSums: TransactionSums(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], transactions: []))
    }
}

