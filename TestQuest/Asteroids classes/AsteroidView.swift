//
//  AsteroidView.swift
//  TestQuest
//
//  Created by Владислав Самохин on 03.11.2017.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

enum Size {
    case small, medium, big
}

final class AsteroidView: SpaceObjectView {
    
    let asteroidSize: Size
    let distance: String
    
    init(asteroid: Asteroid, size: Size, frame: CGRect) {
        
        asteroidSize = size
        distance = String(format: "%.0f", (asteroid.distance / 1000000))  + " млн. км"
        
        super.init(name: asteroid.name, diameter: asteroid.diameter, frame: frame)
        
        switch size {
        case .small:
            self.image = #imageLiteral(resourceName: "asteroid1")
        case .medium:
            self.image = #imageLiteral(resourceName: "asteroid2")
        case .big:
            self.image = #imageLiteral(resourceName: "asteroid3")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Начало тача")
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveLinear],
                       animations: { [weak self] in self?.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5) },
                       completion: nil )
                       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Конец тача")
        
        let deselect = {
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in self?.transform = CGAffineTransform.identity },
                           completion: nil )
        }
        
        FTPopOverMenu.showForSender(sender: self,
                                    with: [name, diameter, distance],
                                    menuImageArray: ["NameIcon", "DiameterIcon", "DistanceIcon"],
                                    done: { _ in deselect() },
                                    cancel: { _ in deselect() } )
    }
    
    required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
