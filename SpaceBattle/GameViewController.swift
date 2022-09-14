import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = TitleScreen(size: CGSize(width: view.bounds.width, height: view.bounds.height))
        if let view = self.view as! SKView? {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
        }
    }
}
