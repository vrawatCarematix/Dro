//
//  ConfigDatabaseModel.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ConfigDatabaseModel: NSObject {

    var name : String?
    var type : String?
    var lastVisitedDate : String?
    
    var fieldType : String?
    var header : String?
    var descriptions : String?
    var masterBankId : Int?
    var url : String?
    var urlType : String?
    
    var valuesArray = [String]()
    var fieldId : Int?
    var text : String?
    var componentType : String?
    var placeHolder : String?

    override init(){}
    
    init(jsonObject : [String : Any]){
        name = jsonObject["name"] as? String
        type = jsonObject["type"] as? String
        lastVisitedDate = jsonObject[klastVisitedDate] as? String
        fieldType = jsonObject["fieldType"] as? String
        header = jsonObject["header"] as? String
        descriptions = jsonObject["description"] as? String
        masterBankId = jsonObject["masterBankId"] as? Int
        url = jsonObject["url"] as? String
        
        urlType = jsonObject["urlType"] as? String
        fieldId = jsonObject["fieldId"] as? Int
        text = jsonObject["text"] as? String
        componentType = jsonObject["componentType"] as? String
        placeHolder = jsonObject["placeHolder"] as? String
        if let valuesData = jsonObject["values"] as? [String]{
            valuesArray.removeAll()
            valuesArray = valuesData
        }

    }
}
