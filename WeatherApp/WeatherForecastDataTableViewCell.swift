//
//  WeatherForecastDataTableViewCell.swift
//  WeatherApp
//
//  Created by Refat E Ferdous on 12/11/23.
//

import UIKit

class WeatherForecastDataTableViewCell: UITableViewCell {

    
    @IBOutlet var dateValue : UILabel!
    @IBOutlet var timeValue : UILabel!
    @IBOutlet var minMaxTemperature : UILabel!
    @IBOutlet var weatherType : UILabel!
    @IBOutlet var iconImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
