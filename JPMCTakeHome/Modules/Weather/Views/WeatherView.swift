//
//  WeatherView.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit
import SDWebImage

class WeatherView: UIView {
    
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
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(temperatureLabel)
        addSubview(humidityLabel)
        addSubview(descriptionLabel)
        addSubview(weatherIconImageView)
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, descriptionLabel, weatherIconImageView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
    }
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
