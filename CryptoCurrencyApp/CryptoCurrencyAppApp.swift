//
//  CryptoCurrencyAppApp.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 07/07/23.
//

import SwiftUI

@main
struct CryptoCurrencyAppApp: App {
    
    @StateObject var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
