import SpriteKit
import GameKit

var biggerLaser = false
var tripleShot = false
var extraHp = false
class Shop: SKScene, ObservableObject {
    var starfield: SKEmitterNode!
    var points : Int!
    var scoreLabel : SKLabelNode!
    var labelLaser : SKLabelNode!
    var labelTripleShot : SKLabelNode!
    var labelExtraHp : SKLabelNode!
    
  init(size: CGSize, score:Int) {
    super.init(size: size)
    points = score
    let score_msg = "Your Score: \(score)"
    
    var buttonOne: SKSpriteNode
    var buttonTwo: SKSpriteNode
    var buttonThree: SKSpriteNode
    var playButton: SKSpriteNode
    
    let message = "Power Ups"
    let label = SKLabelNode(fontNamed: "Starfield")
    
    labelLaser = SKLabelNode(fontNamed: "Starfield")
    let msgLaser = "Bigger Laser Size"
    
    labelTripleShot = SKLabelNode(fontNamed: "Starfield")
    let msgTripleShot = "Triple Shot"
    
    labelExtraHp = SKLabelNode(fontNamed: "Starfield")
    let msgExtraHp = "Extra Life"
    scoreLabel = SKLabelNode(fontNamed: "Starfield")
    
    let labelPlay = SKLabelNode(fontNamed: "Starfield")
    let msgPlay = "Play Again"
    
    backgroundColor = SKColor.black
    
    label.text = message
    label.fontSize = 45
    label.fontColor = SKColor.cyan
    label.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
    addChild(label)
    
    scoreLabel.text = score_msg
    scoreLabel.fontSize = 45
    scoreLabel.fontColor = SKColor.cyan
    scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.85)
    addChild(scoreLabel)
    
    labelLaser.text = msgLaser
    labelLaser.fontSize = 30
    labelLaser.fontColor = SKColor.cyan
    labelLaser.position = CGPoint(x: size.width/2, y: size.height * 0.70)
    addChild(labelLaser)
    
    labelTripleShot.text = msgTripleShot
    labelTripleShot.fontSize = 30
    labelTripleShot.fontColor = SKColor.cyan
    labelTripleShot.position = CGPoint(x: size.width/2, y: size.height * 0.55)
    addChild(labelTripleShot)
    
    labelExtraHp.text = msgExtraHp
    labelExtraHp.fontSize = 30
    labelExtraHp.fontColor = SKColor.cyan
    labelExtraHp.position = CGPoint(x: size.width/2, y: size.height * 0.4)
    addChild(labelExtraHp)
    
    labelPlay.text = msgPlay
    labelPlay.fontSize = 30
    labelPlay.fontColor = SKColor.cyan
    labelPlay.position = CGPoint(x: size.width/2, y: size.height * 0.25)
    addChild(labelPlay)
    
    buttonOne = SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width / 3, height: self.size.height/20))
    buttonOne.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.65);
    buttonOne.zPosition = 10
    buttonOne.name = "one"
    let textOne = SKLabelNode(text: "5 Score")
    textOne.fontColor = .black
    textOne.name = "one"
    textOne.fontSize = 20
    textOne.verticalAlignmentMode = .center
    buttonOne.addChild(textOne)
    addChild(buttonOne)
    
    buttonTwo = SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width / 3, height: self.size.height/20))
    buttonTwo.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.5);
    buttonTwo.zPosition = 10
    buttonTwo.name = "two"
    let textTwo = SKLabelNode(text: "10 Score")
    textTwo.fontColor = .black
    textTwo.name = "two"
    textTwo.fontSize = 20
    textTwo.verticalAlignmentMode = .center
    buttonTwo.addChild(textTwo)
    addChild(buttonTwo)
    
    buttonThree = SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width / 3, height: self.size.height/20))
    buttonThree.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.35);
    buttonThree.zPosition = 10
    buttonThree.name = "three"
    let textThree = SKLabelNode(text: "15 Score")
    textThree.fontColor = .black
    textThree.name = "three"
    textThree.fontSize = 20
    textThree.verticalAlignmentMode = .center
    buttonThree.addChild(textThree)
    addChild(buttonThree)
    
    playButton = SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width / 3, height: self.size.height/20))
    playButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2);
    playButton.zPosition = 10
    playButton.name = "play"
    let textPlay = SKLabelNode(text: "Start")
    textPlay.fontColor = .black
    textPlay.name = "play"
    textPlay.fontSize = 20
    textPlay.verticalAlignmentMode = .center
    playButton.addChild(textPlay)
    addChild(playButton)    
   }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touched = self.atPoint(touch.location(in: self))
            guard let name = touched.name else {
                return;
            }
            if name == "play" {
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = scaleMode
                let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
                view?.presentScene(gameScene, transition: reveal)
            }
            if (name == "one" && points >= 5 && labelLaser.text != "Bought") {
                biggerLaser = true
                points -= 5
                scoreLabel.text = "Your Score: \(points ?? 0)"
                labelLaser.text = "Bought"
            }
            if (name == "two" && points >= 10 && labelTripleShot.text != "Bought") {
                tripleShot = true
                points -= 10
                scoreLabel.text = "Your Score: \(points ?? 0)"
                labelTripleShot.text = "Bought"
            }
            if (name == "three" && points >= 15 && labelExtraHp.text != "Bought") {
                extraHp = true
                points -= 15
                scoreLabel.text = "Your Score: \(points ?? 0)"
                labelExtraHp.text = "Bought"
            }
        }
    }
    //    var BGmusic = AVAudioPlayer()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x:frame.size.width/2, y:frame.size.height)
        starfield.targetNode = self.scene
        starfield.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
        self.addChild(starfield)
    }
    
    
    class Button {
        var button: SKSpriteNode
        
        init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, label: String, id: String) {
            button = SKSpriteNode(color: UIColor.white, size: CGSize(width: width, height: height/2))
            button.position = CGPoint(x: x, y: y);
            button.zPosition = 10
            button.name = id
            addText(label: label, id: id)
        }
        
        func addText(label: String, id: String) {
            let text = SKLabelNode(text: label)
            text.fontColor = .black
            text.name = id
            text.fontSize = 30
            text.verticalAlignmentMode = .center
            button.addChild(text)
        }
        
        func addToSelf(parent: SKNode) -> SKSpriteNode {
            parent.addChild(button)
            return button
        }
        
        func addTo(parent: SKNode) {
            parent.addChild(button)
        }
    }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
