//
//  UserAnswerLogs.swift
//  DROapp
//
//  Created by Carematix on 03/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class UserAnswerLogs: NSObject {

    var id: Int?
    var questionId: Int?
    var choiceId: Int?
    var answerFreeText: String?
    var score: Int?
    var fileId: Int?

    override init(){}
    init(jsonObject : [String : Any]){
        id = jsonObject["id"] as? Int
        questionId = jsonObject["questionId"] as? Int
        choiceId = jsonObject["choiceId"] as? Int
        answerFreeText = jsonObject["answerFreeText"] as? String
        score = jsonObject["score"] as? Int
        fileId = jsonObject["fileId"] as? Int
    }
    
    func getDict() -> [String : Any] {
        var dict = [String : Any]()
        if let idString = id {
            dict["id" ] = idString
        }else{
            dict["id" ] = 0
        }
        if let questionIdString = questionId {
            dict["questionId" ] = questionIdString
        }else{
            dict["questionId" ] = 0
        }
        
        if let id = choiceId {
            dict["choiceId"] = id
        }else{
            dict["choiceId" ] = 0
        }
        if let id = answerFreeText {
            dict["answerFreeText" ] = id
        }else{
            dict["answerFreeText" ] = ""
        }
        if let id = score {
            dict["score" ] = id
        }else{
            dict["score" ] = 0
        }
        if let id = fileId {
            dict["fileId" ] = id
        }else{
            dict["fileId"] = 0
        }
        return dict
    }
    
}
