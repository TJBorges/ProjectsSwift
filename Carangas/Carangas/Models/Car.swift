//
//  Car.swift
//  Carangas
//
//  Created by Douglas Frari on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    
    var _id: String?
    var brand: String = "" // marca
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.00
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

// GET: http://fipeapi.appspot.com/api/1/carros/marcas.json
struct Brand: Codable {
    let fipe_name: String
}

