//
//  Asteroid.swift
//  TestQuest
//
//  Created by Владислав Самохин on 02.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

// Данные астероида
final class Asteroid: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var diameter = 0.0
    @objc dynamic var distance = 0.0
    
    convenience init(json: JSON) {
        self.init()

        name = json["name"].stringValue
        
        // Для диаметра и расстояния берем среднее значение
        diameter = ( json["estimated_diameter"]["meters"]["estimated_diameter_min"].doubleValue +
                     json["estimated_diameter"]["meters"]["estimated_diameter_max"].doubleValue ) / 2
            
        distance = json["close_approach_data"][0]["miss_distance"]["kilometers"].doubleValue
    }
    
}
