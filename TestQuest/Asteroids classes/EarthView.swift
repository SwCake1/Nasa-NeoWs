//
//  EarthView.swift
//  TestQuest
//
//  Created by Владислав Самохин on 07.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import UIKit

final class EarthView: SpaceObjectView {
    
    override init(name: String, diameter: Double, frame: CGRect) {
        super.init(name: name, diameter: diameter, frame: frame)
        
        image = #imageLiteral(resourceName: "earth")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
