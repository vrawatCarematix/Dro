//
//  MediaModel.swift
//  DROapp
//
//  Created by Carematix on 12/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class MediaModel: NSObject {

    var name : String?
    var sessionScheduleId : Int?
    var questionId : Int?
    var pageId : Int?
    var answer : Int?
    var endTime : Int?

    var isUploaded = 0

    override init(){}
    init(jsonObject : [String : Any]){
        name = jsonObject["name"] as? String
        sessionScheduleId = jsonObject["sessionScheduleId"] as? Int
        questionId = jsonObject["questionId"] as? Int
        pageId = jsonObject["pageId"] as? Int
        answer = jsonObject["answer"] as? Int
        endTime = jsonObject["endTime"] as? Int

    }
}
