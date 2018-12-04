//
//  ValidationModel.swift
//  DROapp
//
//  Created by Carematix on 04/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ValidationModel: NSObject {

    var id: Int?
    var type: String?
    var minLength: Int?
    var maxLength: Int?
    var minValue: Int?
    var maxValue: Int?
    var expression: String?
    var failureMessage: String?

    override init(){}
    
    init( jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        type = jsonObject["type"] as? String
        minLength = jsonObject["minLength"] as? Int
        maxLength = jsonObject["maxLength"] as? Int
        minValue = jsonObject["minValue"] as? Int
        maxValue = jsonObject["maxValue"] as? Int
        expression = jsonObject["expression"] as? String
        failureMessage = jsonObject["failureMessage"] as? String

    }
}
