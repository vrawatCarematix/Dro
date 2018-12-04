//
//  SurveySessionModel.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SurveySessionModel: NSObject {

    //MARK: Properties
    
    var progressStatus: String?
    var endTime: Double?
    var percentageCompleted: Double?
    var scheduleType: String?
    var declined: Bool?
    var scheduleDate: Double?
    var scheduleSessionId: Double?
    var startTime: Double?
    var userSurveySessionId: Double?

    override init(){}
    
    init(jsonObject : [String : Any] ){
        progressStatus = jsonObject["progressStatus"] as? String
        endTime = jsonObject["endTime"] as? Double
        percentageCompleted = jsonObject["percentageCompleted"] as? Double
        scheduleType = jsonObject["scheduleType"] as? String
        declined = jsonObject["declined"] as? Bool
        scheduleDate = jsonObject["scheduleDate"] as? Double
        scheduleSessionId = jsonObject["scheduleSessionId"] as? Double
        startTime = jsonObject["startTime"] as? Double
        userSurveySessionId = jsonObject["userSurveySessionId"] as? Double
    }
    
  
    
    
}
