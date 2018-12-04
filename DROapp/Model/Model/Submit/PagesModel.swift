//
//  PagesModel.swift
//  DROapp
//
//  Created by Carematix on 03/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class PagesModel: NSObject {
    var id: Int?
    var pageNumber: Int?
    var currentPageId: Int?
    var nextPageId : Int?
    var sectionArray = [SectionsModel]()
    override init(){}
    
    init( jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        pageNumber = jsonObject["pageNumber"] as? Int
        
        if let  navigationRule = jsonObject["navigationRule"] as? [String : Any]{
            currentPageId = navigationRule["currentPageId"] as? Int
            nextPageId = navigationRule["nextPageId"] as? Int
        }
        
        if let sectionDataArray = jsonObject["sections"] as? [[String : Any]]{
            for sectionData in sectionDataArray{
                let section = SectionsModel(jsonObject: sectionData)
                sectionArray.append(section)
            }
        }
    }
}
