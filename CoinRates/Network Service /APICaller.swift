//
//  APICaller.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit
import Combine

enum ErrorHandler: Error {
    case serverNotFound
    case gateAwayTimeOut
    case badRequest
    case dataNotFound
    case theRequestTimedOut
    case informationIsEmpty
}

final class APICaller {
    var cancellable = Set<AnyCancellable>()
    static let shared = APICaller()
    private init() {}
    
    public func fetchRatesPublisher(with nameOfTown: String) -> AnyPublisher<[Model],ErrorHandler> {
        Future { promise in
            let stringUrl = "https://belarusbank.by/api/kursExchange?city=\(nameOfTown)"
            guard let url = URL(string: stringUrl) else { return }
            self.generalDecoder(url)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { value in
                    promise(.success(value as [Model]))
                }
                .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchDataPublisher(with nameOfTown: String) -> AnyPublisher<[Model],ErrorHandler> {
        Future { promise in
            let stringUrl = "https://belarusbank.by/api/filials_info?city=\(nameOfTown)"
            guard let url = URL(string: stringUrl) else { return }
            self.generalDecoder(url)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { value in
                    promise(.success(value as [Model]))
                }
                .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
    
    public func getCitiesDataPublisher(cityName: String) -> AnyPublisher<[Cities], ErrorHandler> {
        Future { promise in
            guard let cityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            let url = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName),BY&limit=1&appid=9ff34c75f6de30dd2230d1f5c2f98650"
            guard let URL = URL(string: url) else { return }
            self.generalDecoder(URL)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { value in
                    promise(.success(value as [Cities]))
                }
                .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
    
    private func generalDecoder<T: Decodable>(_ url: URL) -> AnyPublisher<[T], ErrorHandler> {
        return Future { promise in
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .mapError({ _ in
                    ErrorHandler.serverNotFound
                })
                .tryMap { element -> Data in
                    guard (200...299).contains((element.response as! HTTPURLResponse).statusCode) else {
                        promise(.failure(ErrorHandler.badRequest))
                        throw ErrorHandler.badRequest
                    }
                    return element.data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .sink { comp in
                    switch comp {
                    case .failure(_):
                        promise(.failure(ErrorHandler.dataNotFound))
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellable)
        } .eraseToAnyPublisher()
    }
}
