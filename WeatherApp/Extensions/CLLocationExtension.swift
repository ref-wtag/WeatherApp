import CoreLocation


extension CLLocation{
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.administrativeArea, $0?.first?.country, $1) }
    }
}
