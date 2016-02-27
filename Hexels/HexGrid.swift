//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. 
//

import Foundation
import SpriteKit

class ActiveHexGrid: HexGrid {
  
  var hexNode: SKNode
  
  let manager: GameManager
  var activeHex: ActivatableObject? = nil
  var lastCoordinate: Axialcoordinate? = nil
  
  init(gameManager: GameManager, node: SKNode) {
    hexNode = node
    manager = gameManager
    super.init()
  }
  
  func activateHexagon() {
    var tries = 0
    while activeHex == nil && tries <= 50 {
      tries += 1
      let coordinate = getRandomCoordinate(2).toAxial()
      
      if (coordinate != lastCoordinate) {
        activeHex = grid[coordinate]
        activeHex?.activate()
        lastCoordinate = coordinate
      }
    }
    
    if (activeHex == nil || tries >= 50) {
      print("Could not find a suitable hex in 50 turns")
    }
    
    if (arc4random_uniform(100) < 10) {
      activatePowerup()
    }
  }
  
  func activatePowerup() {
    var tries = 0;
    var hex: PowerupHex? = nil;
    while hex == nil && tries <= 50 {
      tries += 1;
      
      let coordinate = getRandomCoordinate(2).toAxial();
      
      if let possibleHex =  grid[coordinate] {
        if !possibleHex.active {
          if let powerup = possibleHex as? PowerupHex {
            hex = powerup;
            hex?.activate();
            hex?.powered = true;
            switch (arc4random_uniform(3))
            {
            case 0:
              hex?.powerup = { self.manager.startTime += 5; };
              hex?.setPowerUp(imageNamed: "time")
              break;
            case 1:
              hex?.powerup = { self.manager.lives += 1; };
              hex?.setPowerUp(imageNamed: "lives")
              break;
            case 2:
              hex?.powerup = { self.manager.score = Int(Double(self.manager.score) * 1.2); };
              hex?.setPowerUp(imageNamed: "score")
              break;
            default:
              hex?.powerup = {};
            }
          }
        }
      }
    }
  }
  
  func deactivate(byTouch: UITouch) {
    let location = byTouch.locationInNode(hexNode)
    
    let axial = toAxial((x: Int(location.x), y: Int(location.y)))
    
    if let hex = grid[axial] as? PowerupHex {
      if hex.powered {
        hex.resetActive();
        manager.score += 1
      } else if hex.active {
        manager.score += 1
        hex.resetActive()
        activeHex = nil
      } else {
        resetAllActives()
        manager.lives -= 1
      }
    }
  }
  
  func resetAllActives() {
    for (_, active) in grid {
      if !active.active {
        active.resetActive()
      }
    }
  }
  
  override func createHexagon(atPosition: Axialcoordinate) {
    grid[atPosition] = PowerupHex(atCoordinate: atPosition, manager: manager)
  }
}

class HexGrid {

  var grid = [Axialcoordinate: ActivatableObject]()

  init() {
//    createGrid(15);
  }
  
  func createGrid(size: Int, atNode: SKNode) {
    for (_, hex) in grid {
      hex.sprite.removeFromParent();
    }
    
    grid = [:]
    
    for x in -size...size {
      for y in -size...size {
        let z = -x-y
        
        if abs(z) <= size {
          let axial = Axialcoordinate(q: x, r: z);
          createHexagon(axial)
        }
      }
    }
    
    addToNode(atNode)
  }
  
  func addToNode(node: SKNode) {
    for (_, hex) in grid {
      node.addChild(hex.sprite)
    }
  }
  
  func createHexagon(atPosition: Axialcoordinate) {
    grid[atPosition] = StandardHex(atCoordinate: atPosition);
  }
}
