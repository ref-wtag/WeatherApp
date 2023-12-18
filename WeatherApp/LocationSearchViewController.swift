import UIKit
import MapboxSearch
import MapboxSearchUI
 

class LocationSearchViewController: UIViewController {
let searchController = MapboxSearchController()
    let placeAutocomplete = PlaceAutocomplete(accessToken: "sk.eyJ1IjoicmVmYXQwMDEiLCJhIjoiY2xxM2UxZTU0MGF0bjJpcXVxYTRwa3A5NiJ9.RGTRasPksRMwDU70ttlhXg")
override func viewDidLoad() {
super.viewDidLoad()
searchController.delegate = self
let panelController = MapboxPanelController(rootViewController: searchController)
addChild(panelController)
}
    
    func locationsearch(){
        let query = "Starbucks"
        let selectedSuggestion = placeAutocomplete.suggestions(for: query) { result in
            switch result {
            case .success(let suggestions):
                //self.processSuggestions(suggestions)
                print("here")
                    
            case .failure(let error):
                debugPrint(error)
            }
        }
        
        placeAutocomplete.select(suggestion: selectedSuggestion) { result in
            switch result {
            case .success(let suggestionResult):
                // process result
                self.processSelection(suggestionResult)

            case .failure(let error):
                // process failure
                debugPrint(error)
            }
        }
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

