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
  
  var manager: GameManager!;
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
//    let label = SKLabelNode(fontNamed: "Sans Fransico")
//    label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 64)
//    label.fontSize = 64
//    label.fontColor = UIColor.blackColor()
//    self.addChild(label)
    
    let hexNode = SKLabelNode();
    hexNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
    self.addChild(hexNode);

    manager = GameManager(centerNode: hexNode);
    manager.grid.createGrid(20, atNode: manager.hexNode);
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    for touch in touches {

    }
  }

  override func update(currentTime: CFTimeInterval) {
    manager.update(currentTime);
  }
}
