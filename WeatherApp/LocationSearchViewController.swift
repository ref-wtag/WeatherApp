import UIKit
import MapboxSearch
import MapboxSearchUI
 

class LocationSearchViewController: UIViewController {
let searchController = MapboxSearchController()
 
override func viewDidLoad() {
super.viewDidLoad()
searchController.delegate = self
let panelController = MapboxPanelController(rootViewController: searchController)
addChild(panelController)
}
}
 
extension LocationSearchViewController : SearchControllerDelegate{
    func searchResultSelected(_ searchResult: MapboxSearch.SearchResult) {
        print("--------------------------------------")
        print(searchResult)
        print(searchResult.address)
        print(searchResult.address?.region)
        print(searchResult.coordinate.latitude)
        print(searchResult.coordinate.longitude)
        
        print("--------------------------------------")
        
        //navigationController?.popViewController(animated: true)
        
        //dismiss(animated: true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vcc") as! ViewController
        vc.lat = searchResult.coordinate.latitude
        vc.long = searchResult.coordinate.longitude
        vc.cityNameString = searchResult.address?.region ?? "No city Name"
        vc.cnt = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        
    }
    
    func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {
        
    }
}

