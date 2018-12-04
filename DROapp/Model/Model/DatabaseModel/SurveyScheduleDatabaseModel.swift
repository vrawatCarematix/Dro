//
//  SurveyScheduleDatabaseModel.swift
//  DROapp
//
//  Created by Carematix on 28/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SurveyScheduleDatabaseModel: NSObject {
    var surveyDate: Int?
    var sessionCount: Int?
    var startTime: Int?
    var endTime: Int?
    var surveyID: Int?
    var programSurveyId: Int?
    var isPriority: Int?
    var surveyName: String?
    var surveySessionId: Int?
    var percentageCompleted: Double?
    var progressStatus: String?
    var timeSpent: Int?
    var isDeclined: Int?
    var surveyLanguage : String?
    var scheduleType = "SCHEDULED"
    var actualEndTime: Int?

    override init(){
        if let languageCode = UserDefaults.standard.value(forKey: "selectedLanguage") as? String , languageCode != "" {
            surveyLanguage = languageCode
        }else{
            surveyLanguage = "EN"
        }
    }
    
    init(jsonObject : [String : Any] ){
        surveyDate = jsonObject["surveyDate"] as? Int
        sessionCount = jsonObject["sessionCount"] as? Int
        startTime = jsonObject["startTime"] as? Int
        actualEndTime = jsonObject["actualEndTime"] as? Int

        endTime = jsonObject["endTime"] as? Int
        programSurveyId = jsonObject["programSurveyId"] as? Int
        surveyID = jsonObject["surveyID"] as? Int
        isPriority = jsonObject["isPriority"] as? Int
        surveyName = jsonObject["surveyName"] as? String
        surveySessionId = jsonObject["surveySessionId"] as? Int
        percentageCompleted = jsonObject["percentageCompleted"] as? Double
        progressStatus = jsonObject["progressStatus"] as? String
        timeSpent = jsonObject["timeSpent"] as? Int
        isDeclined = jsonObject["isDeclined"] as? Int
         if let languageCode = UserDefaults.standard.value(forKey: "selectedLanguage") as? String , languageCode != "" {
            surveyLanguage = languageCode
         }else{
            surveyLanguage = "EN"
        }
        
    }
    
}
