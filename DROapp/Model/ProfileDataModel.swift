//
//  ProfileDataModel.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ProfileDataModel: NSObject {
    var title : String?
    var type : String?
    var data : String?
    
    override init(){}
    init(jsonObject : [String : Any]){
        title = jsonObject["title"] as? String
        type = jsonObject["type"] as? String
        data = jsonObject["data"] as? String
    }
}
