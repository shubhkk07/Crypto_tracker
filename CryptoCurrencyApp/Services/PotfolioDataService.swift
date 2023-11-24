//
//  PotfolioDataService.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/10/23.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container:NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    
    @Published var savedEntity: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading core data")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: PUBLIC
    
    func updatePortfolio(coin:CoinModel, amount:Double){
        if let entity = savedEntity.first(where: {$0.coinId == coin.id}){
            if amount > 0 {
                updateCoin(entity: entity, amount: amount)
            }else{
                removeCoin(entity: entity)
            }
        }else{
            addCoin(coin: coin, amount: amount)
        }
    }
    
    //MARK: PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
            savedEntity = try container.viewContext.fetch(request)
        }catch let error {
            print("Error fetching items: \(error)")
        }
    }
    
    private func addCoin(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount  = amount
        applyChanges()
    }
    
    private func updateCoin(entity:PortfolioEntity,amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func removeCoin(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
        } catch let error {
            print("error saving to the core. \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
