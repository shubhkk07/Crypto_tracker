//
//  DetailView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 06/11/23.
//

import SwiftUI

struct DetailLoadingView: View{
    
    @Binding var coin: CoinModel?
    
    var body: some View{
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    private let columns:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("intializing coin \(coin.name)")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                
                VStack(spacing: 20, content: {
                    overviewTitle
                    Divider()
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                })
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                navigationTrailingItem
            })
        })
    }
}



#Preview {
    NavigationView(content: {
        DetailView(coin: DeveloperPreview.instance.coin)
    })
}

extension DetailView {
    
    private var navigationTrailingItem: some View {
        
            HStack {
                Text(vm.coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundStyle(Color.theme.secondaryTextColor)
                CoinImageView(coin: vm.coin)
                    .frame(width: 25, height: 25)
            }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.overviewStatistics) { stats in
                StatisticsView(stat: stats)
            }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.additionalStatistics) { stats in
                StatisticsView(stat: stats)
            }
        })
    }
}
