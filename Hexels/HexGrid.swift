//
// Created by Nick Belzer on 02/02/16.
// Copyright (c) 2016 Nick Belzer. All rights reserved.
//

import Foundation

class HexGrid {

  var grid = [Axialcoordinate: ActivatableObject]()

  init() {
//    createGrid(15);
  }
  
  func createGrid(size: Int) {
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
  }
    
  func createHexagon(atPosition: Axialcoordinate) {
    grid[atPosition] = StandardHex(atCoordinate: atPosition);
  }
}
