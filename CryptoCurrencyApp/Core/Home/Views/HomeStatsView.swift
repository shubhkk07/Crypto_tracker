//
//  HomeStatsView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 02/10/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject var vm:HomeViewModel
    let showPortfolio:Bool
    
    
    var body: some View {
        HStack(spacing: 4, content: {
            ForEach(vm.statistics) { stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.size.width/3)
            }
        })
        .frame(width: UIScreen.main.bounds.size.width, alignment: !showPortfolio ? .leading: .trailing)
    }
}

#Preview {
    HomeStatsView( showPortfolio: false)
        .environmentObject(HomeViewModel())
}
