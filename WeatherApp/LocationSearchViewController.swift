//
//  LocationSearchViewController.swift
//  LocationSearch
//
//  Created by Refat E Ferdous on 12/21/23.
//

import Foundation

import UIKit
import MapboxSearch
import MapKit

class LocationSearchViewController : UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private lazy var placeAutocomplete = PlaceAutocomplete(accessToken: "sk.eyJ1IjoicmVmYXQwMDEiLCJhIjoiY2xxM2UxZTU0MGF0bjJpcXVxYTRwa3A5NiJ9.RGTRasPksRMwDU70ttlhXg")
    
    private var cachedSuggestions: [PlaceAutocomplete.Suggestion] = []

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UISearchResultsUpdating
extension LocationSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let text = searchController.searchBar.text
        else {
            cachedSuggestions = []
            
            reloadData()
            return
        }
        
        placeAutocomplete.suggestions(
            for: text
           //proximity: CLLocationCoordinate2D(latitude: 23.8041, longitude: 90.4152)
           // proximity: locationManager.location?.coordinate,
            // locationManager.location?.coordinate,
            //filterBy: .init(types: [.POI], navigationProfile: .driving)
            //filterBy: .init(types: [.POI], navigationProfile: .none)
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let suggestions):
                self.cachedSuggestions = suggestions
                print("cachedSuggestions : \(cachedSuggestions)")
                self.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension LocationSearchViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cachedSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "suggestion-tableview-cell"
        
        let tableViewCell: UITableViewCell
        if let cachedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableViewCell = cachedTableViewCell
        } else {
            tableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let suggestion = cachedSuggestions[indexPath.row]

        tableViewCell.textLabel?.text = suggestion.name
        tableViewCell.accessoryType = .disclosureIndicator

        var description = suggestion.description ?? ""
        
        print("--------------------------------")
        print("\(suggestion)")
        print("--------------------------------")

        tableViewCell.detailTextLabel?.text = description
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray
        tableViewCell.detailTextLabel?.numberOfLines = 4
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let suggstion = cachedSuggestions[indexPath.row]
        ConstantKeys.shared.latitude = suggstion.coordinate.latitude
        ConstantKeys.shared.longitude = suggstion.coordinate.longitude
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// MARK: - Private
private extension LocationSearchViewController {
    func reloadData() {
        tableView.isHidden = cachedSuggestions.isEmpty
        tableView.reloadData()
    }
    
    func configureUI() {
        configureSearchController()
        configureTableView()
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.returnKeyType = .done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
