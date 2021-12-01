//
//  ContentView.swift
//  Shared
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PieChartView(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], formatter: {value in String(format: "$%.2f", value)})
                .tabItem {
                    Label("Menu", systemImage: "chart.pie")
                }
            
            TransactionView()
                .tabItem {
                    Label("Order", systemImage: "plus.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
