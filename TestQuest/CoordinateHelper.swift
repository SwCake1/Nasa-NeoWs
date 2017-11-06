//
//  CoordinateHelper.swift
//  TestQuest
//
//  Created by Владислав Самохин on 04.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import UIKit

// Управление координатами
class CoordinateHelper {
    
    // Ключевые экранные координаты
    let centerY: CGFloat // Координата Y для всех небесных объектов
    let startX: CGFloat  // Начальная координата X Земли
    let endX: CGFloat    // Координата X самого дальнего астероида
    
    // Размеры
    let earthSize: CGFloat
    let smallSize: CGFloat
    let mediumSize: CGFloat
    let bigSize: CGFloat
    
    // Абсолютные данные (для расчета относительных)
    private var maxDiameter = Double()
    private var minDiameter = Double()
    private var maxDistance = Double()
    
    init(centerY: CGFloat,
         startX: CGFloat,
         endX: CGFloat,
         earthSize: CGFloat,
         smallSize: CGFloat,
         mediumSize: CGFloat,
         bigSize: CGFloat) {
        
        self.centerY = centerY
        self.startX = startX
        self.endX = endX
        self.earthSize = earthSize
        self.smallSize = smallSize
        self.mediumSize = mediumSize
        self.bigSize = bigSize
    }
    
    // Задает максимальные дневные значения для расчета относительных величин координат
    func setDayValues(minDiameter: Double, maxDiameter: Double, maxDistance: Double) {
        self.minDiameter = minDiameter
        self.maxDiameter = maxDiameter
        self.maxDistance = maxDistance
        
    }
    
    // Определение размера астероида
    func getRelativeSizeFrom(absoluteDiameter: Double) -> Size {
        switch ( absoluteDiameter - minDiameter ) / ( maxDiameter - minDiameter ) {
        case 0...0.333:
            return .small
        case 0.334...0.666:
            return .medium
        case 0.667...1:
            return .big
        default: return .big
        }
    }
        
        
    // На основании дистанции и размера астеройда возвращается фрейм для его размещения на экране
    func calculateFrameFrom(size: Size, andDistance distance: Double) -> CGRect {
        
        let x =  CGFloat( distance / maxDistance ) * ( endX - startX ) + startX
    
        var sizeCGFloat: CGFloat
        switch size {
        case .small:
            sizeCGFloat = smallSize
        case .medium:
            sizeCGFloat = mediumSize
        case .big:
            sizeCGFloat = bigSize
        }
        
        return CGRect(x: x, y: centerY, width: sizeCGFloat, height: sizeCGFloat).shiftToCenter()
    }
    
    
}
