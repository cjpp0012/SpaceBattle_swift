import SpriteKit
import GameKit

class Scoreboard {
    var score: Int = 0

    func addScore(score: Int) {
        self.score += score
    }

    func getScore() -> Int {
        return score
    }
}

