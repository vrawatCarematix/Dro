//
//  LanguageModel.swift
//  DROapp
//
//  Created by Carematix on 30/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class LanguageModel: NSObject {
    var id : Int?
    var code : String?
    var desc : String?
    var languageJson = [String: Any]()
    override init(){}
    init(jsonObject : [String : Any]){
        id = jsonObject["id"] as? Int
        code = jsonObject["code"] as? String
        desc = jsonObject["desc"] as? String
        if let languageJsonData = jsonObject["languageJson"] as? [String: Any]{
            languageJson = languageJsonData
        }
    }
}
