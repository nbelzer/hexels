//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. All rights reserved.
//

import Foundation
import SpriteKit

class HexGrid {

  var grid = [Axialcoordinate: Tile]()
  
  func createGrid(size: Int, atNode: SKNode) {
    for (_, hex) in grid {
      hex.sprite.removeFromParent();
    }
    
    grid = [:]
    
    for x in -size...size {
      for y in -size...size {
        let z = -x-y
        
        if abs(z) <= size {
          let axial = Axialcoordinate(q: x, r: z);
          createHexagon(axial)
        }
      }
    }
    
    addToNode(atNode)
  }
  
  func addToNode(node: SKNode) {
    for (_, hex) in grid {
      node.addChild(hex.sprite)
    }
  }
  
  func createHexagon(atPosition: Axialcoordinate) {
    grid[atPosition] = Tile(atCoordinate: atPosition);
  }
}
