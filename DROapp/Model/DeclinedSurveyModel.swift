//
//  DeclinedSurveyModel.swift
//  DROapp
//
//  Created by Carematix on 01/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DeclinedSurveyModel: NSObject {

    var declineReasonId : Int?
    var declineTime : Int?
    var userSurveySessionId : Int?
    var isUploaded = 0

    override init(){}
    init(jsonObject : [String : Any]){
        declineReasonId = jsonObject["declineReasonId"] as? Int
        declineTime = jsonObject["declineReasonId"] as? Int
        userSurveySessionId = jsonObject["userSurveySessionId"] as? Int
    }
}
