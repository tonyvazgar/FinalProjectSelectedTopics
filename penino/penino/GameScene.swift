//
//  GameScene.swift
//  penino
//
//  Created by Carlos Eduardo Castelán Vázquez on 11/22/18.
//  Copyright © 2018 Carlos Eduardo Castelán Vázquez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var nombre = "ficha"
    
    override func didMove(to view: SKView) {
        
    }
    
 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let location = touch.location(in: self)
            switch location.x{
            case -207 ... -140:
                print("Primera Columna")
                setFicha(divisor: -2.45)
            case -139 ... -71:
                print("Segunda Columna")
                setFicha(divisor: -4)
            case -70 ... -2:
                print("Tercera Columna")
                setFicha(divisor: -11.6)
            case -1 ... 67:
                print("Cuarta Columna")
                setFicha(divisor: 11.6)
            case 68 ... 136:
                print("Quinta Columna")
                setFicha(divisor: 4)
            case 137 ... 207:
                print("Sexto Columna")
                setFicha(divisor: 2.45)
            default:
                print("Columna Vacia")
            }
        }
    }
    
    func setFicha(divisor: CGFloat){
        let ficha = SKSpriteNode(imageNamed: nombre)
        ficha.position.x = self.size.width/divisor
        ficha.position.y = self.size.height/2
        ficha.zPosition = 0
        let size = CGSize(width: 66, height: 77)
        ficha.size = size
        ficha.physicsBody = SKPhysicsBody(rectangleOf: size)
        ficha.physicsBody?.affectedByGravity = true
        ficha.physicsBody?.allowsRotation = false
        addChild(ficha)
        nombre = (nombre == "ficha" ? "fichaA" : "ficha")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
