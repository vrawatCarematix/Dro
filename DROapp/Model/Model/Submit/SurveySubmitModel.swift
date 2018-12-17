//
//  SurveySubmitModel.swift
//  DROapp
//
//  Created by Carematix on 03/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SurveySubmitModel: NSObject {
    
    var surveySessionId : Int?
    var programSurveyId : Int?
    var programUserID : Int?
    var progressStatus : String?
    var percentageComplete : Double?
    var startTime : Int?
    var endTime : Int?
    var lastSubmissionTime : Int?
    var timeSpent : Double?
    var lastAnswerPageId : Int?
    var declined : Int?
    
    var surveyScheduleId : Int?
    var scheduledDate : Int?
    var scheduledStartTime : Int?
    var scheduledEndTime : Int?
    var scheduleType : String?
    var userScheduleAssignId : Int?
    
    var unscheduled : Int?
    var pageNavigationJson = [[String : Any]]()
    var pageNavigationArray = [PageNavigations]()
    
    var userAnswerLogsJson = [[String : Any]]()
    var userAnswerLogsArray = [UserAnswerLogs]()
    
    var surveyId : Int?
    
    var surveyInstructionJson = [[String : Any]]()
    var surveyInstructionArray = [InstructionModel]()
    
    var surveyLanguage : String?
    
    var surveyIntroductionText : String?
    var surveyIntroductionUrl : String?
    var name : String?
    
    var programId : Int?
    var organizationName : String?
    var programName : String?
    var logoURL : String?
    
    var pagesJson = [[String : Any]]()
    var pagesArray = [PagesModel]()
    
    var validity : Int?
    var retakeAllowed : Int?
    var important : Int?
    var autoSave : Int?
    var isUploaded : Int?
    var userSurveySessionId : Int?
    var type : String?
    var code : String?
    var group : String?

    override init(){}
    
    init(jsonObject : [String : Any]){
        
        surveySessionId = jsonObject["surveySessionId"] as? Int
        programSurveyId = jsonObject["programSurveyId"] as? Int
        programUserID = jsonObject[kProgramUserId] as? Int
        progressStatus = jsonObject["progressStatus"] as? String
        percentageComplete = jsonObject["percentageComplete"] as? Double
        startTime = jsonObject["startTime"] as? Int
        endTime = jsonObject["endTime"] as? Int
        lastSubmissionTime = jsonObject["lastSubmissionTime"] as? Int
        timeSpent = jsonObject["timeSpent"] as? Double
        lastAnswerPageId = jsonObject["lastAnswerPageId"] as? Int
        declined = jsonObject["declined"] as? Int
        surveyScheduleId = jsonObject["surveyScheduleId"] as? Int
        scheduledDate = jsonObject["scheduledDate"] as? Int
        scheduledStartTime = jsonObject["scheduledStartTime"] as? Int
        scheduledEndTime = jsonObject["scheduledEndTime"] as? Int
        scheduleType = jsonObject["scheduleType"] as? String
        userScheduleAssignId = jsonObject["userScheduleAssignId"] as? Int
        
        if let scheduledSessionDetail = jsonObject["scheduledSession"] as? [String : Any]{
            
            surveyScheduleId = scheduledSessionDetail["id"] as? Int
            scheduledDate = scheduledSessionDetail["scheduledDate"] as? Int
            scheduledStartTime = scheduledSessionDetail["startTime"] as? Int
            scheduledEndTime = scheduledSessionDetail["endTime"] as? Int
            scheduleType = scheduledSessionDetail["scheduleType"] as? String
            userScheduleAssignId = scheduledSessionDetail["userScheduleAssignId"] as? Int
            
        }
        
        
        surveyId = jsonObject["id"] as? Int
        surveyLanguage = jsonObject[planguage] as? String
        
        if let  surveyInstructionsDataArray = jsonObject["surveyInstructions"] as? [[String : Any]]{
            
            surveyInstructionJson = surveyInstructionsDataArray
            
            for surveyInstructionsData in surveyInstructionsDataArray{
                let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                surveyInstructionArray.append(surveyInstruction)
            }
        }
        
        if let  userSurveySessionDetail = jsonObject["userSurveySessionDetail"] as? [String : Any]{
            startTime = userSurveySessionDetail["startTime"] as? Int
            declined = userSurveySessionDetail["declined"] as? Int
            endTime = userSurveySessionDetail["endTime"] as? Int
            lastAnswerPageId = userSurveySessionDetail["lastAnswerPageId"] as? Int
            percentageComplete = userSurveySessionDetail["percentageComplete"] as? Double
            progressStatus = userSurveySessionDetail["progressStatus"] as? String
            timeSpent = userSurveySessionDetail["timeSpent"] as? Double
            lastSubmissionTime = userSurveySessionDetail["lastSubmissionTime"] as? Int

        }
        
        if let  surveyIntroduction = jsonObject["surveyIntroduction"] as? [String : Any]{
            if let  text = surveyIntroduction["text"] as? String {
                self.surveyIntroductionText = text
            }
            if let  url = surveyIntroduction["url"] as? String {
                self.surveyIntroductionUrl = url
            }
        }
        
        name = jsonObject["name"] as? String
        if let  programInfo = jsonObject[pprogramInfo] as? [String : Any]{
            programId = programInfo[kprogramId] as? Int
            organizationName = programInfo[korganizationName] as? String
            programName = programInfo[kprogramName] as? String
            logoURL = programInfo[klogoURL] as? String
        }
        if let  pagesDataArray = jsonObject["pages"] as? [[String : Any]]{
            pagesJson = pagesDataArray            
            for pagesData in pagesDataArray{
                let pages = PagesModel(jsonObject: pagesData)
                pagesArray.append(pages)
            }
        }
        if let  pageNavigationDataArray = jsonObject["pageNavigations"] as? [[String : Any]]{
            pageNavigationJson = pageNavigationDataArray
            for pageNavigationData in pageNavigationDataArray{
                let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                pageNavigationArray.append(pageNavigation)
            }
        }
        if let  userAnswerLogsDataArray = jsonObject["userAnswerLogs"] as? [[String : Any]]{
            userAnswerLogsJson = userAnswerLogsDataArray
            for userAnswerLogsData in userAnswerLogsDataArray{
                let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                if userAnswerLogs.questionId != 0 {
                    if let fileId = userAnswerLogs.fileId , fileId != 0 {
                        if let mediaModel = DatabaseHandler.getMedia(surveySessionId ?? 0, questionId: userAnswerLogs.questionId  ?? 0) , let _ = mediaModel.name {
                        }else if let mediaModel = DatabaseHandler.getMedia(userAnswerLogs.id ?? 0, questionId: userAnswerLogs.questionId  ?? 0) , let _ = mediaModel.name {
                        }else{
                            let media = MediaModel()
                            media.sessionScheduleId = surveyScheduleId
                            media.questionId = userAnswerLogs.questionId
                            media.pageId = userAnswerLogs.id
                            media.endTime = scheduledEndTime
                            let url = AppURL.getFile + "\(fileId)"
                            WebServiceMethods.sharedInstance.downloadMultimediaFile (nil ,url: url , completionHandler: { (succes, message) in
                                if succes {
                                    media.name = message
                                    let _ = DatabaseHandler.insertIntoMedia(media: media)
                                }else{
                                    debugPrint("fail")
                                }
                            })
                        }
                    }
                    userAnswerLogsArray.append(userAnswerLogs)
                }
            }
        }
        if let  surveyConfig = jsonObject["surveyConfig"] as? [String : Any]{
            validity = surveyConfig["validity"] as? Int
            retakeAllowed = surveyConfig["retakeAllowed"] as? Int
            important = surveyConfig["important"] as? Int
            autoSave = surveyConfig["autoSave"] as? Int
            unscheduled = surveyConfig["unscheduled"] as? Int
            
            if let unschedul = unscheduled , unschedul == 1 {
                scheduleType = "UNSCHEDULED"
            }else {
              //  scheduleType = "SCHEDULED"
            }
        }
        if let  type = jsonObject["scheduledSession"] as? [String : Any]{
            scheduleType = type["scheduleType"] as? String
        }
        isUploaded = jsonObject["isUploaded"] as? Int
        userSurveySessionId = jsonObject["userSurveySessionId"] as? Int

         type = jsonObject["type"] as? String
         code = jsonObject["code"] as? String
         group = jsonObject["group"] as? String
    }
    
    
    init(jsonObject : [String : Any] , sessionId : Int ){
        type = jsonObject["userSurveySessionId"] as? String
        code = jsonObject["userSurveySessionId"] as? String
        group = jsonObject["userSurveySessionId"] as? String
        surveySessionId = sessionId
        programSurveyId = jsonObject["programSurveyId"] as? Int
        programUserID = jsonObject[kProgramUserId] as? Int
        
        progressStatus = jsonObject["progressStatus"] as? String
        percentageComplete = jsonObject["percentageComplete"] as? Double
        startTime = jsonObject["startTime"] as? Int
        endTime = jsonObject["endTime"] as? Int
        lastSubmissionTime = jsonObject["lastSubmissionTime"] as? Int
        timeSpent = jsonObject["timeSpent"] as? Double
        lastAnswerPageId = jsonObject["lastAnswerPageId"] as? Int
        declined = jsonObject["declined"] as? Int
        
        surveyScheduleId = jsonObject["surveyScheduleId"] as? Int
        scheduledDate = jsonObject["scheduledDate"] as? Int
        scheduledStartTime = jsonObject["scheduledStartTime"] as? Int
        scheduledEndTime = jsonObject["scheduledEndTime"] as? Int
        scheduleType = jsonObject["scheduleType"] as? String
        userScheduleAssignId = jsonObject["userScheduleAssignId"] as? Int
        
        if let scheduledSessionDetail = jsonObject["scheduledSession"] as? [String : Any]{
            surveyScheduleId = scheduledSessionDetail["id"] as? Int
            scheduledDate = scheduledSessionDetail["scheduledDate"] as? Int
            scheduledStartTime = scheduledSessionDetail["startTime"] as? Int
            scheduledEndTime = scheduledSessionDetail["endTime"] as? Int
            scheduleType = scheduledSessionDetail["scheduleType"] as? String
            userScheduleAssignId = scheduledSessionDetail["userScheduleAssignId"] as? Int
        }
        
        surveyId = jsonObject["id"] as? Int
        surveyLanguage = jsonObject[planguage] as? String
        
        if let  surveyInstructionsDataArray = jsonObject["surveyInstructions"] as? [[String : Any]]{
            surveyInstructionJson = surveyInstructionsDataArray
            for surveyInstructionsData in surveyInstructionsDataArray{
                let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                surveyInstructionArray.append(surveyInstruction)
            }
        }
        
        if let  userSurveySessionDetail = jsonObject["userSurveySessionDetail"] as? [String : Any]{
            startTime = userSurveySessionDetail["startTime"] as? Int
            declined = userSurveySessionDetail["declined"] as? Int
            endTime = userSurveySessionDetail["endTime"] as? Int
            lastAnswerPageId = userSurveySessionDetail["lastAnswerPageId"] as? Int
            lastSubmissionTime = userSurveySessionDetail["lastSubmissionTime"] as? Int

            percentageComplete = userSurveySessionDetail["percentageComplete"] as? Double
            progressStatus = userSurveySessionDetail["progressStatus"] as? String
            timeSpent = userSurveySessionDetail["timeSpent"] as? Double
        }
        if let  surveyIntroduction = jsonObject["surveyIntroduction"] as? [String : Any]{
            if let  text = surveyIntroduction["text"] as? String {
                self.surveyIntroductionText = text
            }
            if let  url = surveyIntroduction["url"] as? String {
                self.surveyIntroductionUrl = url
            }
        }
        name = jsonObject["name"] as? String
        
        if let  programInfo = jsonObject[pprogramInfo] as? [String : Any]{
            programId = programInfo[kprogramId] as? Int
            organizationName = programInfo[korganizationName] as? String
            programName = programInfo[kprogramName] as? String
            logoURL = programInfo[klogoURL] as? String
        }
        if let  pagesDataArray = jsonObject["pages"] as? [[String : Any]]{
            pagesJson = pagesDataArray
            for pagesData in pagesDataArray{
                let pages = PagesModel(jsonObject: pagesData)
                pagesArray.append(pages)
            }
        }
        if let  pageNavigationDataArray = jsonObject["pageNavigations"] as? [[String : Any]]{
            pageNavigationJson = pageNavigationDataArray
            for pageNavigationData in pageNavigationDataArray{
                let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                pageNavigationArray.append(pageNavigation)
            }
        }
        if let  userAnswerLogsDataArray = jsonObject["userAnswerLogs"] as? [[String : Any]]{
            userAnswerLogsJson = userAnswerLogsDataArray
            for userAnswerLogsData in userAnswerLogsDataArray{
                let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                if userAnswerLogs.questionId != 0 {
                    if let fileId = userAnswerLogs.fileId , fileId != 0 {
                        if let mediaModel = DatabaseHandler.getMedia(surveySessionId ?? 0, questionId: userAnswerLogs.questionId  ?? 0) , let _ = mediaModel.name {
                        }else if let mediaModel = DatabaseHandler.getMedia(userAnswerLogs.id ?? 0, questionId: userAnswerLogs.questionId  ?? 0) , let _ = mediaModel.name {
                        }else{
                            let media = MediaModel()
                            media.sessionScheduleId = surveySessionId
                            media.questionId = userAnswerLogs.questionId
                            media.pageId = userAnswerLogs.id
                            media.endTime = scheduledEndTime
                            let url = AppURL.getFile + "\(fileId)"
                            WebServiceMethods.sharedInstance.downloadMultimediaFile (nil ,url: url , completionHandler: { (succes, message) in
                                if succes {
                                    media.name = message
                                    media.isUploaded = 1
                                    let _ = DatabaseHandler.insertIntoMedia(media: media)
                                    debugPrint("here")
                                }else{
                                    debugPrint("fail")
                                }
                            })
                        }
                    }
                    userAnswerLogsArray.append(userAnswerLogs)
                }
            }
        }
        if let  surveyConfig = jsonObject["surveyConfig"] as? [String : Any]{
            validity = surveyConfig["validity"] as? Int
            retakeAllowed = surveyConfig["retakeAllowed"] as? Int
            important = surveyConfig["important"] as? Int
            autoSave = surveyConfig["autoSave"] as? Int
            unscheduled = surveyConfig["unscheduled"] as? Int
            if let unschedul = unscheduled , unschedul == 1 {
                scheduleType = "UNSCHEDULED"
            }else {
                //  scheduleType = "SCHEDULED"
            }
        }
        if let  type = jsonObject["scheduledSession"] as? [String : Any]{
            scheduleType = type["scheduleType"] as? String
        }
        isUploaded = jsonObject["isUploaded"] as? Int
        userSurveySessionId = jsonObject["userSurveySessionId"] as? Int
        type = jsonObject["type"] as? String
        code = jsonObject["code"] as? String
        group = jsonObject["group"] as? String
    }
    
}
