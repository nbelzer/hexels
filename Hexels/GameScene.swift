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
  
  var manager: GameManager!
  var startButton: UIButton!
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    let label = SKLabelNode(fontNamed: "Sans Fransico")
    label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 64)
    label.fontSize = 40
    label.fontColor = UIColor.orangeColor()
    self.addChild(label)
    
    startButton = UIButton(type: .System)
    startButton.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.25, alpha: 0.95);
    startButton.frame = CGRectMake(0, view.frame.midY - 50, view.frame.width, 100)
    startButton.setTitle("START GAME", forState: .Normal)
    startButton.setTitleColor(UIColor.orangeColor(), forState: .Normal);
    startButton.addTarget(self, action: Selector("startGame"), forControlEvents: .TouchDown)
    view.addSubview(startButton);
    
    let hexNode = SKLabelNode()
    hexNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
    self.addChild(hexNode);
    
    manager = GameManager(centerNode: hexNode, label: label)
    manager.initializeLevel()
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    for touch in touches {
      if manager.gameRunning {
        manager.grid.deactivate(touch)
      }
    }
  }

  override func update(currentTime: CFTimeInterval) {
    manager.update(currentTime)
    
    if !manager.gameRunning {
      startButton.hidden = false;
    }
  }
  
  func startGame() {
    manager.endGame();
    manager.startGame();
    startButton.hidden = true;
  }
}
