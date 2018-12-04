//
//  SurveySessionInfoModel.swift
//  DROapp
//
//  Created by Carematix on 23/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SurveySessionInfoModel: NSObject {

    var progressStatus: String?
    var endTime: Int?
    var percentageCompleted: Double?
    var scheduleType: String?
    var declined: Int?
    var scheduleDate: Int?
    var scheduleSessionId: Int?
    var startTime: Int?
    var userSurveySessionId: Int?
    
    override init(){}
    
    init(jsonObject : [String : Any] ){
        progressStatus = jsonObject["progressStatus"] as? String
        endTime = jsonObject["endTime"] as? Int
        percentageCompleted = jsonObject["percentageCompleted"] as? Double
        scheduleType = jsonObject["scheduleType"] as? String
        declined = jsonObject["declined"] as? Int
        scheduleDate = jsonObject["scheduleDate"] as? Int
        scheduleSessionId = jsonObject["scheduleSessionId"] as? Int
        startTime = jsonObject["startTime"] as? Int
        userSurveySessionId = jsonObject["userSurveySessionId"] as? Int
    }
    
    
    
}
