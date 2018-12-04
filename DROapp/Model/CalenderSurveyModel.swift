//
//  CalenderSurveyModel.swift
//  DROapp
//
//  Created by Carematix on 24/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class CalenderSurveyModel: NSObject {
    var id : Int?
    var programSurveyId : Int?
    var isPriority : Int?
    var name : String?

    override init(){}
    init(jsonObject : [String : Any]){
        id = jsonObject["id"] as? Int
        programSurveyId = jsonObject["programSurveyId"] as? Int
        isPriority = jsonObject["isPriority"] as? Int
        name = jsonObject["name"] as? String
    }
}
