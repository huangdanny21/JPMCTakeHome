//
//  WeatherViewController.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit

class WeatherViewController: UIViewController {
    private lazy var weatherView: WeatherView = {
       let view = WeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: WeatherViewModel
    
    // MARK: - Constructor
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = WeatherViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private
    
    private func setupBindings() {
        viewModel.onWeatherInfoUpdate = { [weak self] in
            DispatchQueue.main.async {
            }
            
        }
    }


}

