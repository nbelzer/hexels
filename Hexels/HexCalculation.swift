//
//  HexCalculation.swift
//  Hexels
//
//  Created by Nick Belzer on 02/02/16.
//  Copyright © 2016 Nick Belzer. 
//

import UIKit
import Darwin
import GameplayKit

let hexSize :Double = 75 // 40.0
let directions = [Axialcoordinate(q: +1, r: 0), Axialcoordinate(q: +1, r: -1), Axialcoordinate(q: 0, r: -1), Axialcoordinate(q: -1, r: 0), Axialcoordinate(q: -1, r: +1), Axialcoordinate(q: 0, r: +1)];
let random = GKARC4RandomSource();

extension Axialcoordinate {

  func toWorld() -> CGPoint {
    let xPos = hexSize * sqrt(3) * Double(Double(q) + Double(r) / 2.0)
    let yPos = hexSize * 3.0 / 2.0 * Double(r)
    return CGPoint(x: xPos, y: yPos)
  }
}

extension Cubecoordinate {
  
  func toWorld() -> CGPoint {
    let xPos = hexSize * sqrt(3) * Double(Double(x) + Double(z) / 2.0)
    let yPos = hexSize * 3.0 / 2.0 * Double(z)
    return CGPoint(x: xPos, y: yPos)
  }
}

func +(left: Axialcoordinate, right: Axialcoordinate) -> Axialcoordinate {
  return Axialcoordinate(q: left.q + right.q, r: left.r + right.r)
}

func +(left: Cubecoordinate, right: Cubecoordinate) -> Cubecoordinate {
  return Cubecoordinate(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

/** 
 Gives all the coordinates of the neighbours of an axialcoordinate.

 - Parameter coordinate: The coordinate you want to know the neighbours off
 - Returns: Returns all the neighbours of the given coordiante.
 */
func getNeighbours(coordinate: Axialcoordinate) -> [Axialcoordinate] {
  var neighbours = [Axialcoordinate]()
  for i in 0...6 {
    neighbours.append(coordinate + directions[i])
  }
  return neighbours
}

func toAxial(worldPosition: (x: Int, y: Int)) -> Axialcoordinate {
  var q = Double(worldPosition.x) * sqrt(3) / 3.0
  q -= Double(worldPosition.y) / 3.0
  q = round(q/hexSize)
  var r = Double(worldPosition.y) * 2.0
  r /= 3.0
  r /= hexSize
  r = round(r)
  
  return Axialcoordinate(q: Int(q), r: Int(r));
}

func getRandomCoordinate(gridSize: Int) -> Cubecoordinate {
  let x = Int(random.nextUniform() * Float((2 * gridSize)+1)) - gridSize;
  let z = Int(random.nextUniform() * Float((2 * gridSize)+1)) - gridSize;
  let y = -x - z
  return Cubecoordinate(x: x, y: y, z: z)
}

func getRandomColor() -> UIColor {
  return UIColor(hue: CGFloat(random.nextUniform()), saturation: 1.0, brightness: 0.8, alpha: 1.0)
}
