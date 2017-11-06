//
//  SpaceObjectView.swift
//  TestQuest
//
//  Created by Владислав Самохин on 04.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import UIKit

class SpaceObjectView: UIImageView {

    let name: String
    let diameter: String
    
    init(name: String, diameter: Double, frame: CGRect) {
        
        // Из имени убираются скобки
        if name.characters.first == "(" {
            self.name = String(name.dropFirst().dropLast())
        } else {
            self.name = name
        }
        self.diameter = String(format: "%.0f", diameter.rounded())  + " м"
        
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
