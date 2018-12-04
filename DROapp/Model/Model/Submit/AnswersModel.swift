//
//  AnswersModel.swift
//  Wellness
//
//  Created by Carematix on 25/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class AnswersModel: NSObject {
    var id: Int?
    var text: String?
    var sequence : Int?
    var score : Int?
    var url : String?

    var surveyId : Int?
    var pageId : Int?

    var questionId : Int?
    var fileId : Int?

    override init(){}
    
    init(jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        text = jsonObject["text"] as? String
        sequence = jsonObject["sequence"] as? Int
        score = jsonObject["score"] as? Int
        url = jsonObject["url"] as? String
        if let urlString = url , let mediaUrl = URL(string:urlString) {
            let _ = CommonMethods.mediaUrl(url: mediaUrl)
            
        }
        surveyId = jsonObject["surveyId"] as? Int
        pageId = jsonObject["pageId"] as? Int
        questionId = jsonObject["questionId"] as? Int
        fileId = jsonObject["fileId"] as? Int

    }
}
