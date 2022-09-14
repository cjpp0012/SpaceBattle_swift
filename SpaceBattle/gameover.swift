import SpriteKit
import GameKit


class GameOver: SKScene {
  init(size: CGSize, score:Int) {
    super.init(size: size)
    backgroundColor = SKColor.black

    let message = "Game Over"
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 47
    label.fontColor = SKColor.red
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    let score_msg = "Your Score: \(score)"
    let s_m_l = SKLabelNode(fontNamed: "Chalkduster")
    s_m_l.text = score_msg
    s_m_l.fontSize = 25
    s_m_l.fontColor = SKColor.white
    s_m_l.position = CGPoint(x: size.width/2, y: size.height/3)
    addChild(s_m_l)
    
    run(SKAction.sequence([
      SKAction.wait(forDuration: 2.5),
      SKAction.run() { [weak self] in
        
        guard let `self` = self else { return }
        let restart = SKTransition.doorsOpenVertical(withDuration: 1)
        
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:restart)
      }
      ]))
   }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
