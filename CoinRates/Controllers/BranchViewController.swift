//
//  BranchViewController.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit
import YandexMapsMobile

final class BranchViewController: UIViewController {
    private var locationManager: LocationManager?
    private let model: Model
    private let city: Cities
    private let filialsData: Model
    
    private lazy var workTime: String = {
        let modelWorkTime = model.info_worktime ?? "-"
        var workTime = "Режим работы:\n"
        modelWorkTime.forEach { value in
            (value != "|") ? (workTime += String(value)) : (workTime += "\n")
        }
        return workTime
    }()
    
    private lazy var label2: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.textColor = .titleColor
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = workTime
        return lbl
    }()
    
    private lazy var label3: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.preferredMaxLayoutWidth = 160
        lbl.textColor = .titleColor
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Адрес:\n\(model.name_type ?? "") \(model.name ?? "") \n\(model.street_type ?? ",")\(model.street ?? "") \(model.home_number ?? "")"
        return lbl
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .buttonBacgrndColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(model: Model, city: Cities, filialsData: Model) {
        self.filialsData = filialsData
        self.model = model
        self.city = city
        self.locationManager = LocationManager(latitude: Double(filialsData.GPS_X ?? "0") ?? 0, longitude: Double(filialsData.GPS_Y ?? "0") ?? 0)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .backgroundColor
        title = (model.street_type ?? "") + " " + (model.street ?? "") + " " + (model.home_number ?? "")
        configureBranchVC()
    }
}

extension BranchViewController {
    public func configureBranchVC() {
        func setRectangle() -> UIView {
            let rectView = UIView()
            rectView.backgroundColor = .backgroundColor
            rectView.layer.cornerRadius = 20
            rectView.translatesAutoresizingMaskIntoConstraints = false
            rectView.clipsToBounds = true
            return rectView
        }
        
        func configureSymbol(name: String) -> UIView {
            let view = UIImageView(image: UIImage(systemName: name))
            view.contentMode = .scaleAspectFit
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        
        func configureLabel(text: String) -> UIView {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = text
            label.textColor = .titleColor
            label.font = UIFont.systemFont(ofSize: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
        
        // MARK: - Create rectangles
        let rect1 = setRectangle()
        let rect2 = setRectangle()
        let rect3 = setRectangle()
        
        let symbol1 = configureSymbol(name: "calendar")
        let symbol2 = configureSymbol(name: "phone.down")
        let symbol3 = configureSymbol(name: "paintbrush.pointed")
        
        let text1 = configureLabel(text: filialsData.info_worktime ?? "")
        let text2 = configureLabel(text: filialsData.phone_info ?? "")
        let text3 = configureLabel(text: filialsData.name ?? "")
        
        rect1.addSubview(symbol1)
        rect2.addSubview(symbol2)
        rect3.addSubview(symbol3)
        
        rect1.addSubview(text1)
        rect2.addSubview(text2)
        rect3.addSubview(text3)
        
        guard let locationManager else { return }
        let mapView = locationManager.mapView
        
        view.addSubview(backView)
        backView.addSubview(mapView)
        backView.addSubview(descriptionView)
        descriptionView.addSubview(rect1)
        descriptionView.addSubview(rect2)
        descriptionView.addSubview(rect3)
    
        
        // MARK: - Configure constraints
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            mapView.bottomAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mapView.topAnchor.constraint(equalTo: rect3.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            descriptionView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            rect1.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            rect1.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            rect1.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            rect1.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            rect2.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            rect2.topAnchor.constraint(equalTo: rect1.bottomAnchor, constant: 10),
            rect2.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            rect2.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            rect3.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            rect3.topAnchor.constraint(equalTo: rect2.bottomAnchor, constant: 10),
            rect3.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            rect3.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            symbol1.leadingAnchor.constraint(equalTo: rect1.leadingAnchor, constant: 20),
            symbol1.topAnchor.constraint(equalTo: rect1.topAnchor, constant: 55),
            symbol1.widthAnchor.constraint(equalTo: symbol1.heightAnchor, multiplier: 1),
            symbol1.bottomAnchor.constraint(equalTo: rect1.bottomAnchor, constant: -55)
        ])
        
        NSLayoutConstraint.activate([
            symbol2.leadingAnchor.constraint(equalTo: rect2.leadingAnchor, constant: 20),
            symbol2.topAnchor.constraint(equalTo: rect2.topAnchor, constant: 55),
            symbol2.widthAnchor.constraint(equalTo: symbol2.heightAnchor, multiplier: 1),
            symbol2.bottomAnchor.constraint(equalTo: rect2.bottomAnchor, constant: -55)
        ])
        
        NSLayoutConstraint.activate([
            symbol3.leadingAnchor.constraint(equalTo: rect3.leadingAnchor, constant: 20),
            symbol3.topAnchor.constraint(equalTo: rect3.topAnchor, constant: 55),
            symbol3.widthAnchor.constraint(equalTo: symbol3.heightAnchor, multiplier: 1),
            symbol3.bottomAnchor.constraint(equalTo: rect3.bottomAnchor, constant: -55)
        ])
        
        NSLayoutConstraint.activate([
            text1.leadingAnchor.constraint(equalTo: symbol1.trailingAnchor, constant: 20),
            text1.topAnchor.constraint(equalTo: rect1.topAnchor, constant: 55),
            text1.trailingAnchor.constraint(equalTo: rect1.trailingAnchor, constant: -20),
            text1.bottomAnchor.constraint(equalTo: rect1.bottomAnchor, constant: -55)
        ])
        
        NSLayoutConstraint.activate([
            text2.leadingAnchor.constraint(equalTo: symbol2.trailingAnchor, constant: 20),
            text2.topAnchor.constraint(equalTo: rect2.topAnchor, constant: 55),
            text2.trailingAnchor.constraint(equalTo: rect2.trailingAnchor, constant: -20),
            text2.bottomAnchor.constraint(equalTo: rect2.bottomAnchor, constant: -55)
        ])
        
        NSLayoutConstraint.activate([
            text3.leadingAnchor.constraint(equalTo: symbol3.trailingAnchor, constant: 20),
            text3.topAnchor.constraint(equalTo: rect3.topAnchor, constant: 55),
            text3.trailingAnchor.constraint(equalTo: rect3.trailingAnchor, constant: -20),
            text3.bottomAnchor.constraint(equalTo: rect3.bottomAnchor, constant: -55)
        ])
    }
}
