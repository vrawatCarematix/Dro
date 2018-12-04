//
//  MessageModel.swift
//  DROapp
//
//  Created by Carematix on 22/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var createTime : Int?
    var id : Int?
    var isStarred : Int?
    var messageTile : String?
    var readStatus : String?
    var textMessage : String?
    var senderName : String?
    var userId : Int?
    var isUploaded = 1

    override init(){}
    init(jsonObject : [String : Any]){
        createTime = jsonObject["createTime"] as? Int
        id = jsonObject["id"] as? Int
        isStarred = jsonObject["isStarred"] as? Int
        messageTile = jsonObject["messageTile"] as? String
        readStatus = jsonObject["readStatus"] as? String
        senderName = jsonObject["senderName"] as? String

        textMessage = jsonObject["textMessage"] as? String
        userId = jsonObject["userId"] as? Int

    }
}
