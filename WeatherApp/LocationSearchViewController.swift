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
        print(searchResult.address)
        print(searchResult.address?.region)
        print("--------------------------------------")
    }
    
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        
    }
    
    func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {
        
    }
}

