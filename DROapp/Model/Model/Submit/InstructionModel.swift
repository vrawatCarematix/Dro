//
//  InstructionModel.swift
//  DRO
//
//  Created by Carematix on 09/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class InstructionModel: NSObject {

    var type: String?
    var sequence: Int?
    var header: String?
    var descriptions: String?
    
    override init(){}
    
    init( jsonObject : [String : Any] ){
        type = jsonObject["type"] as? String
        sequence = jsonObject["sequence"] as? Int
        header = jsonObject["header"] as? String
        descriptions = jsonObject["description"] as? String
    }
    
}
