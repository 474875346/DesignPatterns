//
//  MementoPatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/5.
//  Copyright © 2018年 PengXiang. All rights reserved.
//备忘模式

import UIKit

class MementoPatternViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //第一个玩家开始玩游戏，赚了100分，进入下一等级；然后把这个玩家的数据以player1作为key保存。
        let game1 = Game()
        game1.earnSomePoints()
        game1.enterNextLebrl()
        
        let gameSystem = GameSystem()
        try! gameSystem.save(game1, for: "player1")

        
        //第二个玩家开始玩游戏
        let game2 = Game()
        print("第二个玩家的分数: \(game2.state.score)") // 第二个玩家的分数: 0
        //如果这时第二个玩家不想玩了，第一个玩家接着玩，恢复第一个玩家的数据
        let restoredGame1 = try! gameSystem.loadGame(for: "player1")
        print("第一个玩家的分数: \(restoredGame1?.state.score ?? Int())")
        // 第一个玩家的分数: 100
    }
}
class Game: Codable {
    class State: Codable {
        var score = 0
        var level = 1
    }
    var state = State()
    
    func enterNextLebrl() {
        state.level += 1
    }
    
    func earnSomePoints() {
        state.score += 100
    }
}
class GameSystem {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(_ game: Game, for player: String) throws {
        let data = try encoder.encode(game)
        UserDefaults.standard.set(data, forKey: player)
    }
    
    func loadGame(for player: String) throws -> Game? {
        guard let data = UserDefaults.standard.data(forKey: player),
            let game = try? decoder.decode(Game.self, from: data) else {
                return nil
        }
        return game
    }
}
