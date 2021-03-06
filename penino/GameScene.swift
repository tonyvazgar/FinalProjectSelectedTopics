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
    let nombre = ["ficha", "fichaA", "fichaV", "fichaM"]
    let colores = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)]
    let labelPosition = [CGPoint(x: -103.5, y: 300), CGPoint(x: 103.5, y: 300), CGPoint(x: -103.5, y: -300), CGPoint(x: 103.5, y: -300)]
    var board = [[Int]]()
    var n_players = 0
    var playerTurn = 0
    var scores = [Int]()
    var v_board = [[SKSpriteNode]]()
    var isUpdating = 0
    var jugadoresL: [SKLabelNode]!
    
    override func didMove(to view: SKView) {
        resetGame(players: 2, board_size: (7, 6))
    }
    
    func resetGame(players: Int, board_size: (Int, Int)) {
        n_players = players
        _ = v_board.map { _ = $0.map { $0.removeFromParent()}}
        scores = Array.init(repeating: 0, count: n_players)
        playerTurn = 1
        board = Array.init(repeating: Array.init(repeating: 0, count: board_size.1), count: board_size.0)
        v_board = Array.init(repeating: [], count: board_size.1)
        jugadoresL = Array.init(repeating: SKLabelNode(), count: n_players)
        
        
        for i in 0..<n_players{
            let label = SKLabelNode(text: "P\(i + 1): \(scores[i])")
            label.position = labelPosition[i]
            label.fontSize = 40
            label.fontName = "Arial"
            label.fontColor = colores[i].withAlphaComponent((i == 0 ? 1.0 :0.5))
            label.zPosition = 2
            addChild(label)
            jugadoresL[i] = label
            
        }

    }
    
 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isUpdating > 0 { return }
        if v_board.allSatisfy({$0.count == board.count}) {
            return
        }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            switch location.x{
            case -207 ... -140:
                if !moveIsValid(col: 0) { return }
                makeMove(col: 0, ficha: setFicha(divisor: -2.45))
            case -139 ... -71:
                if !moveIsValid(col: 1) { return }
                makeMove(col: 1, ficha: setFicha(divisor: -4))
            case -70 ... -2:
                if !moveIsValid(col: 2) { return }
                makeMove(col: 2, ficha: setFicha(divisor: -11.6))
            case -1 ... 67:
                if !moveIsValid(col: 3) { return }
                makeMove(col: 3, ficha: setFicha(divisor: 11.6))
            case 68 ... 136:
                if !moveIsValid(col: 4) { return }
                makeMove(col: 4, ficha: setFicha(divisor: 4))
            case 137 ... 207:
                if !moveIsValid(col: 5) { return }
                makeMove(col: 5, ficha: setFicha(divisor: 2.45))
            default:
                return
            }
            if v_board.allSatisfy({$0.count == board.count}) || scores.contains(10){
                gameOver()
                return
            }
            makeCombo()
            for i in 0..<jugadoresL.count {
                jugadoresL[i].text = "\(jugadoresL[i].text!.components(separatedBy: " ")[0]) \(scores[i])"
            }
            isUpdating += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.jugadoresL[self.playerTurn-1].fontColor = self.jugadoresL[self.playerTurn-1].fontColor?.withAlphaComponent(0.5)
                self.playerTurn = (self.playerTurn%self.n_players) + 1
                self.jugadoresL[self.playerTurn-1].fontColor = self.jugadoresL[self.playerTurn-1].fontColor?.withAlphaComponent(1)
                self.isUpdating -= 1
            })
            /*jugadoresL[playerTurn-1].fontColor = jugadoresL[playerTurn-1].fontColor?.withAlphaComponent(0.5)
            playerTurn = (playerTurn%n_players) + 1
             jugadoresL[playerTurn-1].fontColor = jugadoresL[playerTurn-1].fontColor?.withAlphaComponent(1)*/
            
            
        }
    }

    
    func setFicha(divisor: CGFloat) -> SKSpriteNode{
        let ficha = SKSpriteNode(imageNamed: nombre[playerTurn-1])
        ficha.position.x = self.size.width/divisor
        ficha.position.y = self.size.height/2
        ficha.zPosition = 0
        let size = CGSize(width: 66, height: 77)
        ficha.size = size
        ficha.physicsBody = SKPhysicsBody(rectangleOf: size)
        ficha.physicsBody?.affectedByGravity = true
        ficha.physicsBody?.allowsRotation = false
        addChild(ficha)
        //nombre = (nombre == "ficha" ? "fichaA" : "ficha")
        return ficha
    }
    
    func moveIsValid(col: Int) -> Bool{
        //return board[0][col] == 0
        return v_board[col].count < board.count
    }
    
    func makeMove(col: Int, ficha: SKSpriteNode) {
        v_board[col].append(ficha)
        for i in (0 ..< board.count).reversed() {
            if board[i][col] == 0 {
                board[i][col] = playerTurn
                break
            }
        }
    }
    
    func gameOver() {
        print("GameOver")
    }
    
    
    func updateBoard(pointsToRemove: [[(Int, Int)]], mult: Double) {
        // Copies the old board
        var old_board = board
        var v_update = [(Int, Int)]()
        // Removes the connects
        _ = pointsToRemove.map { _ = $0.map { old_board[$0.0][$0.1] = 0 } }
        // Clear board
        board = board.map {$0.map {$0 * 0}}
        //var intento = 0
        // Fall of numbers (copy elements to the actual board)
        for j in 0 ..< board[0].count {
            var last_n = board.count-1
            for i in (0 ..< board.count).reversed() {
                if old_board[i][j] == 0 && (board.count-1-i) < v_board[j].count {
                   
                    v_update.append((j, board.count-1-i))
                    waitToRemove(ficha: v_board[j][board.count-1-i], mult: mult)
                    continue
                }
                if old_board[i][j] != 0 {
                    board[last_n][j] = old_board[i][j]
                    last_n -= 1
                }
            }
        }
        _ = v_update.reversed().map { v_board[$0.0].remove(at: $0.1) }
    }
    
    func makeCombo() {
        var isTurnFinished = Array.init(repeating: false, count: n_players)
        var time : Double = 1.5
        
        while !isTurnFinished.allSatisfy({ $0 }) {
            repeat {
                let combo = searchConnected(board: board, player: playerTurn)
                isTurnFinished[playerTurn-1] = combo.isEmpty
                scores[playerTurn-1] += (combo.map { $0.count-3}).reduce(0, +)
                updateBoard(pointsToRemove: combo, mult: time)
                time += 1.0
            } while !isTurnFinished[playerTurn-1]
            
            var pointsToRemove = [[(Int, Int)]]()
            for player in 1 ... n_players {
                if(player == playerTurn) {continue}
                let points = searchConnected(board: board, player: player)
                pointsToRemove.append(contentsOf: points)
                isTurnFinished[player-1] = points.isEmpty
            }
            updateBoard(pointsToRemove: pointsToRemove, mult: time)
            time += 1.0
            
        }
    }
    
    func searchConnected(board: [[Int]], player: Int) -> [[(Int, Int)]] {
        var pointsOfPlayer = [[(Int, Int)]]()
        // Horizontal
        for i in 0 ..< board.count {
            var connect = [(Int, Int)]()
            for j in 0 ..< board[i].count {
                if j > board[i].count-4 && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if j == board[i].count - 1 && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        
        // Vertical
        for j in 0 ..< board[0].count {
            var connect = [(Int, Int)]()
            for i in 0 ..< board.count {
                if i > board.count-4 && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if i == board.count-1 && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        
        
        
        // Left-Right Top-Down Upper
        for row in 0 ..< board[0].count-3 {
            var connect = [(Int, Int)]()
            let ix = 0 ..< board[row].count-row
            let jx = row ..< board[row].count
            
            for (i, j) in zip(ix, jx)  {
                if j > board[i].count-4 && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if j == board[i].count-1 && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        // Left-Right Top-Down Bottom
        for row in 1 ..< board.count-3 {
            var connect = [(Int, Int)]()
            let ix = row ..< board.count
            let jx = 0 ..< board.count-row
            
            for (i, j) in zip(ix, jx)  {
                if i > board.count-4 && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if i == board.count-1 && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        
        // Left-Right Bottom-Up Top
        for row in 0 ..< board[0].count-3 {
            var connect = [(Int, Int)]()
            let ix = (0 ... board[row].count+row-3).reversed()
            let jx = 0 ... board[row].count+row-3
            
            for (i, j) in zip(ix, jx)  {
                if j > row && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if j == board[i].count-(3-row) && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        // Left-Right Bottom-Up Down
        for row in 0 ..< board[0].count-3 {
            var connect = [(Int, Int)]()
            let ix = (row+1 ..< board.count).reversed()
            let jx = row ..< board[row].count
            
            for (i, j) in zip(ix, jx)  {
                if j > board[i].count-4 && connect.isEmpty {
                    break;
                }
                if board[i][j] == player {
                    connect.append((i,j))
                    if j == board[i].count-1 && connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                } else {
                    if connect.count >= 4 {
                        pointsOfPlayer.append(connect)
                    }
                    connect.removeAll()
                }
            }
        }
        return pointsOfPlayer
    }
    

    func waitToRemove(ficha: SKSpriteNode, mult: Double) { //}, col: Int, row: Int) {
        let delay = DispatchTime.now() + mult
        isUpdating += 1
       
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.particleTexture = ficha.texture
            explosion.particleSize = CGSize(width: 20, height: 20)
            explosion.position = ficha.position
            explosion.zPosition = 1
            
            self.addChild(explosion)
            ficha.removeFromParent()
            DispatchQueue.main.asyncAfter(deadline: delay + 1.0, execute: {
                explosion.removeFromParent()
            })
            self.isUpdating -= 1
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
