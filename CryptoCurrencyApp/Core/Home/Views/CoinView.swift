//
//  CoinView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 16/07/23.
//

import SwiftUI

struct CoinView: View {
    
    let coin: CoinModel
    
    let showHoldings:Bool
    
    var body: some View {
        HStack {
            
            leftColumn
            
            Spacer()
            
            if showHoldings{
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

extension CoinView {
    private var leftColumn: some View {
        HStack(content: {
            Text("\(coin.rank)")
                .font(.caption)
                .frame(width: 30)
            CoinImageView(coin: coin)
                .frame(width: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
        })
    }
    
    private var centerColumn: some View{
        VStack(alignment:.trailing) {
            Text(coin.currentHoldingValues.asCurrencyWith2Decimals())
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.theme.accent)

            Text((coin.currentHoldings ?? 0).asNumberString())
                .font(.headline)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var rightColumn: some View{
        VStack(alignment:.trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.theme.accent)
            
            Text((coin.priceChangePercentage24H ?? 0.00).asPercentString())
                .font(.headline)
                .foregroundColor((coin.priceChangePercentage24H ?? 0 ) > 0 ? .green : .red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinView(coin: dev.coin, showHoldings: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            CoinView(coin: dev.coin, showHoldings: true)
                .previewLayout(.sizeThatFits)
        }
        
    }
}
