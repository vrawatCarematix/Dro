//
//  FieldModel.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class FieldModel: NSObject {

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
        fieldType = jsonObject["fieldType"] as? String
        fieldId = jsonObject["fieldId"] as? Int
        text = jsonObject["text"] as? String
        componentType = jsonObject["componentType"] as? String
        placeHolder = jsonObject["placeHolder"] as? String

        if let masterBank = jsonObject["masterBank"] as? [String : Any]{
            header = masterBank["header"] as? String
            descriptions = masterBank["description"] as? String
            masterBankId = masterBank["masterBankId"] as? Int
            
            url = masterBank["url"] as? String
            urlType = masterBank["urlType"] as? String

        }
        if let valuesData = jsonObject["values"] as? [String]{
            valuesArray.removeAll()
            valuesArray = valuesData
        }
    }
}
