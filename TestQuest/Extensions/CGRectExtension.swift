//
//  CGRectExtansion.swift
//  TestQuest
//
//  Created by Владислав Самохин on 04.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    // Позволяет при работе с координатами использовать координаты центра, а не левого верхнего угла
    func shiftToCenter() -> CGRect {
        return self.offsetBy(dx: -width/2, dy: -height/2)
    }
}
