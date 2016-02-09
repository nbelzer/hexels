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
  
  var gameRunning = false
  
  var gameLength: Int = 30
  var startTime: CFTimeInterval = 0
  var currentTime: CFTimeInterval = 0
  var timeLeft: Int {
    get {
      return gameLength - Int(currentTime - startTime)
    }
  }
  
  private var currentScore = 0
  internal var score: Int {
    get {
      return currentScore
    }
    set {
      currentScore = newValue
      updateLabel()
    }
  }
  
  init(centerNode: SKNode, label: SKLabelNode) {
    self.hexNode = centerNode
    self.label = label
  }
  
  func initializeLevel() {
    grid = ActiveHexGrid(gameManager: self, node: hexNode)
    grid.createGrid(Int(2), atNode: hexNode)
  }
  
  func startGame() {
    gameRunning = true
    startTime = currentTime
  }
  
  func endGame() {
    if (currentScore > highscore) {
      highscore = currentScore
    }
    gameRunning = false
    score = 0
  }
  
  func updateLabel() {
    label.text = "\(currentScore) [\(timeLeft)][\(highscore)]"
  }
  
  func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    self.currentTime = currentTime
    
    if (!gameRunning) {
      startGame();
    }
    
    if (self.startTime + CFTimeInterval(gameLength) <= self.currentTime) {
      endGame()
    }
    
    if (grid.activeHex == nil) {
      grid.activateHexagon()
    }
    
    updateLabel()
  }
}
