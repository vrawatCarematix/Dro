//
//  CalanderModel.swift
//  DROapp
//
//  Created by Carematix on 24/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class CalanderModel: NSObject {
    var date : Int?
    var sessionCount : Int?
    var sessionsArray = [SessionsModel]()

    override init(){}
    init(jsonObject : [String : Any]){
        date = jsonObject["date"] as? Int
        sessionCount = jsonObject["sessionCount"] as? Int
        if let  sessionArray = jsonObject["sessions"] as? [[String : Any]]{
            for sessionData in sessionArray{
                let session = SessionsModel(jsonObject: sessionData)
                sessionsArray.append(session)
            }
        }
    }
}
