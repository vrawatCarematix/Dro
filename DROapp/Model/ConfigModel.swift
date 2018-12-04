//
//  ConfigModel.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ConfigModel: NSObject {
  

    var name : String?
    var type : String?
    var lastVisitedDate : String?
    
    var fieldModelArray = [FieldModel]()
    override init(){}
    init(jsonObject : [String : Any]){
        name = jsonObject["name"] as? String
        type = jsonObject["type"] as? String
        lastVisitedDate = jsonObject[klastVisitedDate] as? String
        if let  fields = jsonObject["fields"] as? [[String : Any]]{
            for fieldData in fields{
                let field = FieldModel(jsonObject: fieldData)
                fieldModelArray.append(field)
                
            }
        }
        
    }
    
}
