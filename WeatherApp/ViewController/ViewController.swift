//
//  ViewController.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/6/23.
//

import UIKit
import CoreLocation
import RealmSwift

class ViewController: UIViewController {

    var lat = 0.0
    var long = 0.0
    let locationManager = CLLocationManager()
    var cityNameString : String = ""
    var viewModel = MainViewModel(realmManager: RealmManager(), networkManager: NetworkManager())
    var weatherForecastInfo : WeatherForecastResponse? = nil
    var currentWeatherInfo : CurrentWeatherInfoResponse? = nil
    let realm = try! Realm()
    
    @IBOutlet var collectionView : UICollectionView!
    
    @IBOutlet var  cityName : UILabel!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var icon : UIImageView!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    
    @IBOutlet var searchCityButton : UIButton!
    @IBOutlet var weatherForecastButton : UIButton!
    
    @IBAction func SearchCityButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func WeatherForecastButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherForecastViewController") as! WeatherForecastViewController
        vc.cityNameString = self.cityNameString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmPathPrint()
        configView()
        bindViewModel()
        getCurrentLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lat = ConstantKeys.shared.latitude
        self.long = ConstantKeys.shared.longitude
        self.cityNameString = ConstantKeys.shared.cityName
        self.cityName.text = ConstantKeys.shared.cityName
        viewModel.fetchCurrentWeatherInfo(lat : self.lat , lon : self.long)
        viewModel.fetchWeatherForecastInfo(lat : self.lat , lon : self.long)
    }
    
    func bindViewModel(){
        viewModel.collectionViewData.bind { [weak self] weatherData in
            guard let self = self,let weatherData = weatherData else{
                self?.reloadCollectionViewData()
                return
            }

            self.weatherForecastInfo = weatherData
            self.reloadCollectionViewData()
        }
        
        viewModel.currentWeatherData.bind { [weak self] weatherInfo in
            guard let self = self, let weatherInfo = weatherInfo else{
                self?.getWeatherInfoData()
                return
            }
            
            self.currentWeatherInfo = weatherInfo
            self.loadCurrentLocationData()
        }
    }
    
    func RealmPathPrint(){
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    func configView(){
        setCollectionView()
        setColorForButton()
    }
    
    func setCollectionView(){
        let nib = UINib(nibName: "WeatherForecastCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    func setColorForButton(){
        searchCityButton.setTitle("Click Here to Search City", for: .normal)
        searchCityButton.setTitleColor(UIColor.white, for: .normal)
        
        weatherForecastButton.setTitle("5-Day Weather Forecast", for: .normal)
        weatherForecastButton.setTitleColor(UIColor.white, for: .normal)
    }
    

    func loadCurrentLocationData(){
    
        let tempInCelcious = (currentWeatherInfo?.main.temp ?? 0.0) - 273.15
        let temp = String(format: "%.2f", tempInCelcious)
        temperature.text = String(temp) + "°C"
        
        weatherType.text = currentWeatherInfo?.weather[0].main
        
        let imageUrlString = "\(ConstantKeys.IMAGE_URL)" + (currentWeatherInfo?.weather[0].icon ?? "") + "\(ConstantKeys.IMAGE_EXTENSION)"
        let imageUrl = URL(string:  imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData){
                DispatchQueue.main.sync{
                    self.icon.image = image
                }
            }
        }.resume()
    }
    
    func getCurrentLocation(){
    
        switch CLLocationManager.authorizationStatus() {
            
        case .denied, .restricted:
            resetInitialScreen()
            showPermissionAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestWhenInUseAuthorization()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            resetInitialScreen()
        }
        
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func resetInitialScreen(){
        collectionView.isHidden = true
        weatherForecastButton.isHidden = true
        weatherLabel.isHidden = true
        searchCityButton.isHidden = true
        weatherType.isHidden = true
        temperature.isHidden = true
        icon.isHidden = true
    }
    
    func showPermissionAlert(){
       let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)

       let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
           UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
       })

       let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
       alertController.addAction(cancelAction)

       alertController.addAction(okAction)

       self.present(alertController, animated: true, completion: nil)
   }
    
    func getCityName(){
        let location = CLLocation(latitude: lat, longitude: long)
        location.fetchCityAndCountry { city, country, error in
            
        guard let city = city, let country = country, error == nil else { return }
            self.cityName.text = city
            self.cityNameString = city
            ConstantKeys.shared.cityName = city
            
        }
    }
    
    func getWeatherInfoData(){
        let data = realm.objects(WeatherDataInfo.self)

        for weatherInfoData in data {
            self.cityName.text = weatherInfoData.cityName
            self.temperature.text = weatherInfoData.temperature
            
            let imageUrlString = "\(ConstantKeys.IMAGE_URL)" + (weatherInfoData.icon ?? "") + "\(ConstantKeys.IMAGE_EXTENSION)"
            let imageUrl = URL(string:  imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
                if let imageData = data, let image = UIImage(data: imageData){
                    DispatchQueue.main.sync{
                        self.icon.image = image
                    }
                }
            }.resume()
            self.weatherType.text = weatherInfoData.weatherType
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForecastInfo?.list.count ?? 0
    }
    
    func reloadCollectionViewData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherForecastCollectionViewCell
        
        guard indexPath.row < (weatherForecastInfo?.list.count)! else{
            return cell
        }
        guard ((weatherForecastInfo?.list.count) != nil) else{
            cell.getHourlyWeatherForecastData()
            return cell
        }
        let data = weatherForecastInfo?.list[indexPath.row]
        cell.updateCollectionViewWithData(withData: data!)
        return cell
    }
    
}




