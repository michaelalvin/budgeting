import SwiftUI

struct PieChartView: View {
    @ObservedObject var transactionSums: TransactionSums
    
    public var colors: [Color] = [Color.blue, Color.green, Color.orange]
    
    public let formatter: (Double) -> String = {value in String(format: "$%.2f", value)}
    public var widthFraction: CGFloat = 0.75
    
    public var backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0)
    public var innerRadiusFraction: CGFloat = 0.60
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = transactionSums.values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in transactionSums.values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: value == 0 ? "" : String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    var body: some View {
        
        if self.transactionSums.values.allSatisfy({ $0 == 0 }) {
            Text("No data yet")
        } else {
            GeometryReader { geometry in
                VStack{
                    ZStack{
                        ForEach(0..<self.transactionSums.values.count){ i in
                            PieSliceView(pieSliceData: self.slices[i])
                                .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                                .animation(Animation.spring())
                        }
                        .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let radius = 0.5 * widthFraction * geometry.size.width
                                    let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                    let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                    if (dist > radius || dist < radius * innerRadiusFraction) {
                                        self.activeIndex = -1
                                        return
                                    }
                                    var radians = Double(atan2(diff.x, diff.y))
                                    if (radians < 0) {
                                        radians = 2 * Double.pi + radians
                                    }
                                    
                                    for (i, slice) in slices.enumerated() {
                                        if (radians < slice.endAngle.radians) {
                                            if self.activeIndex == i {
                                                // Unselect active index
                                                self.activeIndex = -1
                                            } else {
                                                // Select new active index
                                                self.activeIndex = i
                                            }
                                            break
                                        }
                                    }
                                }
                        )
                        Circle()
                            .fill(self.backgroundColor)
                            .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                        
                        VStack {
                            Text(self.activeIndex == -1 ? "Total" : transactionSums.names[self.activeIndex])
                                .font(.title)
                                .foregroundColor(Color.gray)
                            Text(self.formatter(self.activeIndex == -1 ? transactionSums.values.reduce(0, +) : transactionSums.values[self.activeIndex]))
                                .font(.title)
                        }                }
                    PieChartRows(colors: self.colors, values: self.transactionSums.values.map { self.formatter($0) }, percents: self.transactionSums.values.map { String(format: "%.0f%%", $0 * 100 / self.transactionSums.values.reduce(0, +)) },
                                 activeIndex: self.activeIndex,
                                 tt: self.transactionSums
                    )
                }
                .background(self.backgroundColor)
                .foregroundColor(Color.white)
            }            .background(self.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}

struct PieChartRows: View {
    var colors: [Color]
    var values: [String]
    var percents: [String]
    
    var activeIndex: Int
    
    @ObservedObject var tt: TransactionSums
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count, id: \.self){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.tt.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                            .foregroundColor(Color.gray)
                    }
                }
                
                if(self.activeIndex == i) {
                    VStack {
                        ForEach(0..<self.tt.transactions[i].count, id: \.self) { t in
                            HStack {
                                Text(self.tt.transactions[i][t].name)
                                Spacer()
                                Text("$" + self.tt.transactions[i][t].amount)
                            }
                        }
                    }.padding(.leading, 32)
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(transactionSums: TransactionSums(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], transactions: []))
    }
}


