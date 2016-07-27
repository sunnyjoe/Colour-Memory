//
//  DataContainer.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class UserScore: NSObject {
    var name = ""
    var score : Int = 0
    
    convenience init(theName : String, score : Int) {
        self.init()
        self.name = theName
        self.score = score
    }
    
    override init() {
        super.init()
    }
}

private let LocalScoreTable = TableWith("LocalScoreTable", type: UserScore.self, primaryKey: nil, dbName: "LocalScoreTable")

class DataContainer: NSObject {
    static let sharedIntance = DataContainer()
    
    func storeScore(score : Int, name : String){
        let one = UserScore(theName: name, score: score)
        LocalScoreTable.save(one)
    }
    
    func getHighScores(handler : ([UserScore]) -> Void, maxNumber : Int){
        let wrapper = {(users : [UserScore]) -> Void in
            var nusers = users.sort({ $0.score > $1.score })
            
            if nusers.count <= maxNumber {
                handler(nusers)
            }else{
                let ret : [UserScore] = Array(nusers[0...maxNumber])
                handler(ret)
            }
        }
        
        LocalScoreTable.queryAll(handler: wrapper)
    }
    
    func getRanking(score : Int, handler : (Int) -> Void){
        let wrapper = {(users : [UserScore]) -> Void in
            var rank = 0
            for one in users {
                if one.score >= score {
                    rank += 1
                }
            }
            handler(rank)
        }
        LocalScoreTable.queryAll(handler: wrapper)
    }
}