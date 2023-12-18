
import Foundation
import UIKit
import MapboxMaps
import MapboxSearch
import MapboxSearchUI

class MapsSearchViewController: UIViewController {
    var searchController = MapboxSearchController()
    var mapView: MapView?
    var annotationManager: PointAnnotationManager?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search setup
        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)
        
        // Map setup
        let mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView = mapView
        view.addSubview(mapView)
        
        annotationManager = mapView.annotations.makePointAnnotationManager()
    }
    
    func showResults(_ results: [SearchResult]) {
        let annotations = results.map { searchResult -> PointAnnotation in
            var annotation = PointAnnotation(coordinate: searchResult.coordinate)
            annotation.textField = searchResult.name
            annotation.textOffset = [0, -2]
            annotation.textColor = .init(red: 0.0, green: 0.1, blue: 0.2, alpha: 0.3)
            //annotation.image = .init(image: <#T##UIImage#>, name: <#T##String#>)
            return annotation
        }
        
        annotationManager?.annotations = annotations
        
//        annotationManager.syncAnnotations(annotations)
        
        
//        if case let .point(point) = annotations.first?.feature.geometry {
//            let options = CameraOptions(center: point.coordinates)
//            mapView?.mapboxMap.setCamera(to: options)
//        }
    }
}

extension MapsSearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        showResults(results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        showResults([searchResult])
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showResults([userFavorite])
    }
}
