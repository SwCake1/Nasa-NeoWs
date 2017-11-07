//
//  Feed.swift
//  TestQuest
//
//  Created by Владислав Самохин on 07.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import RealmSwift

// Класс для кэширования данных в Realm в разрезе дат
final class Feed: Object {
    @objc dynamic var date = ""
    let asteroids = List<Asteroid>()
    
    convenience init(date: String, asteroids: [Asteroid]) {
        self.init()
        self.date = date
        self.asteroids.append(objectsIn: asteroids)
    }
    
    override static func primaryKey() -> String? {
        return "date"
    }
}
