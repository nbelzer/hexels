//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. 
//

import Foundation
import SpriteKit;

protocol Hexagon {
  var coordinate: Axialcoordinate { get set }
}

class ActivatableObject {
  var sprite: SKSpriteNode
  var color: UIColor
  var active: Bool = false
  
  init(imageNamed: String, atPosition: CGPoint) {
    sprite = SKSpriteNode(imageNamed: "Hexagon");
    sprite.xScale = 0.5
    sprite.yScale = 0.5
    
    sprite.position = atPosition;
    color = getRandomColor(8)
  }
  
  func activate() {
    let colorAction = SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: 0.15)
    colorAction.timingMode = SKActionTimingMode.EaseOut
    if sprite.hasActions() {
      sprite.removeAllActions()
    }
    sprite.runAction(colorAction)
    active = true
  }
  
  func resetActive() {
    let resetAction = SKAction.group([
      SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.4),
      SKAction.sequence([
        SKAction.scaleTo(0.45, duration: 0.1),
        SKAction.scaleTo(0.5, duration: 0.1)
        ])
      ])
    resetAction.timingMode = SKActionTimingMode.EaseIn
    sprite.runAction(resetAction)
    active = false
  }
}

class StandardHex: ActivatableObject, Hexagon {
  var coordinate: Axialcoordinate
  
  init(atCoordinate: Axialcoordinate) {
    coordinate = atCoordinate
    super.init(imageNamed: "hexagon", atPosition: atCoordinate.toWorld())
  }
}

class PowerupHex: StandardHex {
  
  var manager: GameManager;
  var powered: Bool = false;
  var powerup:()->() = {}
  
  init(atCoordinate: Axialcoordinate, manager: GameManager) {
    self.manager = manager
    super.init(atCoordinate: atCoordinate)
  }
  
  override func resetActive() {
    super.resetActive()
    powerup()
    powerup = {};
    powered = false;
  }
}
