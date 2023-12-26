import Foundation
import CoreLocation

extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        collectionView.isHidden = false
        weatherForecastButton.isHidden = false
        weatherLabel.isHidden = false
        searchCityButton.isHidden = false
        weatherType.isHidden = false
        temperature.isHidden = false
        icon.isHidden = false
        
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else{ return }
        ConstantKeys.shared.latitude = locationValue.latitude
        ConstantKeys.shared.longitude = locationValue.longitude
        self.lat = locationValue.latitude
        self.long = locationValue.longitude
        viewModel.fetchCurrentWeatherInfo(lat: self.lat, lon: self.long)
        viewModel.fetchWeatherForecastInfo(lat: self.lat, lon: self.long)
        self.getCityName()
    
    }

}
