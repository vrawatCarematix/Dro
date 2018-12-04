//
//  UserSurveySessionModel.swift
//  DROapp
//
//  Created by Carematix on 23/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class UserSurveySessionModel: NSObject {
    var programSurveyId: Int?
    var surveyName: String?
    var isRetakeAllowed: Int?
    var isImportant: Int?
    var isUnscheduled: Int?
    var isAutoSave: Int?
    var surveySessionInfo = SurveySessionInfoModel()
    
    
    override init(){}
    
    init(jsonObject : [String : Any] ){
        programSurveyId = jsonObject["programSurveyId"] as? Int
        surveyName = jsonObject["surveyName"] as? String
        isRetakeAllowed = jsonObject["isRetakeAllowed"] as? Int
        isImportant = jsonObject["isImportant"] as? Int
        isUnscheduled = jsonObject["isUnscheduled"] as? Int
        isAutoSave = jsonObject["isAutoSave"] as? Int
        if let surveySessionInfoData = jsonObject["surveySessionInfo"] as? [String: Any]{
            surveySessionInfo = SurveySessionInfoModel(jsonObject: surveySessionInfoData)
        }
        
    }
}
