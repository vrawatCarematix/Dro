//
//  PageNavigations.swift
//  DROapp
//
//  Created by Carematix on 03/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class PageNavigations: NSObject {
    var currentPageId: Int?
    var nextPageId: Int?
    var previousPageId: Int?
    override init(){}
    init(jsonObject : [String : Any]){
        currentPageId = jsonObject["currentPageId"] as? Int
        nextPageId = jsonObject["nextPageId"] as? Int
        previousPageId = jsonObject["previousPageId"] as? Int
    }

    func getDict() -> [String : Any] {
        return ["currentPageId" : currentPageId ?? 0, "nextPageId" : nextPageId ?? 0, "previousPageId" : previousPageId ?? 0 ]
    }
}
