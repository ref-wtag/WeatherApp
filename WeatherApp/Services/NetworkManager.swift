//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    
    public func fetchWeatherForecastInfo(
        latitude : Double,
        longitude : Double,
        completion : @escaping (Result<WeatherForecastResponse, Error>) -> ()
    ){
        let urlString = "\(ConstantKeys.BASE_URL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(ConstantKeys.APP_ID)"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { data, _, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print("eoor is \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    public func fetchCurrentWeatherInfo(
        latitude : Double,
        longitude : Double,
        completion : @escaping (Result<CurrentWeatherInfoResponse, Error>) -> ()
    ){
        let urlString = "\(ConstantKeys.BASE_URL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(ConstantKeys.APP_ID)"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { data, _, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(CurrentWeatherInfoResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print("eoor is \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
