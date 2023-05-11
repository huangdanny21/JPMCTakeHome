//
//  WeatherView.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit
import SDWebImage

class WeatherView: UIView {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cloudsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timezoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Contructors
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupViews() {
        // Add and configure UI elements
        addSubview(nameLabel)
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)
        addSubview(windLabel)
        addSubview(cloudsLabel)
        addSubview(timezoneLabel)
        addSubview(coordinatesLabel)
        addSubview(iconImageView)
        addSubview(dateLabel)

        // Configure constraints
        NSLayoutConstraint.activate([
            // nameLabel constraints
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // temperatureLabel constraints
            temperatureLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // coordinatesLabel constraints
            dateLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // descriptionLabel constraints
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // windLabel constraints
            windLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            windLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // cloudsLabel constraints
            cloudsLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
            cloudsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // timezoneLabel constraints
            timezoneLabel.topAnchor.constraint(equalTo: cloudsLabel.bottomAnchor, constant: 8),
            timezoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // coordinatesLabel constraints
            coordinatesLabel.topAnchor.constraint(equalTo: timezoneLabel.bottomAnchor, constant: 8),
            coordinatesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            
            // iconImageView constraints
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
}


extension WeatherView {
    func configure(with weather: WeatherData) {
        nameLabel.text = weather.name
        let temperatureString = String(format: "%.1f", weather.main.temp)
        temperatureLabel.text = "\(temperatureString)°C"
        descriptionLabel.text = weather.weather.first?.description ?? "-"
        windLabel.text = "Wind: \(weather.wind.speed) m/s, \(weather.wind.deg)°"
        cloudsLabel.text = "Clouds: \(weather.clouds.all)%"
        timezoneLabel.text = "Timezone: \(weather.timezone)"
        coordinatesLabel.text = "Coordinates: \(weather.coord.lat), \(weather.coord.lon)"
        dateLabel.text = formattedDate(from: weather.dt)

        // Set the weather icon image
        if let iconURL = weather.weather.first?.icon {
            let urlString = "http://openweathermap.org/img/w/\(iconURL).png"
            if let url = URL(string: urlString) {
                iconImageView.sd_setImage(with: url, completed: nil)
            }
        } else {
            iconImageView.image = nil
        }
    }

    private func loadIcon(from urlString: String) {
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        iconImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func formattedDate(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"

        return dateFormatter.string(from: date)
    }
}
