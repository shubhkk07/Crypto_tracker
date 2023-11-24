//
//  CoinImageLogo.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 11/10/23.
//

import SwiftUI

struct CoinImageLogo: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack(spacing: 4, content: {
            CoinImageView(coin: coin)
                .frame(width: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        })
    }
}

struct CoinImageLogo_Preview: PreviewProvider{
    static var previews: some View{
        CoinImageLogo(coin: dev.coin)
    }
}
