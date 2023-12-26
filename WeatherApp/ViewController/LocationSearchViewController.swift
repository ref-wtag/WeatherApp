import UIKit
import MapboxSearch
import MapboxSearchUI
 

class LocationSearchViewController: UIViewController {
 let searchController = MapboxSearchController()
 
  override func viewDidLoad() {
   super.viewDidLoad()
   AddSearchController()
 }
    
    func AddSearchController(){
        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)
    }
}

extension LocationSearchViewController : SearchControllerDelegate {
    
    func searchResultSelected(_ searchResult: MapboxSearch.SearchResult) {
        ConstantKeys.shared.latitude = searchResult.coordinate.latitude
        ConstantKeys.shared.longitude = searchResult.coordinate.longitude
        ConstantKeys.shared.cityName = searchResult.address?.region ?? searchResult.name
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        
    }
    
    func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {
        
    }
}

