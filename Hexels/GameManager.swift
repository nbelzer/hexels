//
//  GameManager.swift
//  Hexels
//
//  Created by Nick Belzer on 08/02/16.
//  Copyright © 2016 Nick Belzer. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class GameManager {
  var grid: ActiveHexGrid!
  let hexNode: SKNode
  
  var highscore: Int = 0
  var label: SKLabelNode = SKLabelNode()
  
  private var currentScore = 0
  internal var score: Int {
    get {
      return currentScore
    }
    set {
      currentScore = newValue
      label.text = "\(currentScore) [\(highscore)]"
    }
  }
  
  init(centerNode: SKNode, label: SKLabelNode) {
    self.hexNode = centerNode
    self.label = label
  }
  
  func startGame() {
    score = 0
    grid = ActiveHexGrid(gameManager: self, node: hexNode)
    grid.createGrid(Int(2), atNode: hexNode)
  }
  
  func endGame() {
    if (currentScore > highscore) {
      highscore = currentScore
    }
    score = 0
  }
  
  func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    if (grid.activeHex == nil) {
      grid.activateHexagon()
    }
  }
}
