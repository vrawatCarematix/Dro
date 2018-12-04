//
//  ProfileModel.swift
//  DROapp
//
//  Created by Carematix on 23/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    var fieldId : Int?
    var fieldType : String?
    var organizationFormFieldValueId : Int?
    var value : String?

    override init(){}
    init(jsonObject : [String : Any]){
        fieldId = jsonObject["fieldId"] as? Int
        fieldType = jsonObject["fieldType"] as? String
        organizationFormFieldValueId = jsonObject["organizationFormFieldValueId"] as? Int
        value = jsonObject["value"] as? String
    }
    
}
