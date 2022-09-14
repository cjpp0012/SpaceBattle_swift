import SpriteKit
//import AVFoundation

class TitleScreen: SKScene {
    var starfield:SKEmitterNode!
    var viewController: GameViewController?
    //    var BGmusic = AVAudioPlayer()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x:frame.size.width/2, y:frame.size.height)
        starfield.targetNode = self.scene
        starfield.particlePositionRange = CGVector(dx: frame.size.width, dy: frame.size.height)
        self.addChild(starfield)
        
        Menu(size: size, title: "SpaceBattle", label: "Play", id: "play").addTo(parent: self)
        let player = SKSpriteNode(imageNamed: "playerTemp")
        player.setScale(0.06)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player.zPosition = 2
        self.addChild(player)
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
        }
    }
}


class Menu {
    var menu: SKNode
    
    init(size: CGSize, title: String, label: String, id: String) {
        let width = size.width
        let height = size.height
        self.menu = SKNode()
        menu.zPosition = 5
        Button(x: width / 2, y: height / 3, width: width / 3, height: height / 6, label: label, id: id).addTo(parent: menu)
        
        addTitle(title: title, position: CGPoint(x: width / 2, y: 3 * height / 5))
    }
    
    func addTitle(title: String, position: CGPoint) {
        let node = SKLabelNode(text: title)
        node.fontSize = 70
        node.color = UIColor.yellow
        node.position = position
        menu.addChild(node)
    }
    
    func addTo(parent: SKScene) {
        parent.addChild(menu)
    }
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

