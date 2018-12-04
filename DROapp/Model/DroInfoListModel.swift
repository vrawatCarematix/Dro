//
//  DroInfoListModel.swift
//  DROapp
//
//  Created by Carematix on 27/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DroInfoListModel: NSObject {
    var declined : Int?
    var timeSpent : Int?
    var name : String?
    var progressStatus : String?
    var percentageCompleted : Double?
    var scheduleType : String?
    var endTime : Int?
    override init(){}
    init(jsonObject : [String : Any]){
        declined = jsonObject["declined"] as? Int
        timeSpent = jsonObject["timeSpent"] as? Int
        name = jsonObject["name"] as? String
        progressStatus = jsonObject["progressStatus"] as? String
        percentageCompleted = jsonObject["percentageCompleted"] as? Double
        scheduleType = jsonObject["scheduleType"] as? String
        endTime = jsonObject["endTime"] as? Int
    }    
}
