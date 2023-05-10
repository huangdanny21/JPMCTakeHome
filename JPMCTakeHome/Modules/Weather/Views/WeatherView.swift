//
//  WeatherView.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit
import SDWebImage

class WeatherView: UIView {
    lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a city"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}

extension WeatherView {
    func configure(with weatherInfo: WeatherInfo?) {
        temperatureLabel.text = "\(String(describing: weatherInfo?.temp))°C"
        humidityLabel.text = "\(String(describing: weatherInfo?.humidity ?? 0))%"
        descriptionLabel.text = weatherInfo?.weatherDescription
        loadIcon(from: weatherInfo?.icon ?? "")
    }

    private func loadIcon(from urlString: String) {
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        weatherIconImageView.sd_setImage(with: url, completed: nil)
    }


}
