//
//  QuestionsModel.swift
//  Wellness
//
//  Created by Carematix on 25/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionsModel: NSObject {
    var id: Int?
    var questionType: String?
    var answerType: String?
    var text: String?
    var url: String?
    var helpText: String?
    var sequence: Int?
    var validationRulesArray = [ValidationModel]()
    var answerArray = [AnswersModel]()

    var required: Int?
    var surveyId: Int?
    var pageId: Int?


    override init(){}
    
    init( jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        questionType = jsonObject["questionType"] as? String
        answerType = jsonObject["answerType"] as? String
        text = jsonObject["text"] as? String
        url = jsonObject["url"] as? String
        
        if let urlString = url , let mediaUrl = URL(string:urlString) {
            let _ = CommonMethods.mediaUrl(url: mediaUrl)
        }
        helpText = jsonObject["helpText"] as? String
        sequence = jsonObject["sequence"] as? Int
        if let validationRulesDataArray = jsonObject["validationRules"] as? [[String :Any]]{
            for validationRulesData in validationRulesDataArray{
                let validationRules = ValidationModel(jsonObject: validationRulesData)
                validationRulesArray.append(validationRules)
            }
        }
        
        if let  choicesDataArray = jsonObject["choices"] as? [[String : Any]]{
            
            for choicesData in choicesDataArray{
                let choices = AnswersModel(jsonObject: choicesData)
                answerArray.append(choices)
            }
        }
        required = jsonObject["required"] as? Int
        surveyId = jsonObject["surveyId"] as? Int
        pageId = jsonObject["pageId"] as? Int
    }
}
