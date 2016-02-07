//
//  GameScene.swift
//  Hexels
//
//  Created by Nick Belzer on 02/02/16.
//  Copyright (c) 2016 Nick Belzer. All rights reserved.
//

import UIKit
import SpriteKit
import Darwin;

class GameScene: SKScene {
  let grid = HexGrid()
  let hexNode = SKNode()
  var activeHex: ActivatableObject? = nil
  var lastCoordinate: Axialcoordinate? = nil
  var score: Int = 0
  var highscore: Int = 0
  var label: SKLabelNode = SKLabelNode()
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    label = SKLabelNode(fontNamed: "Sans Fransico")
    label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 64)
    label.fontSize = 64
    label.fontColor = UIColor.blackColor()
    self.addChild(label)
    
    hexNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
    self.addChild(hexNode);
    
    grid.createGrid(Int(2))
      for (_, hex) in grid.grid {
      hexNode.addChild(hex.sprite)
    }
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    for touch in touches {
      deactivate(touch)
    }
  }

  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    while activeHex == nil {
      let coordinate = getRandomCoordinate(2).toAxial()
      
      if (coordinate != lastCoordinate) {
        activeHex = grid.grid[coordinate]
        activeHex?.activate()
        lastCoordinate = coordinate
      }
    }
  }
  
  func deactivate(byTouch: UITouch) {
    let location = byTouch.locationInNode(hexNode)
    
    let axial = toAxial((x: Int(location.x), y: Int(location.y)))
    
    if let hex = grid.grid[axial] {
      if hex.active {
        score += 1
        print(score)
        hex.resetActive()
        activeHex = nil
      } else {
        if (score > highscore) {
          highscore = score
        }
        
        score = 0
        resetAllActives()
      }
      label.text = "\(score) : [\(highscore)]"
    }
  }
  
  func resetAllActives() {
    for (_, active) in grid.grid {
      if !active.active {
        active.resetActive()
      }
    }
  }
}
