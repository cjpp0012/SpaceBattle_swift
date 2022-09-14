//
//  GameScene.swift
//  GroupGame
//
//  Created by Ryan Frederick on 11/9/21.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case enemy = 8
    case finish = 16
    case bullet = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: GameViewController?
    var scoreboard: Scoreboard!
    var isGameOver = false
    var character: SKSpriteNode?
    let player = SKSpriteNode(imageNamed: "playerTemp")
    let hpBar = SKSpriteNode(imageNamed: "hp100")
    var hp : Int = 3
    var timer = Timer()
    var contactQueue = [SKPhysicsContact]()
    let laserSound = SKAction.playSoundFileNamed("lasersound", waitForCompletion: false)
    let killSound = SKAction.playSoundFileNamed("killsound", waitForCompletion: false)
    let playerdieSound = SKAction.playSoundFileNamed("whoosh", waitForCompletion: false)
    var enemyList :[SKSpriteNode] = [SKSpriteNode]()
    var blankSpaces :[CGPoint] = [CGPoint]()
    
    let lowerJS = SKSpriteNode(imageNamed: "jSubstrate")
    let upperJS = SKSpriteNode(imageNamed: "jStick")
    var moving = false
    var lastLocation : CGPoint!
    
    
    override func didMove(to view: SKView) {
        scoreboard = Scoreboard()
        
        let background = SKSpriteNode(imageNamed: "whiteBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        lowerJS.position = CGPoint(x: self.size.width / 8, y: self.size.height / 10)
        lowerJS.zPosition = 10
        lowerJS.setScale(0.8)
        lowerJS.name = "lower"
        self.addChild(lowerJS)
        
        upperJS.position = CGPoint(x: self.size.width / 8, y: self.size.height / 10)
        upperJS.zPosition = 11
        upperJS.name = "upper"
        self.addChild(upperJS)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.setScale(0.06)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player.zPosition = 2
        player.name = "player"
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        self.addChild(player)
        character = player
        
        hpBar.setScale(0.3)
        hpBar.xScale = 0.8
        hpBar.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        hpBar.zPosition = 5
        self.addChild(hpBar)
        

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            self.shoot()
            for i in self.enemyList {
                enemyShoot(enemyNode: i)
            }
        })
        

        loadLevel()
        physicsWorld.contactDelegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //timeSpawnBullet = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        //shoot()
        //gameOver(size: self.size, score: self.scoreboard.getScore())
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(moving) {
            let vel = CGVector(dx: lastLocation.x - lowerJS.position.x, dy: lastLocation.y - lowerJS.position.y)
            let angle = atan2(vel.dy, vel.dx)
            let length = lowerJS.frame.size.height / 2
            
            //print(angle)
            let xDist = sin(angle - 1.57) * length
            let yDist = -cos(angle - 1.57) * length
            player.zRotation = angle - 1.57
            player.position = CGPoint(x: player.position.x + (upperJS.position.x - lowerJS.position.x) / 5, y: player.position.y + (upperJS.position.y - lowerJS.position.y) / 5)
            
            if (lowerJS.frame.contains(lastLocation)) {
                upperJS.position = lastLocation
            } else {
                upperJS.position = CGPoint(x: lowerJS.position.x - xDist, y: lowerJS.position.y - yDist)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            lastLocation = touch.location(in: self)
        }
        moving = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        upperJS.position = lowerJS.position
        moving = false
    }
    
    // public var velocity: CGPoint {
        //let diff = handle.diameter * 0.02
        //return CGPoint(x: handle.position.x / diff, y: handle.position.y / diff)
    //}
    
    //public var angular: CGFloat {
      //  let velocity = self.velocity
        //return -atan2(velocity.x, velocity.y)
    //}
    
    @objc func shoot() {
        if (tripleShot) {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            let bulletTwo = SKSpriteNode(imageNamed: "bullet")
            let bulletThree = SKSpriteNode(imageNamed: "bullet")
            if (biggerLaser) {
                bullet.setScale(1.2)
                bulletTwo.setScale(1.2)
                bulletThree.setScale(1.2)
            } else {
                bullet.setScale(1)
                bulletTwo.setScale(1)
                bulletThree.setScale(1)
            }
            
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.zRotation = player.zRotation
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = CollisionTypes.bullet.rawValue
            bullet.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
            bullet.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.name = "playerbullet"
            
            bulletTwo.position = player.position
            bulletTwo.zPosition = 1
            bulletTwo.zRotation = player.zRotation
            bulletTwo.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
            bulletTwo.physicsBody?.isDynamic = true
            bulletTwo.physicsBody?.categoryBitMask = CollisionTypes.bullet.rawValue
            bulletTwo.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
            bulletTwo.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
            bulletTwo.physicsBody?.usesPreciseCollisionDetection = true
            bulletTwo.name = "playerbullet"
            
            bulletThree.position = player.position
            bulletThree.zPosition = 1
            bulletThree.zRotation = player.zRotation
            bulletThree.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
            bulletThree.physicsBody?.isDynamic = true
            bulletThree.physicsBody?.categoryBitMask = CollisionTypes.bullet.rawValue
            bulletThree.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
            bulletThree.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
            bulletThree.physicsBody?.usesPreciseCollisionDetection = true
            bulletThree.name = "playerbullet"
            
            
            self.addChild(bullet)
            self.addChild(bulletTwo)
            self.addChild(bulletThree)
            
            let distance = 200
            let bulletMovement = SKAction.move(to: CGPoint(x: bullet.position.x + CGFloat(distance) * -sin(bullet.zRotation), y: bullet.position.y + CGFloat(distance) * cos(bullet.zRotation)), duration: 1)
            
            let bulletMovementTwo = SKAction.move(to: CGPoint(x: bullet.position.x + CGFloat(distance) * -sin(45 + bullet.zRotation), y: bullet.position.y + CGFloat(distance) * cos(45 + bullet.zRotation)), duration: 1)
            
            let bulletMovementThree = SKAction.move(to: CGPoint(x: bullet.position.x + CGFloat(distance) * -sin(-45 + bullet.zRotation), y: bullet.position.y + CGFloat(distance) * cos(-45 + bullet.zRotation)), duration: 1)
            
            let bulletDelete = SKAction.removeFromParent()
            let sequence = SKAction.sequence([bulletMovement, bulletDelete])
            let sequenceTwo = SKAction.sequence([bulletMovementTwo, bulletDelete])
            let sequenceThree = SKAction.sequence([bulletMovementThree, bulletDelete])
            run(laserSound)
            bullet.run(sequence)
            bulletTwo.run(sequenceTwo)
            bulletThree.run(sequenceThree)
            
        } else {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            if (biggerLaser) {
                bullet.setScale(1.2)
            } else {
                bullet.setScale(1)
            }
            
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.zRotation = player.zRotation
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = CollisionTypes.bullet.rawValue
            bullet.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
            bullet.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.name = "playerbullet"
            self.addChild(bullet)
            let distance = 200
            let bulletMovement = SKAction.move(to: CGPoint(x: bullet.position.x + CGFloat(distance) * -sin(bullet.zRotation), y: bullet.position.y + CGFloat(distance) * cos(bullet.zRotation)), duration: 1)
            let bulletDelete = SKAction.removeFromParent()
            let sequence = SKAction.sequence([bulletMovement, bulletDelete])
            run(laserSound)
            bullet.run(sequence)
        }
        
    }
    
    @objc func enemyShoot(enemyNode: SKSpriteNode) {
        let bullet = SKSpriteNode(imageNamed: "vortex")
        let randomDegree = CGFloat.random(in: 0.0..<360.0)
        bullet.setScale(1)
        bullet.position = enemyNode.position
        bullet.zPosition = 1
        bullet.zRotation = randomDegree
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 3)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = CollisionTypes.bullet.rawValue
        bullet.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        bullet.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.name = "enemybullet"
        self.addChild(bullet)
        let distance = 250

        let bulletMovement = SKAction.move(to: CGPoint(x: bullet.position.x + CGFloat(distance) * -sin(bullet.zRotation), y: bullet.position.y + CGFloat(distance) * cos(bullet.zRotation)), duration: 3)
        let bulletDelete = SKAction.removeFromParent()
        let sequence = SKAction.sequence([bulletMovement, bulletDelete])

        bullet.run(sequence)
    }
    func spawnEnemy() {
        let randomI = Int.random(in: 0..<self.blankSpaces.count - 1)
        let node = SKSpriteNode(imageNamed: "bahamut")
        
        node.name = "enemy"
        node.position = CGPoint(x: blankSpaces[randomI].x, y: blankSpaces[randomI].y)
        blankSpaces.remove(at: randomI)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.zPosition = 2
        node.physicsBody?.categoryBitMask = CollisionTypes.enemy.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.bullet.rawValue
        node.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
        addChild(node)
        enemyList.append(node)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var removei : Int = -1
        let enemyBody: SKPhysicsBody
        let bulletBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bulletBody = contact.bodyB
            enemyBody = contact.bodyA
        } else {
            bulletBody = contact.bodyA
            enemyBody = contact.bodyB
        }
        if (enemyBody.categoryBitMask & CollisionTypes.enemy.rawValue) != CollisionTypes.bullet.rawValue && (bulletBody.categoryBitMask & CollisionTypes.bullet.rawValue) != CollisionTypes.enemy.rawValue && enemyBody.node?.name == "enemy" && (bulletBody.node?.name == "playerbullet") {
            if bulletBody.node != nil {
                collisionElementsBullets(bulletNode: bulletBody.node as! SKSpriteNode)
                collisionElementsEnemies(enemyNode: enemyBody.node as! SKSpriteNode)
            
            spawnEnemy()
            for (i,x) in enemyList.enumerated() {
                if x == enemyBody.node {
                    removei = i
                }
            }
            if removei != -1 {
                enemyList.remove(at: removei)
            }
            
            run(killSound)
            scoreboard.addScore(score: 10)
            }
        } else if (enemyBody.node?.name == "wall") {
            if bulletBody.node != nil {
                collisionElementsBullets(bulletNode: bulletBody.node as! SKSpriteNode)
            }
        } else if enemyBody.node?.name == "player" && (bulletBody.node?.name == "enemybullet") {
            run(playerdieSound)
            hp = hp - 1
            
            if (extraHp) {
                if (hp < 0) {
                    gameOver(size:self.size, score: self.scoreboard.getScore())
                } else if (hp == 2){
                    hpBar.texture = SKTexture(imageNamed: "hp65")
                } else if (hp == 1) {
                    hpBar.texture = SKTexture(imageNamed: "hp30")
                } else if (hp == 0) {
                    hpBar.texture = SKTexture(imageNamed: "hp0")
                }
            } else {
                if (hp <= 0) {
                    gameOver(size:self.size, score: self.scoreboard.getScore())
                } else if (hp == 2){
                    hpBar.texture = SKTexture(imageNamed: "hp65")
                } else if (hp == 1) {
                    hpBar.texture = SKTexture(imageNamed: "hp30")
                }
            }
            
        }
    }
    func collisionElementsEnemies(enemyNode: SKSpriteNode) {
        enemyNode.removeFromParent()
    }
    func collisionElementsBullets(bulletNode: SKSpriteNode) {
        bulletNode.removeFromParent()
    }
    func loadLevel() {
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")

                for (row, line) in lines.reversed().enumerated() {
                    for (column, letter) in line.enumerated() {
                        let position = CGPoint(x: (43 * column) + 0, y: (43 * row) + 0)

                        if letter == "x" {
                            // load wall
                            let node = SKSpriteNode(imageNamed: "purpletile")
                            node.position = position
                            node.name = "wall"
                            node.zPosition = 2
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.bullet.rawValue
                            node.physicsBody?.isDynamic = false
                            addChild(node)
                        } else if letter == "v"  {
                            // load enemy
                            let node = SKSpriteNode(imageNamed: "bahamut")
                            node.name = "enemy"
                            node.position = position
//                            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false
                            node.zPosition = 2
                            node.physicsBody?.categoryBitMask = CollisionTypes.enemy.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.bullet.rawValue
                            node.physicsBody?.collisionBitMask = CollisionTypes.bullet.rawValue
                            addChild(node)
                            enemyList.append(node)
                        }
                        else if letter == " "  {
                            blankSpaces.append(position)
                        }
                    }
                }
            }
        }
    }
    
    

    func gameOver(size: CGSize , score:Int){
        isGameOver = true
        let reveal = SKTransition.doorsCloseVertical(withDuration: 1)
        let gameOverScene = Shop(size: size, score: score)
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
    
}
