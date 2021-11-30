//
//  ContentView.swift
//  Shared
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PieChartView(values: [1300, 500, 300], colors: [Color.blue, Color.green, Color.orange], names: ["Rent", "Transport", "Education"], backgroundColor: Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), innerRadiusFraction: 0.6)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
