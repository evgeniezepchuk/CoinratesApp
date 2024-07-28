//
//  LocationManager.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import Foundation
import YandexMapsMobile

final class LocationManager {
    var latitude: Double
    var longitude: Double
   
    lazy var mapView: YMKMapView = {
        let view = YMKMapView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        view.mapWindow.map.move(
               with: YMKCameraPosition(
                target: YMKPoint(latitude: latitude, longitude: longitude),
                   zoom: 17,
                   azimuth: 0,
                   tilt: 0
               ),
               animation: YMKAnimation(type: .smooth, duration: 9),
               cameraCallback: nil)
        addPlacemark(view.mapWindow.map)
        return view
    }()
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func addPlacemark(_ map: YMKMap) {
        let image = UIImage(systemName: "mappin.and.ellipse") ?? UIImage()
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: latitude, longitude: longitude)
        placemark.setIconWith(image)
    }
}
