//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. All rights reserved.
//

import Foundation
import SpriteKit;

protocol Hexagon {
  var coordinate: Axialcoordinate { get set }
}

class Tile: Hexagon {
  
  let sprite: SKSpriteNode;
  var coordinate: Axialcoordinate;
  
  init(atCoordinate: Axialcoordinate) {
    self.coordinate = atCoordinate;
    sprite = SKSpriteNode(imageNamed: "hexagon");
    sprite.position = coordinate.toWorld();
    sprite.xScale = 0.2;
    sprite.yScale = sprite.xScale;
    sprite.colorBlendFactor = 1.0;
    sprite.color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1)
  }
}