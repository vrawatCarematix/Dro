//
//  TimelineModel.swift
//  DROapp
//
//  Created by Carematix on 22/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TimelineModel: NSObject {
    var date : Int?
    var eventArray = [EventModel]()
    var eventArrayJson = [[String : Any]]()


    override init(){}
    init(jsonObject : [String : Any]){
        date = jsonObject["date"] as? Int
        if let  events = jsonObject["events"] as? [[String : Any]]{
            eventArrayJson = events
            for eventData in events{
                let event = EventModel(jsonObject: eventData)
                eventArray.append(event)
            }
        }
    }
}
