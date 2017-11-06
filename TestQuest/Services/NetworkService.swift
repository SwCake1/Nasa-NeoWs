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

class NetworkService {
    // example https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY
    let baseURL = "https://api.nasa.gov/neo/rest/v1/"
    let apiKey = "mnRXibKwjv8IKogwxu4ITik4lKy8B2ADyUBZpc13"
    
    func downloadAsteroids(on date: Date, completion: @escaping ([Asteroid]) -> Void) {
        
        // Формирование запроса
        let path = "feed"
        let url = baseURL + path
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: date)
        
        let parameters: Parameters = [
            "start_date": stringDate,
            "end_date": stringDate,
            "api_key": apiKey
        ]
        
        // Выполнение запроса
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else {
                print("Не удалось получить JSON: ", response.error ?? "нет данных")
                return
            }
            
            let request = response.request?.url?.absoluteString ?? ""
            print("Запрос данных: " +  request)
            
            // Раскладываем JSON
            let json = JSON(data)
            
            let filteredFeeds = json["near_earth_objects"][stringDate].array?.filter{
                $0["close_approach_data"][0]["orbiting_body"] == "Earth" }
            
            let asteroids  = filteredFeeds?.map { Asteroid(json: $0) } ?? []
            completion(asteroids)
        }
    }
}



//Описание АПИ. ENDPOINT: Список Asteroids по дате.
//https://api.nasa.gov/api.html

//Ключ АПИ
//api_key=mnRXibKwjv8IKogwxu4ITik4lKy8B2ADyUBZpc13

//Отфильтровать результаты
//"orbiting_body": "Earth"
//"close_approach_data": "miss_distance"
