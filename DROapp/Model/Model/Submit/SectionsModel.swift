//
//  SectionsModel.swift
//  DROapp
//
//  Created by Carematix on 03/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SectionsModel: NSObject {
    var id: Int?
    var text: String?
    var mediaType: String?
    var url: String?
    var sequence: Int?
    var questionArray = [QuestionsModel]()

    override init(){}
    
    init( jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        text = jsonObject["text"] as? String
        sequence = jsonObject["sequence"] as? Int
        if let questionsDataArray = jsonObject["questions"] as? [[String : Any]]{
            for questionsData in questionsDataArray{
                let question = QuestionsModel(jsonObject: questionsData)
                questionArray.append(question)
            }
        }
    }
}
