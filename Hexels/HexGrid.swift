//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. 
//

import Foundation
import SpriteKit
import GameplayKit

class ActiveHexGrid: HexGrid {
  
  var hexNode: SKNode
  
  let manager: GameManager
  var activeHex: ActivatableObject? = nil
  var lastCoordinate: Axialcoordinate? = nil
  
  var particleEmitter: SKEmitterNode
  
  init(gameManager: GameManager, node: SKNode) {
    hexNode = node
    manager = gameManager
    particleEmitter = SKEmitterNode(fileNamed: "pressed")!
    node.addChild(particleEmitter)
    super.init()
  }
  
  func activateHexagon() {
    var tries = 0
    while activeHex == nil && tries <= 50 {
      tries += 1
      let coordinate = getRandomCoordinate(2).toAxial()
      
      if (coordinate != lastCoordinate) {
        if let hex = grid[coordinate] {
          if !hex.active {
            hex.activate()
            particleEmitter.position = coordinate.toWorld()
            particleEmitter.resetSimulation()
            lastCoordinate = coordinate
            activeHex = hex;
          }
        }
      }
    }
    
    if (activeHex == nil || tries >= 50) {
      print("Could not find a suitable hex in 50 turns")
    }
    
    if (random.nextUniform() < 0.1) {
      activatePowerup()
    }
  }
  
  func activatePowerup() {
    var tries = 0;
    var hex: PowerupHex? = nil;
    while hex == nil && tries <= 50 {
      tries += 1;
      
      let coordinate = getRandomCoordinate(2).toAxial();
      
      if let possibleHex = grid[coordinate] {
        if !possibleHex.active {
          if let powerup = possibleHex as? PowerupHex {
            hex = powerup;
            hex?.activate();
            hex?.powered = true;
            switch (arc4random_uniform(2))
            {
            case 0:
              hex?.powerup = { self.manager.startTime += 5; };
              hex?.setPowerUp(imageNamed: "Time")
              break;
            case 1:
              hex?.powerup =  { if (self.manager.lives < 3) {
                                  self.resizeAll(1/0.8)
                                };
                                self.manager.lives += 1;
                              };
              hex?.setPowerUp(imageNamed: "Heart")
              break;
//            case 2:
//              hex?.powerup = { self.manager.score = Int(Double(self.manager.score) * 1.2); };
//              hex?.setPowerUp(imageNamed: "Multiplier")
//              break;
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
        hex.execPowerup();
        hex.resetActive();
        manager.score += 1
      } else if hex.active {
        manager.score += 1
        hex.resetActive()
        activeHex = nil
      } else {
        manager.lives -= 1
        if manager.lives < 3 {
          resizeAll(0.8);
        } else {
          resizeAllInactives()
        }
      }
    }
  }
  
  func resetAllActives() {
    for (_, active) in grid {
      if active.active {
        active.resetActive()
      }
    }
  }
  
  func resizeAll(by: CGFloat) {
    for (_, active) in grid {
      let action = SKAction.scaleBy(by, duration: 0.1)
      action.timingMode = .EaseIn
      active.sprite.runAction(action)
    }
  }
  
  func resizeAllInactives() {
    let action = SKAction.sequence([SKAction.scaleBy(0.8, duration: 0.1),SKAction.scaleBy(1/0.8, duration: 0.1)])
    action.timingMode = .EaseIn
    for (_,active) in grid {
      if !active.active {
        active.sprite.runAction(action)
      }
    }
  }
  
  func resetGrid() {
    for (_,active) in grid {
      if (active.active) {
        active.resetActive()
      }
      if (active.sprite.xScale != active.originalScale) {
        active.sprite.runAction(SKAction.scaleTo(active.originalScale, duration: 0.3))
      }
    }
    activeHex = nil;
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
