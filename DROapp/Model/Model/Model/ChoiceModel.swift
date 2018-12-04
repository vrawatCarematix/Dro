//
//  ChoiceModel.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ChoiceModel: NSObject , NSCoding  {
    
    var id: Int?
    var text: String?
    var sequence: Int?
    var score: Int?
    var url: String?
    var choiceType: String?
    var dropdownArray =  [String]()
    var helpText: String?
    var scoreText: String?

    override init(){}
    
    init( jsonObject : [String : Any] ){
        id = jsonObject["id"] as? Int
        text = jsonObject["text"] as? String
        sequence = jsonObject["sequence"] as? Int
        score = jsonObject["score"] as? Int
        url = jsonObject["url"] as? String
        choiceType = jsonObject["choiceType"] as? String
        if let stringArray = jsonObject["dropdownArray"] as? [String] {
            dropdownArray = stringArray

        }
        helpText = jsonObject["helpText"] as? String
        scoreText = jsonObject["scoreText"] as? String

    }
    required convenience init(coder aDecoder: NSCoder) {
        self.init()

       // if aDecoder.decodeInteger(forKey: "id") {
            self.id = aDecoder.decodeInteger(forKey: "id")

       // }
        if let idText = aDecoder.decodeObject(forKey: "text") as? String{
            self.text = idText
            
        }
       // if let idText = aDecoder.decodeInteger(forKey: "sequence"){
            self.sequence =  aDecoder.decodeInteger(forKey: "sequence")
            
       // }
       // if let idText = aDecoder.decodeInteger(forKey: "score"){
            self.score = aDecoder.decodeInteger(forKey: "score")
            
       // }
        if let idText = aDecoder.decodeObject(forKey: "url") as? String{
            self.url = idText
            
        }
        if let idText = aDecoder.decodeObject(forKey: "choiceType") as? String{
            self.choiceType = idText
            
        }
        if let idText = aDecoder.decodeObject(forKey: "dropdownArray") as? [String]{
            self.dropdownArray = idText
            
        }
        if let idText = aDecoder.decodeObject(forKey: "helpText") as? String{
            self.helpText = idText
            
        }
        if let idText = aDecoder.decodeObject(forKey: "scoreText") as? String{
            self.scoreText = idText
            
        }
//        let sequence = aDecoder.decodeInteger(forKey: "sequence")
//        let score = aDecoder.decodeInteger(forKey: "score")
//        let url = aDecoder.decodeObject(forKey: "url") as! String
//         let choiceType = aDecoder.decodeObject(forKey: "choiceType") as! String
//         let dropdownArray = aDecoder.decodeObject(forKey: "dropdownArray") as! [String]
//        let helpText = aDecoder.decodeObject(forKey: "helpText") as! String
//        let scoreText = aDecoder.decodeObject(forKey: "scoreText") as! String
//
//        self.init()
//        self.id = id
//        self.text = text
//        self.sequence = sequence
//        self.score = score
//        self.url = url
//        self.choiceType = choiceType
//        self.dropdownArray = dropdownArray
//        self.helpText = helpText
//        self.scoreText = scoreText
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let idText = id {
            aCoder.encode(idText, forKey: "id")
        }
        if let idText = text {
            aCoder.encode(idText, forKey: "text")
        }
        if let idText = sequence {
            aCoder.encode(idText, forKey: "sequence")
        }
        if let idText = score {
            aCoder.encode(idText, forKey: "score")
        }
        if let idText = url {
            aCoder.encode(idText, forKey: "url")
        }
        if let idText = choiceType {
            aCoder.encode(idText, forKey: "choiceType")
        }
        if dropdownArray.count > 0 {
            aCoder.encode(dropdownArray, forKey: "dropdownArray")
        }
        if let idText = helpText {
            aCoder.encode(idText, forKey: "helpText")
        }
        if let idText = scoreText {
            aCoder.encode(idText, forKey: "scoreText")
        }
        
//        aCoder.encode(text, forKey: "text")
//        aCoder.encode(sequence, forKey: "sequence")
//        aCoder.encode(score, forKey: "score")
//        aCoder.encode(url, forKey: "url")
//        aCoder.encode(choiceType, forKey: "choiceType")
//        aCoder.encode(dropdownArray, forKey: "dropdownArray")
//
//        aCoder.encode(helpText, forKey: "helpText")
//        aCoder.encode(scoreText, forKey: "scoreText")

    }
}
