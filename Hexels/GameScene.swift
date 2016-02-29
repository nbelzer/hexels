//
//  GameScene.swift
//  Hexels
//
//  Created by Nick Belzer on 02/02/16.
//  Copyright (c) 2016 Nick Belzer. 
//

import UIKit
import SpriteKit
import Darwin;

class GameScene: SKScene {
  
  var manager: GameManager!
  var startButton: UIButton!
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    
    startButton = UIButton(type: .Custom)
    startButton.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.20, alpha: 0.98);
    startButton.frame = CGRectMake(0, view.frame.minY + 100, view.frame.width, 80)
    startButton.setTitle("START GAME", forState: .Normal)
    startButton.titleLabel?.font = UIFont.systemFontOfSize(35)
    startButton.setTitleColor(UIColor.orangeColor(), forState: .Normal);
    startButton.addTarget(self, action: Selector("startGame"), forControlEvents: .TouchDown)
    view.addSubview(startButton);
    
    let hexNode = SKLabelNode()
    hexNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
    self.addChild(hexNode);
    
    manager = GameManager(centerNode: hexNode, scene: self)
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
