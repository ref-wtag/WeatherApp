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
        
    }
    
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        
    }
    
    func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {
        
    }
    
    
}


//extension LocationSearchViewController: SearchControllerDelegate {
//func searchResultSelected(_ searchResult: SearchResult) { }
//func categorySearchResultsReceived(results: [SearchResult]) { }
//func userFavoriteSelected(_ userFavorite: FavoriteRecord) { }
//}
