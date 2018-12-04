//
//  CalenderUserSessionModel.swift
//  DROapp
//
//  Created by Carematix on 24/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class CalenderUserSessionModel: NSObject {
    var id : Int?
    var percentageCompleted : Double?
    var progressStatus : String?
    var timeSpent : Int?
    var isDeclined : Int?
    var endTime : Int?

    override init(){}
    init(jsonObject : [String : Any]){
        id = jsonObject["id"] as? Int
        percentageCompleted = jsonObject["percentageCompleted"] as? Double
        progressStatus = jsonObject["progressStatus"] as? String
        timeSpent = jsonObject["timeSpent"] as? Int
        isDeclined = jsonObject["isDeclined"] as? Int
        endTime = jsonObject["endTime"] as? Int

    }
}
