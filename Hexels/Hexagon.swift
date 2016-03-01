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
  let originalScale: CGFloat = 0.8
  
  init(imageNamed: String, atPosition: CGPoint) {
    sprite = SKSpriteNode(imageNamed: "Hexagon");
    sprite.xScale = originalScale
    sprite.yScale = originalScale
    
    sprite.position = atPosition;
    color = getRandomColor()
  }
  
  func activate() {
    let colorAction = SKAction.colorizeWithColor(color, colorBlendFactor: 1.0, duration: 0.15)
    colorAction.timingMode = SKActionTimingMode.EaseOut
    if sprite.hasActions() {
      sprite.removeAllActions()
    }
    sprite.runAction(colorAction)
    active = true
    
    let activeAction =
      SKAction.sequence([
        SKAction.scaleBy(1.2, duration: 0.1),
        SKAction.scaleBy(1/1.2, duration: 0.1)
        ])
    activeAction.timingMode = .EaseIn
    sprite.runAction(activeAction)
  }
  
  func resetActive() {
    let resetAction = SKAction.group([
      SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.4),
      SKAction.sequence([
        SKAction.scaleBy(0.8, duration: 0.1),
        SKAction.scaleBy(1/0.8, duration: 0.1)
        ])
      ])
    resetAction.timingMode = .EaseIn
    sprite.runAction(resetAction)
    active = false
  }
}

class StandardHex: ActivatableObject, Hexagon {
  var coordinate: Axialcoordinate
  
  init(atCoordinate: Axialcoordinate) {
    coordinate = atCoordinate
    super.init(imageNamed: "Hexagon", atPosition: atCoordinate.toWorld())
  }
}

class PowerupHex: StandardHex {
  
  var manager: GameManager;
  var powered: Bool = false;
  var activeSprite: SKSpriteNode?
  var powerup:()->() = {}
  
  init(atCoordinate: Axialcoordinate, manager: GameManager) {
    self.manager = manager
    super.init(atCoordinate: atCoordinate)
  }
  
  func setPowerUp(imageNamed image: String) {
    activeSprite = SKSpriteNode(imageNamed: image)
    activeSprite?.xScale = 0.5;
    activeSprite?.yScale = 0.5;
    activeSprite?.zPosition = 5;
    sprite.addChild(activeSprite!)
  }
  
  func execPowerup() {
    powerup()
    powerup = {};
    powered = false;
    
    let resetAction =
      SKAction.group([
        SKAction.scaleTo(7, duration: 0.3),
        SKAction.fadeAlphaTo(0, duration: 0.3)])
    resetAction.timingMode = .EaseIn
    activeSprite?.runAction(resetAction, completion: {
      self.activeSprite?.removeFromParent()
      self.activeSprite = nil
    })
  }
  
  override func resetActive() {
    super.resetActive()
    powerup = {};
    powered = false;
  }
}
