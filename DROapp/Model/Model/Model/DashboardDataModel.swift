//
//  DRODataModel.swift
//  DRO
//
//  Created by Carematix on 03/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DashboardDataModel: NSObject {
    
    //MARK: Properties
    
    var isAutoSave: Bool?
    var isImportant: Bool?
    var isRetakeAllowed: Bool?
    var isUnscheduled: Bool?
    var programSurveyId: Int?
    var surveyName: String?
    var surveySessionModel: SurveySessionModel?
    
    override init(){}

    init(jsonObject : [String : Any] ){
        
        isAutoSave = jsonObject["isAutoSave"] as? Bool
        isImportant = jsonObject["isImportant"] as? Bool
        isRetakeAllowed = jsonObject["isRetakeAllowed"] as? Bool
        isUnscheduled = jsonObject["isUnscheduled"] as? Bool
        programSurveyId = jsonObject["programSurveyId"] as? Int
        surveyName = jsonObject["surveyName"] as? String
        if let data = jsonObject["surveySessionInfo"] as? [String : Any] {
            surveySessionModel = SurveySessionModel(jsonObject: data)
        }
    }
}
