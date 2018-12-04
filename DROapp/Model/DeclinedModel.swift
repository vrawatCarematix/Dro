//
//  DeclinedModel.swift
//  DROapp
//
//  Created by Carematix on 01/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DeclinedModel: NSObject {
    var declineReasonId : Int?
    var declineReason : String?
    override init(){}
    init(jsonObject : [String : Any]){
        declineReasonId = jsonObject["declineReasonId"] as? Int
        declineReason = jsonObject["declineReason"] as? String
    }
    
}
