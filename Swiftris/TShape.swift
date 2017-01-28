//
//  TShape.swift
//  Swiftris
//
//  Created by Jennifer A Sipila on 1/27/17.
//  Copyright © 2017 Jennifer A Sipila. All rights reserved.
//

import Foundation

class TShape:Shape {

    /*
 
    
    Orientation 0
 
            0
        1   2   3
 
    Orientation 90
     
        1
        2   0
        3
     
     Orientation 180
     
        1   2   3
            0
     
     Orientation 270
     
            1
        0   2
            3

    
   */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero: [(1, 0), (0, 1), (1, 1), (2, 1)],
            Orientation.Ninety: [(1, 1), (0, 0), (0, 1), (0, 2)],
            Orientation.OneEighty: [(1, 1), (0, 0), (1, 0), (2, 0)],
            Orientation.TwoSeventy: [(0, 1), (1, 0), (1, 1), (1, 2)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[SecondBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety:     [blocks[FourthBlockIdx]],
            Orientation.OneEighty:  [blocks[FirstBlockIdx]],
            Orientation.TwoSeventy: [blocks[FourthBlockIdx]]
        ]
    }

}
