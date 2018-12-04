//
//  SessionsModel.swift
//  DROapp
//
//  Created by Carematix on 24/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SessionsModel: NSObject {
    var id : Int?
    var startTime : Int?
    var endTime : Int?
    var scheduleType : String?

    var survey = CalenderSurveyModel()
    var userSession = CalenderUserSessionModel()

    override init(){}
    init(jsonObject : [String : Any]){
        id = jsonObject["id"] as? Int
        startTime = jsonObject["startTime"] as? Int
        endTime = jsonObject["endTime"] as? Int
        scheduleType = jsonObject["scheduleType"] as? String

        if let  surveyData = jsonObject["survey"] as? [String : Any]{
            survey = CalenderSurveyModel(jsonObject: surveyData)
        }
        if let  userSessionData = jsonObject["userSession"] as? [String : Any]{
            userSession = CalenderUserSessionModel(jsonObject: userSessionData)
        }
    }
}
