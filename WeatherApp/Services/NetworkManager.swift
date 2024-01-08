import Foundation

protocol NetworkManagerDelegate {
    func fetchWeatherForecastInfo(latitude : Double,longitude : Double,completion : @escaping (Result<WeatherForecastResponse, Error>) -> ())
    func fetchCurrentWeatherInfo(latitude : Double,longitude : Double,completion : @escaping (Result<CurrentWeatherInfoResponse,Error>)-> ())
}

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

class NetworkManager : NetworkManagerDelegate{
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func fetchWeatherForecastInfo(
        latitude : Double,
        longitude : Double,
        completion : @escaping (Result<WeatherForecastResponse, Error>) -> ()
    ){
        let urlString = "\(ConstantKeys.BASE_URL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(ConstantKeys.APP_ID)"
        let url = URL(string: urlString)
       
        
        urlSession.dataTask(with: url!) { data, _, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print("error is \(error.localizedDescription)")
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
        
        urlSession.dataTask(with: url!) { data, _, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(CurrentWeatherInfoResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print("error is \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
