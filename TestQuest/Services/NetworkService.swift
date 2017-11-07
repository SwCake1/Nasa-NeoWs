//
//  NetworkService.swift
//  TestQuest
//
//  Created by Igor Tyukavkin on 22.08.17.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

// Класс для работы с сеть и кэшем
final class NetworkService {
    
    let baseURL = "https://api.nasa.gov/neo/rest/v1/"
    let apiKey = "mnRXibKwjv8IKogwxu4ITik4lKy8B2ADyUBZpc13"
    
    // Загрузка данных астероидов на выбранную дату
    func downloadAsteroids(on date: Date, completion: @escaping ([Asteroid]) -> Void) {
        
        // Формирование запроса
        let path = "feed"
        let url = baseURL + path
        let stringDate = stringFrom(date: date)
        
        let parameters: Parameters = [
            "start_date": stringDate,
            "end_date": stringDate,
            "api_key": apiKey
        ]
        
        // Выполнение запроса
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let data = response.value else {
                print("Не удалось получить JSON: ", response.error ?? "нет данных")
                return
            }
            
            let request = response.request?.url?.absoluteString ?? ""
            print("Запрос данных: " +  request)
            
            // Раскладываем JSON
            let json = JSON(data)
            let filteredJSONFeeds = json["near_earth_objects"][stringDate].array?.filter{
                $0["close_approach_data"][0]["orbiting_body"] == "Earth" }
            let asteroids  = filteredJSONFeeds?.map { Asteroid(json: $0) } ?? []
            
            self?.updateCache(with: asteroids, on: stringDate)
            
            completion(asteroids)
        }
    }
    
    // Сохранение кэша в Realm
    fileprivate func updateCache(with asteroids: [Asteroid], on date: String) {
        
        let feed = Feed(date: date, asteroids: asteroids)
        
        do {
            let realm = try Realm()
            print("Конфигурация Realm", realm.configuration.fileURL ?? "")
            
            realm.beginWrite()
            realm.add(feed, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // Чтение из кэша Realm
    func readAsteroidsFromCache(on date: Date) -> [Asteroid] {
        
        let stringDate = stringFrom(date: date)
        var asteroids = [Asteroid]()
        
        do {
            let realm = try Realm()
            let feed = realm.objects(Feed.self).filter( "date = '\(stringDate)'").first
            if let asteroidList = feed?.asteroids {
                asteroids = Array(asteroidList)
            }
        } catch {
            print(error)
        }
        
        return asteroids
    }
    
    // Перевод даты в строку
    fileprivate func stringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
}
