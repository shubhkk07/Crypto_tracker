//
//  PortfolioView.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 04/10/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @State var selectedCoin: CoinModel? = nil
    @State var quantityText:String = ""
    @State var showCheckMark:Bool = false
    
    
    var body: some View {
        NavigationView(content: {
            ScrollView {
                VStack(alignment: .leading, content: {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil{
                        portfolioInputSection
                   }
                })
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading){
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavigationBarView
                }
            })
        })
        .onChange(of: vm.searchText, perform: { value in
            if value == ""{
                removeSelectedCoin()
            }
        })
        
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}



extension PortfolioView {
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10,content: {
                ForEach((vm.searchText.isEmpty && !vm.portfolioCoins.isEmpty) ? vm.portfolioCoins : vm.allDataCoins) { coin in
                   CoinImageLogo(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.green: Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        )
                        
                }
            })
            .padding(.vertical,4)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        if let portfoilioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
           let amount = portfoilioCoin.currentHoldings{
            quantityText = "\(amount)"
        }else{
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View{
        VStack(content: {
            HStack(content: {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
            })
            Divider()
            HStack(content: {
                Text("Amount Holdings")
                Spacer()
                TextField("Ex.: 1.4", text: $quantityText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            })
            Divider()
            HStack(content: {
                Text("Current Value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            })
        })
        .animation(.none)
        .padding()
        .padding(.vertical)
        .font(.headline)

    }
    
    private var trailingNavigationBarView: some View{
        HStack(spacing: 8){
            Image(systemName: "checkmark").opacity(
                showCheckMark ? 1.0:0.0
            )
            Button(action: {saveButtonPressed()}, label: {
                Text("Save".uppercased())
            }).opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else {return}
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
            
            //hide keyboard
            UIApplication.shared.endEditing()
            
            //hide checkmark
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                withAnimation(.easeOut) {
                    showCheckMark = false
                }
                
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
        quantityText = ""
    }
}
