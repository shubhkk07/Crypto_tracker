//
//  FileetworkManager.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/07/23.
//

import Foundation
import Combine

class NetworkManager{
    
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url):
                return "Bad response from URL: \(url)"
            case .unknown: 
                return "unknown error occured"
            }
        }
    }
    
//    static func create(request:URLRequest) -> AnyPublisher<Data,Error> {
//        URLSession.shared.dataTaskPublisher(for: request)
//            .subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap({try handleURLResponse(output: $0, url: request.url ?? nil)})
//    }
    
    static func download(url: URL)-> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {throw NetworkingError.badUrlResponse(url: url)}
        return output.data
    }
    
    static func completionHandler(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            print("")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}
