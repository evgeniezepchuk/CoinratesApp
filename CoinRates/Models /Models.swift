//
//  Models.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import Foundation

struct Models: Decodable {
    let rates: [Model]
}

struct Model: Decodable {
    let USD_in: String?
    let USD_out: String?
    let EUR_in: String?
    let EUR_out: String?
    let name: String?
    let name_type: String?
    let street_type: String?
    let street: String?
    let home_number: String?
    let filial_id: String?
    let info_worktime: String?
    let filials_text: String?
    let GPS_X: String?
    let GPS_Y: String?
    let phone_info: String?
}

struct Cities: Decodable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
}
