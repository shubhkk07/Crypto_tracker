//
//  Homeview.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 08/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var showPortfoliio:Bool = false
    @State private var showPortfolioView:Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView:Bool = false
    
    var body: some View {
        ZStack {
            //Background Layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
            
            //Content layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: showPortfoliio)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if !showPortfoliio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                if showPortfoliio{
                    portfolioCoinsList
                    .transition(.move(edge: .trailing))
                }
               
                Spacer()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView, label: {
                EmptyView()
            })
        )
    }
}

extension HomeView {
    private var homeHeader: some View{
        HStack {
            CircleButtonView(iconName: !showPortfoliio ? "info": "plus")
                .onTapGesture {
                    if showPortfoliio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfoliio)
                )
                .animation(.none)
            Spacer()
            Text(!showPortfoliio ? "Live Prices": "Portfolio")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.degrees(showPortfoliio ? 180: 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfoliio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allDataCoins) { coin in
                CoinView(coin: coin, showHoldings: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinView(coin: coin, showHoldings: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View{
        HStack(content: {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank ||  viewModel.sortOption == .rankRversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankRversed :.rank
                }
                
            }
            
            Spacer()
            if showPortfoliio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings ||  viewModel.sortOption == .holdingReserved) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingReserved :.holdings
                    }
                }
            }
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price ||  viewModel.sortOption == .priceReserved) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReserved : .price
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width/3.5,
                       alignment: .trailing)
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: viewModel.isLoading ? 720: 0), anchor: .center)
        })
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
