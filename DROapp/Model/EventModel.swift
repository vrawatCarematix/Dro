//
//  EventModel.swift
//  DROapp
//
//  Created by Carematix on 22/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
class EventModel: NSObject {
    var time : Int?
    var event : String?
    var msg : String?
    
    override init(){}
    init(jsonObject : [String : Any]){
        time = jsonObject["time"] as? Int
        event = jsonObject["event"] as? String
        msg = jsonObject["msg"] as? String
    }
}
