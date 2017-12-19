//
//  ViewController.swift
//  TestQuest
//
//  Created by Igor Tyukavkin on 22.08.17.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import UIKit
import DatePickerDialog

final class SpaceViewController: UIViewController {
    
    let networkService = NetworkService()
    var date = Date() { didSet { updateTitle() } }
    var cH: CoordinateHelper!
    var asteroids = [Asteroid]()
    
    @IBOutlet weak var titleButton: UIButton!
    @IBAction func tittleTouch(_ sender: UIButton) {
        chooseDate() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Space"))
        setupCoordinateHelper()
        downloadAsteroidsAndUpdate()
        drawSpace()
    }
    
    // Загрузка данных из сети/кэша и обновление экрана
    fileprivate func downloadAsteroidsAndUpdate() {
        
        // Сперва пытаемся загрузить из кеша
        let asteroidsFromCache = networkService.readAsteroidsFromCache(on: date)
        if asteroidsFromCache.isEmpty == false {
            asteroids = asteroidsFromCache
            drawSpace()
        }
        
        // Затем загружаем из сети и обновляем кэш
        networkService.downloadAsteroids(on: date) { [weak self] asteroidsFromAPI in
            self?.asteroids = asteroidsFromAPI
            self?.drawSpace()
        }
    }
    
    // Настройка координатной системы
    fileprivate func setupCoordinateHelper() {
        
        if cH == nil {
            cH = CoordinateHelper(centerY: view.bounds.midY,
                                  startX: 40,
                                  endX: view.bounds.maxX - 40,
                                  earthSize: 50,
                                  smallSize: 30,
                                  mediumSize: 35,
                                  bigSize: 40)
        }
    }
    
    // Обновление макс. значений для расчета относительных величин координат
    fileprivate func updateCoordinateHelperMaxValues() {
        
        let maxDiameter = asteroids.max{ $0.diameter < $1.diameter }?.diameter ?? 0
        let minDiameter = asteroids.min{ $0.diameter < $1.diameter }?.diameter ?? 0
        let maxDistance = asteroids.max{ $0.distance < $1.distance }?.distance ?? 0
        cH.setDayValues(minDiameter: minDiameter, maxDiameter: maxDiameter, maxDistance: maxDistance)
    }
    
    // Отрисовка всей сцены
    fileprivate func drawSpace() {
        
        view.subviews.forEach({ $0.removeFromSuperview() }) // Очистка иерархии
        
        updateCoordinateHelperMaxValues()
        drawAsteroids()
        drawEarth()
    }
    
    // Отрисовка земли
    fileprivate func drawEarth() {
        let earth = EarthView(name: "Земля", diameter: 12742,
                              frame: CGRect(x:cH.startX, y: cH.centerY, width: cH.earthSize, height: cH.earthSize).shiftToCenter())
        
        view.addSubview(earth)
    }
    
    // Отрисовка астероидов
    fileprivate func drawAsteroids() {
        for asteroid in asteroids {
            let size = cH.getRelativeSizeFrom(absoluteDiameter: asteroid.diameter)
            let frame = cH.calculateFrameFrom(size: size, andDistance: asteroid.distance)
            
            let asteroidView = AsteroidView(asteroid: asteroid, size: size, frame: frame)
            view.addSubview(asteroidView)
        }
    }
    
    // Выбор даты через диалог
    fileprivate func chooseDate() {
        
        let datePickerDialog = DatePickerDialog(buttonColor: UIColor.black)
        datePickerDialog.show(
            "Дата",
            doneButtonTitle: "Выбрать",
            cancelButtonTitle: "Отмена",
            defaultDate: self.date,
            datePickerMode: .date) { (date) -> Void in
                guard date != nil else { return }
                self.date = date ?? Date()
                self.downloadAsteroidsAndUpdate()
        }
    }
    
    // Задаем текст заголовка на выбранной даты
    fileprivate func updateTitle() {
        
        // Если выбрана сегодняшняя дата
        if NSCalendar.current.isDate(date, inSameDayAs: Date()) {
            titleButton.setTitle("Сегодня ▾", for: .normal)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let stringDate = dateFormatter.string(from: date)
        titleButton.setTitle("\(stringDate) ▾", for: .normal)
    }
}
