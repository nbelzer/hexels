//
//  GameViewController.swift
//  Hexels
//
//  Created by Nick Belzer on 02/02/16.
//  Copyright (c) 2016 Nick Belzer. 
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    if let scene = GameScene(fileNamed: "GameScene") {
      // Configure the view.
      let skView = self.view as! SKView
      skView.showsFPS = true
      skView.showsNodeCount = true

      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true

      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .ResizeFill

      skView.presentScene(scene)
    }
  }

  override func shouldAutorotate() -> Bool {
    return false
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return .Portrait
    } else {
      return .Portrait
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
