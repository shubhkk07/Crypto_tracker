//
//  StatisticsView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 02/10/23.
//

import SwiftUI

struct StatisticsView: View {
    
    let stat: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0: 180))
                    
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(stat.percentageChange ?? 0 >= 0 ? Color.theme.green: Color.red)
            .opacity(stat.percentageChange != nil ? 1.0 : 0.0)
        })
       
    }
}

struct StatisticsView_Previewa: PreviewProvider{
    static var previews: some View{
        StatisticsView(stat: dev.stat1)
    }
}
