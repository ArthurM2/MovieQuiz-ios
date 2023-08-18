import UIKit

protocol StatisticService {
    var averageAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImpl: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var total: Int {
        get { userDefaults.integer(forKey: Keys.total.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.total.rawValue) }
    }
    
    var correct: Int {
        get { userDefaults.integer(forKey: Keys.correct.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.correct.rawValue) }
    }
    
    var averageAccuracy: Double {
        get {
            return total > 0 ? Double(correct) / Double(total) * 100 : 0
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGameRecord = GameRecord(correct: count, total: amount, date: Date())
        if currentGameRecord > bestGame {
            bestGame = currentGameRecord
        }
    
        correct += count
        total += amount
        gamesCount += 1
    }
}
