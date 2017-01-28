//
//  GameViewController.swift
//  Swiftris
//
//  Created by Jennifer A Sipila on 1/26/17.
//  Copyright © 2017 Jennifer A Sipila. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameLogicDelegate, UIGestureRecognizerDelegate {

    var scene: GameScene!
    var gameLogic: GameLogic!
    var panPointReference:CGPoint?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false

        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        
        gameLogic = GameLogic()
        gameLogic.delegate = self
        gameLogic.beginGame()
        
        
        // Present the scene.
        skView.presentScene(scene)
        
        
//        scene.addPreviewShapeToScene(shape: gameLogic.nextShape!) {
//            self.gameLogic.nextShape?.moveTo(column: StartingColumn, row: StartingRow)
//            self.scene.movePreviewShape(shape: self.gameLogic.nextShape!) {
//                let nextShapes = self.gameLogic.newShape()
//                self.scene.startTicking()
//                self.scene.addPreviewShapeToScene(shape: nextShapes.nextShape!) {}
//            }
//        }
//
    }

    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            // #3
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    gameLogic.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    gameLogic.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
        
    }
   
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        
         gameLogic.rotateShape()
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
         gameLogic.dropShape()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //Keeps gesture recognizers from fighting
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //Lowers the falling shape by one row and then asks GameScene to redraw the shape at its new location.
    func didTick() {
        gameLogic.letShapeFall()
//        gameLogic.fallingShape?.lowerShapeByOneRow()
//        scene.redrawShape(shape: gameLogic.fallingShape!, completion: {})
    }
    
    func nextShape() {
        let newShapes = gameLogic.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            // #16
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(gameLogic swiftris: GameLogic) {
        
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(gameLogic: GameLogic) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        
        scene.playSound(sound: "Sounds/gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: gameLogic.removeAllBlocks(), fallenBlocks: gameLogic.removeAllBlocks()) {
            gameLogic.beginGame()
        }
    }
    
    func gameDidLevelUp(gameLogic: GameLogic) {
        levelLabel.text = "\(gameLogic.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound(sound: "Sounds/levelup.mp3")
        
    }
    
    func gameShapeDidDrop(gameLogic: GameLogic) {
        scene.stopTicking()
        scene.redrawShape(shape: gameLogic.fallingShape!) {
            gameLogic.letShapeFall()
        }
        scene.playSound(sound: "Sounds/drop.mp3")
        
    }
    
    func gameShapeDidLand(gameLogic: GameLogic) {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        // #10
        let removedLines = gameLogic.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(gameLogic.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #11
                self.gameShapeDidLand(gameLogic: gameLogic)
            }
            scene.playSound(sound: "Sounds/bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    // #17
    func gameShapeDidMove(gameLogic: GameLogic) {
        scene.redrawShape(shape: gameLogic.fallingShape!) {}
    }
}
