//
//  WeatherForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/10/23.
//

import UIKit

class WeatherForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet var time : UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var windSpeed : UILabel!
    @IBOutlet var imageView : UIImageView!
    
//     var timeval : String = ""
//    var temperatureVal: Double = 0.0
//    var windSpeedVal : Double = 0.0
//    var imageViewVal : String = ""
//    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
