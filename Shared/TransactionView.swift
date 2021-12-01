//
//  TransactionView.swift
//  budgeting
//
//  Created by Michael Alvin on 11/30/21.
//

import SwiftUI

struct TransactionView: View {
    
    public var backgroundColor: Color
    
    public init(backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)) {
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        VStack{
            Text("HERE INSERT OTHER VIEW")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(self.backgroundColor.edgesIgnoringSafeArea(.all))
        .foregroundColor(Color.white)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

