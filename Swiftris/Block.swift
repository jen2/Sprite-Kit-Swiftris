//
//  Block.swift
//  Swiftris
//
//  Created by Jennifer A Sipila on 1/27/17.
//  Copyright © 2017 Jennifer A Sipila. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, CustomStringConvertible {
    
    //Handling random colors
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    // Required with use of CustomStringConvertible, this return the spriteName of the color to describe the object.
    var description: String {
        return self.spriteName
    }
    
    // Returns a random color
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}

//This implements both protocols and Hashable allows us to store Block in Array2D
class Block: Hashable, CustomStringConvertible {
    
    // Constants
    let color: BlockColor
    
    // Properties that represent location of the block on the grid
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // Shortcut for recoving the sprite's file name.
    var spriteName: String {
        return color.spriteName
    }
    
    //
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // Required method for CustomStringConvertible protocol
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}


func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
    
    
}
