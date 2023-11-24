//
//  ChartView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/11/23.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? .theme.green : .red
        
        startingDate = Date(apiDateString: coin.athDate ?? "")
        endingDate = startingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
            .frame(height: 200)
            .background(
                chartBackground
            )
            .overlay(alignment: .leading) {
                chartYAxis.padding(.horizontal,4)
            }
            
            chartDateLabels
            .padding(.horizontal,4)
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        })
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let maxDifference = maxY - minY
                    let yPosition = (1 - (data[index] - minY)/maxDifference) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor,style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack(content: {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        })
    }
    
    private var chartYAxis: some View {
        VStack(content: {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        })
    }
    
    private var chartDateLabels: some View {
        HStack(content: {
            Text(startingDate.asShortString())
            Spacer()
            Text(endingDate.asShortString())
        })
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}
