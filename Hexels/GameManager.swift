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
  
  var grid: HexGrid!;
  let hexNode: SKNode;

  var currentTime: CFTimeInterval = 0;
  
  init(centerNode: SKNode) {
    self.hexNode = centerNode;
  }
  
  func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    self.currentTime = currentTime;
  }
}
