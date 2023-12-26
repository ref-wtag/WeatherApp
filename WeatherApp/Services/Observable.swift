//
//  Observable.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/26/23.
//

import Foundation
class Observable<ObservableType> {
    
    var value : ObservableType? {
        didSet{
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init( _ value : ObservableType? ){
        self.value = value
    }
    
    private var listener : ((ObservableType?) -> Void)?
    
    func bind(_ listener : @escaping ((ObservableType?) -> Void)){
        listener(value)
        self.listener = listener
    }
    
}
