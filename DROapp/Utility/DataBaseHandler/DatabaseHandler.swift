
import Foundation
import SQLite3

class DatabaseHandler: NSObject {
    //MARK:- Databse
    static var db = openDatabase()
 
    //MARK:- Create Database if not exists
    static func createDatabaseIfNeeded() {
        db = openDatabase()
        let fileManager = FileManager.default
        let dbPath = getDBPath()
        if fileManager.fileExists(atPath: dbPath) == false  {
            var db: OpaquePointer? = nil
            if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
                DatabaseHandler.createAllTableIfNotExist()
            }else{
                
            }
        }else{
            var db: OpaquePointer? = nil

            if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
                DatabaseHandler.createAllTableIfNotExist()
            }else{
                
            }
        }
    }
    
    static func getDBPath() -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(DATABASE_NAME)
        debugPrint("dbpath : =  " + fileURL.path)
        return fileURL.path
    }
    
    

    //MARK:- OPEN DATABASE
    static func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            debugPrint("Successfully opened connection to database at ")
            return db
        } else {
            debugPrint("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
        return db
    }

    //MARK:-
    //MARK:- Create All Table IF NOT EXISTS
    static func createAllTableIfNotExist() {
        createSurveySchedulesTable()
        createViewDroTable()
        createMessageTable()
        createConfigTable()
        createLanguageTable()
        createDeclinedReasonTable()
        createDeclinedSurveyTable()
        createSurveysTable()
        createSurveysDataTable()
        createMediaTable()
        createTimelineTable()
    }

    
    
    //MARK:- CREATE_Survey_Schedules IF NOT EXISTS
    
    static func createSurveySchedulesTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_SURVEY_SCHEDLUE , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_SURVEY_SCHEDLUE table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_SURVEY_SCHEDLUE \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_SURVEY_SCHEDLUE \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_VIEW_DRO IF NOT EXISTS
    
    static func createViewDroTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_VIEW_DRO , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_VIEW_DRO table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_VIEW_DRO \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_VIEW_DRO \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_MESSAGE IF NOT EXISTS
    
    static func createMessageTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_MESSAGE , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_MESSAGE table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_MESSAGE \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_MESSAGE \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_CONFIG IF NOT EXISTS
    
    static func createConfigTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_CONFIG , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_CONFIG table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_CONFIG \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_CONFIG \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_LANGUAGE IF NOT EXISTS
    
    static func createLanguageTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_LANGUAGE , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_LANGUAGE table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_LANGUAGE \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_LANGUAGE \(errmsg)")
            
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_LANGUAGE IF NOT EXISTS
    
    static func createDeclinedReasonTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_DECLINED_REASON , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_DECLINED_REASON table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_DECLINED_REASON \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_DECLINED_REASON \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_DECLINED_SURVEY IF NOT EXISTS
    
    static func createDeclinedSurveyTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_DECLINED_SURVEY , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_DECLINED_SURVEY table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_DECLINED_SURVEY \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_DECLINED_SURVEY \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_SURVEY IF NOT EXISTS
    
    static func createSurveysTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_SURVEY , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_SURVEY table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_SURVEY \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_SURVEY \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_SURVEY_DATA IF NOT EXISTS
    
    static func createSurveysDataTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_SURVEY_DATA , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_SURVEY_DATA table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_SURVEY_DATA \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- CREATE_MEDIA IF NOT EXISTS
    
    static func createMediaTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_MEDIA , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_MEDIA table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_MEDIA   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    //MARK:- CREATE_TIMELINE IF NOT EXISTS
    
    static func createTimelineTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CREATE_TIMELINE , -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("CREATE_TIMELINE table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure CREATE_TIMELINE   \(errmsg)")            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure CREATE_TIMELINE   \(errmsg)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK:- END CREATE

    


    
   
    
    //MARK:- INSERT QUERY
    //MARK:-
    
    //MARK:- INSERT_INTO_Survey_Schedules
    static func insertIntoSurveySchedules(surveySchedulesArray : [SurveyScheduleDatabaseModel] ) -> Bool{
        var success = false
        for surveySchedule in surveySchedulesArray {
            var statement: OpaquePointer? = nil

            if sqlite3_prepare_v2(db, INSERT_INTO_SURVEY_SCHEDLUE, -1, &statement, nil) == SQLITE_OK {
                
                if let surveyDate = surveySchedule.surveyDate {
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(surveyDate))
                    
                }
                if let sessionCount = surveySchedule.sessionCount{
                    sqlite3_bind_int64(statement, 2, sqlite3_int64(sessionCount))
                    
                }
                if let startTime = surveySchedule.startTime{
                    sqlite3_bind_int64(statement, 3, sqlite3_int64(startTime))
                    
                }
                if let endTime = surveySchedule.endTime{
                    sqlite3_bind_int64(statement, 4, sqlite3_int64(endTime))
                    
                }
                if let surveyID = surveySchedule.surveyID{
                    sqlite3_bind_int64(statement, 5, sqlite3_int64(surveyID))
                    
                }
                if let isPriority = surveySchedule.isPriority{
                    sqlite3_bind_int64(statement, 6, sqlite3_int64(isPriority))
                    
                }
                if let surveyName = surveySchedule.surveyName as NSString?{
                    sqlite3_bind_text(statement, 7, surveyName.utf8String, -1, nil)
                }
                
                
                if let surveySessionId = surveySchedule.surveySessionId{
                    sqlite3_bind_int64(statement, 8, sqlite3_int64(surveySessionId))
                    
                }
                if let percentageCompleted = surveySchedule.percentageCompleted{
                    sqlite3_bind_double(statement, 9, percentageCompleted)
                }
                if let progressStatus = surveySchedule.progressStatus as NSString?{
                    sqlite3_bind_text(statement, 10, progressStatus.utf8String, -1, nil)
                }
                if let timeSpent = surveySchedule.timeSpent{
                    sqlite3_bind_int64(statement, 11, sqlite3_int64(timeSpent))
                    
                }
                if let isDeclined = surveySchedule.isDeclined{
                    sqlite3_bind_int64(statement, 12, sqlite3_int64(isDeclined))
                    
                }
                if let programSurveyId = surveySchedule.programSurveyId{
                    sqlite3_bind_int64(statement, 13, sqlite3_int64(programSurveyId))
                }
                if let surveyLanguage = surveySchedule.surveyLanguage as NSString?{
                    sqlite3_bind_text(statement, 14, surveyLanguage.utf8String, -1, nil)
                }
                if let scheduleType = surveySchedule.scheduleType as NSString?{
                    sqlite3_bind_text(statement, 15, scheduleType.utf8String, -1, nil)
                }
                if let actualEndTime = surveySchedule.actualEndTime{
                    sqlite3_bind_int64(statement, 16, sqlite3_int64(actualEndTime))
                    
                }
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_Survey_Schedules  \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_Survey_Schedules  \(errmsg)")
            }
            sqlite3_finalize(statement)

        }

        return success
    }
    
    //MARK:- INSERT_INTO_VIEW_DRO
    static func insertIntoViewDroTable(droInfoListArray : [DroInfoListModel] ) -> Bool{
        var success = false
        for droInfoList in droInfoListArray {
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, INSERT_INTO_VIEW_DRO, -1, &statement, nil) == SQLITE_OK {
                
                if let declined = droInfoList.declined {
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(declined))
                    
                }
                if let timeSpent = droInfoList.timeSpent{
                    sqlite3_bind_int64(statement, 2, sqlite3_int64(timeSpent))
                    
                }
                
                if let name = droInfoList.name as NSString?{
                    sqlite3_bind_text(statement, 3, name.utf8String, -1, nil)
                }
                if let progressStatus = droInfoList.progressStatus as NSString?{
                    sqlite3_bind_text(statement, 4, progressStatus.utf8String, -1, nil)
                }
                
                if let percentageCompleted = droInfoList.percentageCompleted{
                    sqlite3_bind_double(statement, 5, percentageCompleted)
                }
                
                if let scheduleType = droInfoList.scheduleType as NSString?{
                    sqlite3_bind_text(statement, 6, scheduleType.utf8String, -1, nil)
                }
                
                if let endTime = droInfoList.endTime{
                    sqlite3_bind_int64(statement, 7, sqlite3_int64(endTime))
                    
                }
                if let name = droInfoList.name as NSString?{
                    sqlite3_bind_text(statement, 8, name.utf8String, -1, nil)
                }
                if let endTime = droInfoList.endTime{
                    sqlite3_bind_int64(statement, 9, sqlite3_int64(endTime))
                }
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_VIEW_DRO   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_VIEW_DRO   \(errmsg)")
            }
            sqlite3_finalize(statement)
            
        }
        
        return success
    }
    
    
    
    //MARK:- INSERT_INTO_MESSAGE
    static func insertIntoMessageTable(messageArray : [MessageModel] ) -> Bool{
        var success = false
        for message in messageArray {
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, INSERT_INTO_MESSAGE, -1, &statement, nil) == SQLITE_OK {
                
                if let createTime = message.createTime {
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(createTime))
                    
                }
                if let id = message.id{
                    sqlite3_bind_int64(statement, 2, sqlite3_int64(id))
                    
                }
                if let isStarred = message.isStarred{
                    sqlite3_bind_int64(statement, 3, sqlite3_int64(isStarred))
                    
                }
                
                if let messageTile = message.messageTile as NSString?{
                    sqlite3_bind_text(statement, 4, messageTile.utf8String, -1, nil)
                }
                if let readStatus = message.readStatus as NSString?{
                    sqlite3_bind_text(statement, 5, readStatus.utf8String, -1, nil)
                }
                if let senderName = message.senderName as NSString?{
                    sqlite3_bind_text(statement, 6, senderName.utf8String, -1, nil)
                }
                if let textMessage = message.textMessage as NSString?{
                    sqlite3_bind_text(statement, 7, textMessage.utf8String, -1, nil)
                }
                
                if let userId = message.userId{
                    sqlite3_bind_int64(statement, 8, sqlite3_int64(userId))
                    
                }
                sqlite3_bind_int64(statement, 9, sqlite3_int64(message.isUploaded))
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_MESSAGE   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_MESSAGE   \(errmsg)")
            }
            sqlite3_finalize(statement)
            
        }
        
        return success
    }
    
    //MARK:- INSERT_INTO_CONFIG
    static func insertIntoConfig(configArray : [ConfigDatabaseModel] ) -> Bool{
        var success = false
        for config in configArray {
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, INSERT_INTO_CONFIG, -1, &statement, nil) == SQLITE_OK {
                
                if let name = config.name as NSString?{
                    sqlite3_bind_text(statement, 1, name.utf8String, -1, nil)
                }
                if let type = config.type as NSString?{
                    sqlite3_bind_text(statement, 2, type.utf8String, -1, nil)
                }
                if let lastVisitedDate = config.lastVisitedDate as NSString?{
                    sqlite3_bind_text(statement, 3, lastVisitedDate.utf8String, -1, nil)
                }
                if let fieldType = config.fieldType as NSString?{
                    sqlite3_bind_text(statement, 4, fieldType.utf8String, -1, nil)
                }
                if let header = config.header as NSString?{
                    sqlite3_bind_text(statement, 5, header.utf8String, -1, nil)
                }
                if let descriptions = config.descriptions as NSString?{
                    sqlite3_bind_text(statement, 6, descriptions.utf8String, -1, nil)
                }
                if let masterBankId = config.masterBankId{
                    sqlite3_bind_int64(statement, 7, sqlite3_int64(masterBankId))
                }
                if let url = config.url as NSString?{
                    sqlite3_bind_text(statement, 8, url.utf8String, -1, nil)
                }
                if let urlType = config.urlType as NSString?{
                    sqlite3_bind_text(statement, 9, urlType.utf8String, -1, nil)
                }
                if config.valuesArray.count > 0 {
                    if  let values = config.valuesArray.joined(separator: "%#") as NSString?{
                        sqlite3_bind_text(statement, 10, values.utf8String, -1, nil)
                    }
                }
                if let fieldId = config.fieldId{
                    sqlite3_bind_int64(statement, 11, sqlite3_int64(fieldId))
                }
                if let text = config.text as NSString?{
                    sqlite3_bind_text(statement, 12, text.utf8String, -1, nil)
                }
                if let componentType = config.componentType as NSString?{
                    sqlite3_bind_text(statement, 13, componentType.utf8String, -1, nil)
                }
                if let placeHolder = config.placeHolder as NSString?{
                    sqlite3_bind_text(statement, 14, placeHolder.utf8String, -1, nil)
                }
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_MESSAGE  \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_MESSAGE  \(errmsg)")
            }
            sqlite3_finalize(statement)            
        }
        return success
    }
    
    //MARK:- INSERT_INTO_LANGUAGE
    static func insertIntoLanguage(languageArray : [LanguageModel] ) -> Bool{
        var success = false
        for language in languageArray {
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, INSERT_INTO_LANGUAGE, -1, &statement, nil) == SQLITE_OK {
                if let id = language.id{
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(id))
                }
                if let code = language.code as NSString?{
                    sqlite3_bind_text(statement, 2, code.utf8String, -1, nil)
                }
                if let desc = language.desc as NSString?{
                    sqlite3_bind_text(statement, 3, desc.utf8String, -1, nil)
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: language.languageJson,
                    options: []) {
                    if let languageJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 4, languageJson.utf8String, -1, nil)
                    }
                }
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_MESSAGE   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_MESSAGE   \(errmsg)")
            }
            sqlite3_finalize(statement)
        }
        return success
    }
    
    
    //MARK:- INSERT_INTO_DECLINED_REASON
    static func insertIntoDeclinedReason(declinedReasonArray : [DeclinedModel] ) -> Bool{
        var success = false
        for declined in declinedReasonArray {
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, INSERT_INTO_DECLINED_REASON, -1, &statement, nil) == SQLITE_OK {
                if let declineReasonId = declined.declineReasonId{
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(declineReasonId))
                }
                if let declineReason = declined.declineReason as NSString?{
                    sqlite3_bind_text(statement, 2, declineReason.utf8String, -1, nil)
                }
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_DECLINED_REASON   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_DECLINED_REASON   \(errmsg)")
            }
            sqlite3_finalize(statement)
        }
        return success
    }
    
    //MARK:- INSERT_INTO_DECLINED_SURVEY
    static func insertIntoDeclinedSurvey(declinedSurveyArray : [DeclinedSurveyModel] ) -> Bool{
        var success = false
        for declinedSurvey in declinedSurveyArray {
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, INSERT_INTO_DECLINED_SURVEY, -1, &statement, nil) == SQLITE_OK {
                if let declineReasonId = declinedSurvey.declineReasonId{
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(declineReasonId))
                }
                if let declineTime = declinedSurvey.declineTime{
                    sqlite3_bind_int64(statement, 2, sqlite3_int64(declineTime))
                }
                if let userSurveySessionId = declinedSurvey.userSurveySessionId{
                    sqlite3_bind_int64(statement, 3, sqlite3_int64(userSurveySessionId))
                }
                sqlite3_bind_int64(statement, 4, sqlite3_int64(declinedSurvey.isUploaded))
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_DECLINED_SURVEY   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_DECLINED_SURVEY   \(errmsg)")
            }
            sqlite3_finalize(statement)
        }
        return success
    }
    
    //MARK:- INSERT_INTO_SURVEY
    static func insertIntoSurvey(surveyArray: [SurveySubmitModel] ) -> Bool{
        var success = false
        for survey in surveyArray {
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, INSERT_INTO_SURVEY, -1, &statement, nil) == SQLITE_OK {
                if let surveySessionId = survey.surveySessionId{
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(surveySessionId))
                }
                if let programSurveyId = survey.programSurveyId{
                    sqlite3_bind_int64(statement, 2, sqlite3_int64(programSurveyId))
                }
                if let programUserID = survey.programUserID{
                    sqlite3_bind_int64(statement, 3, sqlite3_int64(programUserID))
                }
                if let progressStatus = survey.progressStatus as NSString?{
                    sqlite3_bind_text(statement, 4, progressStatus.utf8String, -1, nil)
                }
                if let percentageComplete = survey.percentageComplete{
                    sqlite3_bind_double(statement, 5, percentageComplete)
                }
                if let startTime = survey.startTime{
                    sqlite3_bind_int64(statement, 6, sqlite3_int64(startTime))
                }
                if let endTime = survey.endTime{
                    sqlite3_bind_int64(statement, 7, sqlite3_int64(endTime))
                }
                if let lastSubmissionTime = survey.lastSubmissionTime{
                    sqlite3_bind_int64(statement, 8, sqlite3_int64(lastSubmissionTime))
                }
                if let timeSpent = survey.timeSpent{
                    sqlite3_bind_double(statement, 9, timeSpent)
                }
                if let lastAnswerPageId = survey.lastAnswerPageId{
                    sqlite3_bind_int64(statement, 10, sqlite3_int64(lastAnswerPageId))
                }
                if let declined = survey.declined{
                    sqlite3_bind_int64(statement, 11, sqlite3_int64(declined))
                }
                if let surveyScheduleId = survey.surveyScheduleId{
                    sqlite3_bind_int64(statement, 12, sqlite3_int64(surveyScheduleId))
                }
                if let scheduledDate = survey.scheduledDate{
                    sqlite3_bind_int64(statement, 13, sqlite3_int64(scheduledDate))
                }
                if let scheduledStartTime = survey.scheduledStartTime{
                    sqlite3_bind_int64(statement, 14, sqlite3_int64(scheduledStartTime))
                }
                if let scheduledEndTime = survey.scheduledEndTime{
                    sqlite3_bind_int64(statement, 15, sqlite3_int64(scheduledEndTime))
                }
                if let scheduleType = survey.scheduleType as NSString?{
                    sqlite3_bind_text(statement, 16, scheduleType.utf8String, -1, nil)
                }
                if let userScheduleAssignId = survey.userScheduleAssignId{
                    sqlite3_bind_int64(statement, 17, sqlite3_int64(userScheduleAssignId))
                }
                if let unscheduled = survey.unscheduled{
                    sqlite3_bind_int64(statement, 18, sqlite3_int64(unscheduled))
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: survey.pageNavigationJson ,
                    options: []) {
                    
                    if let pageNavigationJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 19, pageNavigationJson.utf8String, -1, nil)
                    }
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: survey.userAnswerLogsJson ,
                    options: []) {
                    
                    if let userAnswerLogsJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 20, userAnswerLogsJson.utf8String, -1, nil)
                    }
                }
                if let surveyId = survey.surveyId{
                    sqlite3_bind_int64(statement, 21, sqlite3_int64(surveyId))
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: survey.surveyInstructionJson ,
                    options: []) {
                    if let surveyInstructionJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 22, surveyInstructionJson.utf8String, -1, nil)
                    }
                }
                if let surveyLanguage = survey.surveyLanguage as NSString?{
                    sqlite3_bind_text(statement, 23, surveyLanguage.utf8String, -1, nil)
                }
                if let surveyIntroductionText = survey.surveyIntroductionText as NSString?{
                    sqlite3_bind_text(statement, 24, surveyIntroductionText.utf8String, -1, nil)
                }
                if let surveyIntroductionUrl = survey.surveyIntroductionUrl as NSString?{
                    sqlite3_bind_text(statement, 25, surveyIntroductionUrl.utf8String, -1, nil)
                }
                if let name = survey.name as NSString?{
                    sqlite3_bind_text(statement, 26, name.utf8String, -1, nil)
                }
                if let programId = survey.programId{
                    sqlite3_bind_int64(statement, 27, sqlite3_int64(programId))
                }
                if let organizationName = survey.organizationName as NSString?{
                    sqlite3_bind_text(statement, 28, organizationName.utf8String, -1, nil)
                }
                if let programName = survey.programName as NSString?{
                    sqlite3_bind_text(statement, 29, programName.utf8String, -1, nil)
                }
                if let logoURL = survey.logoURL as NSString?{
                    sqlite3_bind_text(statement, 30, logoURL.utf8String, -1, nil)
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: survey.pagesJson ,
                    options: []) {
                    if let pagesJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 31, pagesJson.utf8String, -1, nil)
                    }
                }
                if let validity = survey.validity{
                    sqlite3_bind_int64(statement, 32, sqlite3_int64(validity))
                }
                if let retakeAllowed = survey.retakeAllowed{
                    sqlite3_bind_int64(statement, 33, sqlite3_int64(retakeAllowed))
                }
                if let important = survey.important{
                    sqlite3_bind_int64(statement, 34, sqlite3_int64(important))
                }
                if let autoSave = survey.autoSave{
                    sqlite3_bind_int64(statement, 35, sqlite3_int64(autoSave))
                }
                
                if let isUploaded = survey.isUploaded{
                    sqlite3_bind_int64(statement, 36, sqlite3_int64(isUploaded))
                }
                if let userSurveySessionId = survey.userSurveySessionId{
                    sqlite3_bind_int64(statement, 37, sqlite3_int64(userSurveySessionId))
                }
                if let type = survey.type as NSString?{
                    sqlite3_bind_text(statement, 38, type.utf8String, -1, nil)
                }
                
                if let code = survey.code as NSString?{
                    sqlite3_bind_text(statement, 39, code.utf8String, -1, nil)
                }
                
                if let group = survey.group as NSString?{
                    sqlite3_bind_text(statement, 40, group.utf8String, -1, nil)
                }
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_SURVEY   \(errmsg)")
                }
            }else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_SURVEY   \(errmsg)")
            }
            sqlite3_finalize(statement)
        }
        return success
    }
    
    
    
    //MARK:- INSERT_INTO_SURVEY_DATA
    static func insertIntoSurveyData(survey: SurveySubmitModel ) -> Bool{
        var success = false
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, INSERT_INTO_SURVEY_DATA, -1, &statement, nil) == SQLITE_OK {
            if let surveySessionId = survey.surveySessionId{
                sqlite3_bind_int64(statement, 1, sqlite3_int64(surveySessionId))
            }
            if let programSurveyId = survey.programSurveyId{
                sqlite3_bind_int64(statement, 2, sqlite3_int64(programSurveyId))
            }
            if let programUserID = survey.programUserID{
                sqlite3_bind_int64(statement, 3, sqlite3_int64(programUserID))
            }
            if let progressStatus = survey.progressStatus as NSString?{
                sqlite3_bind_text(statement, 4, progressStatus.utf8String, -1, nil)
            }
            if let percentageComplete = survey.percentageComplete{
                sqlite3_bind_double(statement, 5, percentageComplete)
            }
            
            if let startTime = survey.startTime{
                sqlite3_bind_int64(statement, 6, sqlite3_int64(startTime))
            }
            if let endTime = survey.endTime{
                sqlite3_bind_int64(statement, 7, sqlite3_int64(endTime))
            }
            if let lastSubmissionTime = survey.lastSubmissionTime{
                sqlite3_bind_int64(statement, 8, sqlite3_int64(lastSubmissionTime))
            }
            if let timeSpent = survey.timeSpent{
                sqlite3_bind_double(statement, 9, timeSpent)
            }
            if let lastAnswerPageId = survey.lastAnswerPageId{
                sqlite3_bind_int64(statement, 10, sqlite3_int64(lastAnswerPageId))
            }
            if let declined = survey.declined{
                sqlite3_bind_int64(statement, 11, sqlite3_int64(declined))
            }
            if let surveyScheduleId = survey.surveyScheduleId{
                sqlite3_bind_int64(statement, 12, sqlite3_int64(surveyScheduleId))
            }
            if let scheduledDate = survey.scheduledDate{
                sqlite3_bind_int64(statement, 13, sqlite3_int64(scheduledDate))
            }
            
            if let scheduledStartTime = survey.scheduledStartTime{
                sqlite3_bind_int64(statement, 14, sqlite3_int64(scheduledStartTime))
            }
            if let scheduledEndTime = survey.scheduledEndTime{
                sqlite3_bind_int64(statement, 15, sqlite3_int64(scheduledEndTime))
            }
            if let scheduleType = survey.scheduleType as NSString?{
                sqlite3_bind_text(statement, 16, scheduleType.utf8String, -1, nil)
            }
            if let userScheduleAssignId = survey.userScheduleAssignId{
                sqlite3_bind_int64(statement, 17, sqlite3_int64(userScheduleAssignId))
            }
            
            if let unscheduled = survey.unscheduled{
                sqlite3_bind_int64(statement, 18, sqlite3_int64(unscheduled))
            }
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: survey.pageNavigationJson ,
                options: []) {
                if let pageNavigationJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                    sqlite3_bind_text(statement, 19, pageNavigationJson.utf8String, -1, nil)
                }
            }
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: survey.userAnswerLogsJson ,
                options: []) {
                
                if let userAnswerLogsJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                    sqlite3_bind_text(statement, 20, userAnswerLogsJson.utf8String, -1, nil)
                }
            }
            
            if let surveyId = survey.surveyId{
                sqlite3_bind_int64(statement, 21, sqlite3_int64(surveyId))
            }
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: survey.surveyInstructionJson ,
                options: []) {
                if let surveyInstructionJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                    sqlite3_bind_text(statement, 22, surveyInstructionJson.utf8String, -1, nil)
                }
            }
            if let surveyLanguage = survey.surveyLanguage as NSString?{
                sqlite3_bind_text(statement, 23, surveyLanguage.utf8String, -1, nil)
            }
            if let surveyIntroductionText = survey.surveyIntroductionText as NSString?{
                sqlite3_bind_text(statement, 24, surveyIntroductionText.utf8String, -1, nil)
            }
            if let surveyIntroductionUrl = survey.surveyIntroductionUrl as NSString?{
                sqlite3_bind_text(statement, 25, surveyIntroductionUrl.utf8String, -1, nil)
            }
            if let name = survey.name as NSString?{
                sqlite3_bind_text(statement, 26, name.utf8String, -1, nil)
            }
            if let programId = survey.programId{
                sqlite3_bind_int64(statement, 27, sqlite3_int64(programId))
            }
            if let organizationName = survey.organizationName as NSString?{
                sqlite3_bind_text(statement, 28, organizationName.utf8String, -1, nil)
            }
            if let programName = survey.programName as NSString?{
                sqlite3_bind_text(statement, 29, programName.utf8String, -1, nil)
            }
            if let logoURL = survey.logoURL as NSString?{
                sqlite3_bind_text(statement, 30, logoURL.utf8String, -1, nil)
            }
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: survey.pagesJson , options: []) {
                if let pagesJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                    sqlite3_bind_text(statement, 31, pagesJson.utf8String, -1, nil)
                }
            }
            
            if let validity = survey.validity{
                sqlite3_bind_int64(statement, 32, sqlite3_int64(validity))
            }
            if let retakeAllowed = survey.retakeAllowed{
                sqlite3_bind_int64(statement, 33, sqlite3_int64(retakeAllowed))
            }
            if let important = survey.important{
                sqlite3_bind_int64(statement, 34, sqlite3_int64(important))
            }
            if let autoSave = survey.autoSave{
                sqlite3_bind_int64(statement, 35, sqlite3_int64(autoSave))
            }
            if let isUploaded = survey.isUploaded{
                sqlite3_bind_int64(statement, 36, sqlite3_int64(isUploaded))
            }
            
            if let userSurveySessionId = survey.userSurveySessionId{
                sqlite3_bind_int64(statement, 37, sqlite3_int64(userSurveySessionId))
            }
            if let type = survey.type as NSString?{
                sqlite3_bind_text(statement, 38, type.utf8String, -1, nil)
            }
            
            if let code = survey.code as NSString?{
                sqlite3_bind_text(statement, 39, code.utf8String, -1, nil)
            }
            
            if let group = survey.group as NSString?{
                sqlite3_bind_text(statement, 40, group.utf8String, -1, nil)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE{
                success = true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_SURVEY_DATA   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure INSERT_INTO_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return success
    }
    
    //MARK:- INSERT_INTO_MEDIA
    static func insertIntoMedia(media : MediaModel) -> Bool{
        var success = false
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, INSERT_INTO_MEDIA, -1, &statement, nil) == SQLITE_OK {
            if let name = media.name as NSString?{
                sqlite3_bind_text(statement, 1, name.utf8String, -1, nil)
            }
            if let sessionScheduleId = media.sessionScheduleId{
                sqlite3_bind_int64(statement, 2, sqlite3_int64(sessionScheduleId))
            }
            if let questionId = media.questionId{
                sqlite3_bind_int64(statement, 3, sqlite3_int64(questionId))
            }
            if let pageId = media.pageId{
                sqlite3_bind_int64(statement, 4, sqlite3_int64(pageId))
            }
            if let answer = media.answer{
                sqlite3_bind_int64(statement, 5, sqlite3_int64(answer))
            }
            sqlite3_bind_int64(statement, 6, sqlite3_int64(media.isUploaded))
            if let endTime = media.endTime{
                sqlite3_bind_int64(statement, 7, sqlite3_int64(endTime))
            }
            if sqlite3_step(statement) == SQLITE_DONE{
                success = true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_MEDIA   \(errmsg)")
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure INSERT_INTO_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return success
    }
    
    //MARK:- INSERT_INTO_TIMELINE
    static func insertIntoTimeline(timelineArray : [TimelineModel]) -> Bool{
        var success = false
        var statement: OpaquePointer? = nil
        for timeline in timelineArray {
            if sqlite3_prepare_v2(db, INSERT_INTO_TIMELINE, -1, &statement, nil) == SQLITE_OK {
                if let date = timeline.date{
                    sqlite3_bind_int64(statement, 1, sqlite3_int64(date))
                }
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: timeline.eventArrayJson ,
                    options: []) {
                    if let eventArrayJson =  String(data: theJSONData,encoding: .utf8) as NSString?{
                        sqlite3_bind_text(statement, 2, eventArrayJson.utf8String, -1, nil)
                    }
                }
                if sqlite3_step(statement) == SQLITE_DONE{
                    success = true
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    debugPrint("failure INSERT_INTO_TIMELINE   \(errmsg)")
                }
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure INSERT_INTO_TIMELINE   \(errmsg)")
            }
        }
        sqlite3_finalize(statement)
        return success
    }
    
    //MARK:- END INSERT
    //MARK:-
    
   
    
   
    
    
    
    
    
    
    //MARK:-  GET ALL

    //MARK:- GET DATA FROM TABLE
    //MARK:-
    
    
    //MARK:- GET_ALL_SURVEY_SCHEDLUE
    static func getAllSurveySchedules( ) -> [SurveyScheduleDatabaseModel]{
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_SURVEY_SCHEDLUE , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_SURVEY_SCHEDLUE  \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }

    
    //MARK:- GET_COMPLETE_COUNT
    static func getCompleteSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_COMPLETE_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_COMPLETE_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_ALL_UPCOMING_COUNT
    static func getAllUpcomingCount( startTime : Int) -> Int{

        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_UPCOMING_COUNT , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(startTime))
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_UPCOMING_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_ALL_UPCOMING_COUNT
    static func getUnSyncCount() -> Int{
        
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, MESSAGE_TO_UPLOAD_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure MESSAGE_TO_UPLOAD_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        if count != 0 {
            return count
        }
        
        var statement2: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DECLINED_SURVEY_TO_UPLOAD_COUNT , -1, &statement2, nil) == SQLITE_OK {
            while sqlite3_step(statement2) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement2, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DECLINED_SURVEY_TO_UPLOAD_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement2)
        
        if count != 0 {
            return count
        }
        
        var statement3: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, SURVEY_DATA_TO_UPLOAD_COUNT , -1, &statement3, nil) == SQLITE_OK {
            while sqlite3_step(statement3) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement3, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure SURVEY_DATA_TO_UPLOAD_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement3)
        
        return count
    }
    
    
    //MARK:- GET_EXPIRED_COUNT
    static func getExpiredSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_EXPIRED_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_EXPIRED_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    
    //MARK:- GET_DECLINED_COUNT
    static func getDeclinedSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_DECLINED_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_DECLINED_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_DECLINED_COUNT
    static func getAssignSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ASSIGN_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ASSIGN_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_ACTIVE_COUNT
    static func getActiveSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ACTIVE_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ACTIVE_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_UNSCHEDULED_COUNT
    static func getActiveUnscheduledSurveyCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UNSCHEDULED_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_UNSCHEDULED_COUNT   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    
    
    //MARK:- GET_ALL_SURVEY_FOR_LOCAL_NOTIFICATION 
    static func getAllSurveyForNotificationSchedules() -> [SurveyScheduleDatabaseModel]{
        let newDate = Date()
        let toDate = Calendar.current.date(byAdding: .day, value: 10, to: newDate)
        let fromEpoch = (newDate.timeIntervalSince1970) * 1000
        let toEpoch = ((toDate?.timeIntervalSince1970)! - 1) * 1000
        var language = "EN"
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            language =  languageCode
        }
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UPCOMING_WEEK_DRO , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(fromEpoch))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(toEpoch))
            sqlite3_bind_text(statement, 3, (language as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))
                
                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_SURVEY_SCHEDLUE  \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }
    
    
    //MARK:- GET_ALL_SURVEY_SCHEDLUE Name
    static func getAllSurveySchedules( startTime: Int , endTime :Int ) -> [SurveyScheduleDatabaseModel]{
        
        var language = "EN"
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            language =  languageCode
        }
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_SURVEY_SCHEDLUE_BETWEEN , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(startTime))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(endTime))
            sqlite3_bind_text(statement, 3, (language as NSString).utf8String, -1, nil)

            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))

                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_SURVEY_SCHEDLUE  \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }
    
    //MARK:- GET_SURVEY_SCHEDLUE
    static func getSurveySchedules(surveySessionId: Int ) -> SurveyScheduleDatabaseModel?{
        
        var surveySchedule : SurveyScheduleDatabaseModel?
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_SURVEY_SCHEDLUE , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(surveySessionId))
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedule = surveySchedules
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_SURVEY_SCHEDLUE  \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedule
    }
    
    //MARK:- GET_TODAY_SURVEY_SCHEDLUE
    static func getTodaySurveySchedules() -> [SurveyScheduleDatabaseModel] {
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_TODAY_SURVEY_SCHEDLUE , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_TODAY_SURVEY_SCHEDLUE  \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }
    
    
    
    
    //MARK:- GET_VIEW_DRO
    static func getViewDro( startTime: Int , query : String , count : Int ) -> [SurveyScheduleDatabaseModel]{
        let queryString = GET_VIEW_DRO + query + "limit \(count)"
        var language = "EN"
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            language =  languageCode
        }
        
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(startTime))
            sqlite3_bind_text(statement, 2, (language as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_VIEW_DRO   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }

    //MARK:- GET_DUE_TODAY
    static func getDueToday(startTime: Int ) -> [SurveyScheduleDatabaseModel]{
        var today = Int(Date().timeIntervalSince1970)
        today  += TimeZone.current.secondsFromGMT()
        
        var language = "EN"
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            language =  languageCode
        }
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_DUE_TODAY , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(today * 1000))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(startTime - 86400000))
            sqlite3_bind_int64(statement, 3, sqlite3_int64(startTime - 1000))
            sqlite3_bind_text(statement, 4, (language as NSString).utf8String, -1, nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_DUE_TODAY   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }
    
    //MARK:- GET_UPCOMING
    static func getUpcoming( startTime: Int ) -> [SurveyScheduleDatabaseModel]{
        var today = Int(Date().timeIntervalSince1970)
        today  += TimeZone.current.secondsFromGMT()
        var language = "EN"
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            language =  languageCode
        }
        
        var surveySchedulesArray = [SurveyScheduleDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UPCOMING , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(today * 1000))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(startTime))
            sqlite3_bind_text(statement, 3, (language as NSString).utf8String, -1, nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySchedules = SurveyScheduleDatabaseModel()
                surveySchedules.surveyDate = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 0)  ))
                surveySchedules.sessionCount = Int(sqlite3_column_int64(statement, 1))
                surveySchedules.startTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 2 )  ))
                surveySchedules.endTime =  CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 3) ))
                surveySchedules.surveyID = Int(sqlite3_column_int64(statement, 4))
                surveySchedules.isPriority = Int(sqlite3_column_int64(statement, 5))
                if  let surveyName =  sqlite3_column_text(statement, 6) {
                    surveySchedules.surveyName = String(cString: surveyName)
                }
                surveySchedules.surveySessionId = Int(sqlite3_column_int64(statement, 7))
                surveySchedules.percentageCompleted = sqlite3_column_double(statement, 8)
                if  let progressStatus =  sqlite3_column_text(statement, 9) {
                    surveySchedules.progressStatus = String(cString: progressStatus)
                }
                surveySchedules.timeSpent = Int(sqlite3_column_int64(statement, 10))
                surveySchedules.isDeclined = Int(sqlite3_column_int64(statement, 11))
                surveySchedules.programSurveyId = Int(sqlite3_column_int64(statement, 12))
                if  let surveyLanguage =  sqlite3_column_text(statement, 13) {
                    surveySchedules.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let scheduleType =  sqlite3_column_text(statement, 14) {
                    surveySchedules.scheduleType = String(cString: scheduleType)
                }
                surveySchedules.actualEndTime = CommonMethods.utcToLocalEpoch(utcDateEpoch: Int(sqlite3_column_int64(statement, 15) ))

                surveySchedulesArray.append(surveySchedules)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_UPCOMING   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySchedulesArray
    }
    
    //MARK:- GET_ALL_VIEW_DRO
    static func getAllViewDro( ) -> [DroInfoListModel]{
        var droInfoListArray = [DroInfoListModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_VIEW_DRO , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let droInfoList = DroInfoListModel()
                droInfoList.declined = Int(sqlite3_column_int64(statement, 0))
                droInfoList.timeSpent = Int(sqlite3_column_int64(statement, 1))
                if  let name =  sqlite3_column_text(statement, 2) {
                    droInfoList.name = String(cString: name)
                }
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    droInfoList.progressStatus = String(cString: progressStatus)
                }
                droInfoList.percentageCompleted = sqlite3_column_double(statement, 4)
                if  let scheduleType =  sqlite3_column_text(statement, 5) {
                    droInfoList.scheduleType = String(cString: scheduleType)
                }
                droInfoList.endTime = CommonMethods.utcToLocalEpoch(utcDateEpoch:Int(sqlite3_column_int64(statement, 6)  ))
                
                droInfoListArray.append(droInfoList)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_VIEW_DRO   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return droInfoListArray
    }
    
    

    //MARK:- GET_ALL_MESSAGE
    static func getAllMessage(_ query : String , count : Int ) -> [MessageModel]{
        var messageArray = [MessageModel]()
        let queryString = GET_ALL_MESSAGE + query + "limit \(count)"

        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let message = MessageModel()
                message.createTime = Int(sqlite3_column_int64(statement, 0))
                message.id = Int(sqlite3_column_int64(statement, 1))
                message.isStarred = Int(sqlite3_column_int64(statement, 2))
                if  let messageTile =  sqlite3_column_text(statement, 3) {
                    message.messageTile = String(cString: messageTile)
                }
                if  let readStatus =  sqlite3_column_text(statement, 4) {
                    message.readStatus = String(cString: readStatus)
                }
                if  let senderName =  sqlite3_column_text(statement, 5) {
                    message.senderName = String(cString: senderName)
                }
                if  let textMessage =  sqlite3_column_text(statement, 6) {
                    message.textMessage = String(cString: textMessage)
                }
                
                message.userId = Int(sqlite3_column_int64(statement, 7))

                
                messageArray.append(message)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_MESSAGE   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return messageArray
    }
    
    
    //MARK:- GET_UNREAD_MESSAGE_COUNT
    static func getUnreadMessageCount() -> Int{
        var count = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UNREAD_MESSAGE_COUNT , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                count = Int(sqlite3_column_int64(statement, 0))
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_UNREAD_MESSAGE_COUNT \(errmsg)")
        }
        sqlite3_finalize(statement)
        return count
    }
    
    //MARK:- GET_ALL_MESSAGE_TO_UPLOAD
    static func getAllMessageToUpload() -> [MessageModel]{
        var messageArray = [MessageModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_MESSAGE_TO_UPLOAD , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let message = MessageModel()
                message.createTime = Int(sqlite3_column_int64(statement, 0))
                message.id = Int(sqlite3_column_int64(statement, 1))
                message.isStarred = Int(sqlite3_column_int64(statement, 2))
                if  let messageTile =  sqlite3_column_text(statement, 3) {
                    message.messageTile = String(cString: messageTile)
                }
                if  let readStatus =  sqlite3_column_text(statement, 4) {
                    message.readStatus = String(cString: readStatus)
                }
                if  let senderName =  sqlite3_column_text(statement, 5) {
                    message.senderName = String(cString: senderName)
                }
                if  let textMessage =  sqlite3_column_text(statement, 6) {
                    message.textMessage = String(cString: textMessage)
                }
                message.userId = Int(sqlite3_column_int64(statement, 7))
                messageArray.append(message)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_MESSAGE_TO_UPLOAD   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return messageArray
    }
    
    //MARK:- GET_ALL_MESSAGE_BETWEEN
    static func getAllMessage( startTime: Int , endTime :Int ) -> [MessageModel]{
        var messageArray = [MessageModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_MESSAGE_BETWEEN , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(startTime))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(endTime))
            while sqlite3_step(statement) == SQLITE_ROW{
                let message = MessageModel()
                message.createTime = Int(sqlite3_column_int64(statement, 0))
                message.id = Int(sqlite3_column_int64(statement, 1))
                message.isStarred = Int(sqlite3_column_int64(statement, 2))
                if  let messageTile =  sqlite3_column_text(statement, 3) {
                    message.messageTile = String(cString: messageTile)
                }
                if  let readStatus =  sqlite3_column_text(statement, 4) {
                    message.readStatus = String(cString: readStatus)
                }
                if  let senderName =  sqlite3_column_text(statement, 5) {
                    message.senderName = String(cString: senderName)
                }
                if  let textMessage =  sqlite3_column_text(statement, 6) {
                    message.textMessage = String(cString: textMessage)
                }
                message.userId = Int(sqlite3_column_int64(statement, 7))
                messageArray.append(message)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_MESSAGE_BETWEEN   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return messageArray
    }

    
    
    
    
    //MARK:- GET_ALL_CONFIG of type
    static func getAllConfig(_ type: String ) -> [ConfigDatabaseModel]{
        var configArray = [ConfigDatabaseModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_CONFIG , -1, &statement, nil) == SQLITE_OK {
            
           sqlite3_bind_text(statement, 1, (type as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let config = ConfigDatabaseModel()
                if  let name =  sqlite3_column_text(statement, 0) {
                    config.name = String(cString: name)
                }
                if  let type =  sqlite3_column_text(statement, 1) {
                    config.type = String(cString: type)
                }
                if  let lastVisitedDate =  sqlite3_column_text(statement, 2) {
                    config.lastVisitedDate = String(cString: lastVisitedDate)
                }
                if  let fieldType =  sqlite3_column_text(statement, 3) {
                    config.fieldType = String(cString: fieldType)
                }
                if  let header =  sqlite3_column_text(statement, 4) {
                    config.header = String(cString: header)
                }
                if  let descriptions =  sqlite3_column_text(statement, 5) {
                    config.descriptions = String(cString: descriptions)
                }
                config.masterBankId = Int(sqlite3_column_int64(statement, 6))

                if  let url =  sqlite3_column_text(statement, 7) {
                    config.url = String(cString: url)
                }
                if  let urlType =  sqlite3_column_text(statement, 8) {
                    config.urlType = String(cString: urlType)
                }
                if  let valuesData =  sqlite3_column_text(statement, 9) {
                    
                   let values = String(cString: valuesData)
                    config.valuesArray = values.components(separatedBy: "%#")
                }
                config.fieldId = Int(sqlite3_column_int64(statement, 10))

                if  let text =  sqlite3_column_text(statement, 11) {
                    config.text = String(cString: text)
                }
                if  let componentType =  sqlite3_column_text(statement, 12) {
                    config.componentType = String(cString: componentType)
                }
                if  let placeHolder =  sqlite3_column_text(statement, 13) {
                    config.placeHolder = String(cString: placeHolder)
                }
                configArray.append(config)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_CONFIG   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return configArray
    }

    
    //MARK:- GET_ALL_LANGUAGE of type
    static func getAllLanguage() -> [LanguageModel]{
        var languageArray = [LanguageModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_LANGUAGE , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let language = LanguageModel()
                language.id = Int(sqlite3_column_int64(statement, 0))

                if  let code =  sqlite3_column_text(statement, 1) {
                    language.code = String(cString: code)
                }
                if  let desc =  sqlite3_column_text(statement, 2) {
                    language.desc = String(cString: desc)
                }
                if  let languag =  sqlite3_column_text(statement, 3) {
                    let languageString = String(cString: languag)
                    if let data = languageString.data(using: .utf8) {
                        do {
                            if let languageJsonData =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                language.languageJson = languageJsonData
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                languageArray.append(language)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_LANGUAGE   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return languageArray
    }
    
    
    
    //MARK:- GET_ALL_LANGUAGE_FOR_ID
    static func getAllLanguage(_ id: Int ) -> [LanguageModel]{
        var languageArray = [LanguageModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_LANGUAGE_FOR_ID , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(id))
            while sqlite3_step(statement) == SQLITE_ROW{
                let language = LanguageModel()
                language.id = Int(sqlite3_column_int64(statement, 0))
                
                if  let code =  sqlite3_column_text(statement, 1) {
                    language.code = String(cString: code)
                }
                if  let desc =  sqlite3_column_text(statement, 2) {
                    language.desc = String(cString: desc)
                }
                
                if  let languag =  sqlite3_column_text(statement, 3) {
                    let languageString = String(cString: languag)
                    if let data = languageString.data(using: .utf8) {
                        do {
                            if let languageJsonData =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                language.languageJson = languageJsonData
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                languageArray.append(language)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_LANGUAGE_FOR_ID   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return languageArray
    }
    
    
    //MARK:- GET_ALL_LANGUAGE_FOR_CODE
    static func getAllLanguage(_ code: String ) -> LanguageModel{
        let language = LanguageModel()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_LANGUAGE_FOR_CODE , -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, (code as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW{
                language.id = Int(sqlite3_column_int64(statement, 0))
                
                if  let code =  sqlite3_column_text(statement, 1) {
                    language.code = String(cString: code)
                }
                if  let desc =  sqlite3_column_text(statement, 2) {
                    language.desc = String(cString: desc)
                }
                if  let languag =  sqlite3_column_text(statement, 3) {
                    let languageString = String(cString: languag)
                    if let data = languageString.data(using: .utf8) {
                        do {
                            if let languageJsonData =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                language.languageJson = languageJsonData
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_LANGUAGE_FOR_CODE   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return language
    }
    
    

    
    
    //MARK:- GET_ALL_DECLINED_REASON
    static func getAllDeclinedReason() -> [DeclinedModel]{
        var declinedReasonArray = [DeclinedModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_DECLINED_REASON , -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let delinedReason = DeclinedModel()
                delinedReason.declineReasonId = Int(sqlite3_column_int64(statement, 0))
                if  let declineReason =  sqlite3_column_text(statement, 1) {
                    delinedReason.declineReason = String(cString: declineReason)
                }
                declinedReasonArray.append(delinedReason)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_DECLINED_REASON   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return declinedReasonArray
    }

    
    //MARK:- GET_ALL_DECLINED_SURVEY of type
    static func getAllDeclinedSurvey() -> [DeclinedSurveyModel]{
        var declinedSurveyArray = [DeclinedSurveyModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_DECLINED_SURVEY , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let declinedSurvey = DeclinedSurveyModel()
                declinedSurvey.declineReasonId = Int(sqlite3_column_int64(statement, 0))
                declinedSurvey.declineTime = Int(sqlite3_column_int64(statement, 1))
                declinedSurvey.userSurveySessionId = Int(sqlite3_column_int64(statement, 2))
                declinedSurvey.isUploaded = Int(sqlite3_column_int64(statement, 3))

                declinedSurveyArray.append(declinedSurvey)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_DECLINED_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return declinedSurveyArray
    }
    
    //MARK:- GET_SURVEY of type
    static func getSurvey(surveyId :Int) -> SurveySubmitModel{
        let surveySubmit = SurveySubmitModel()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_SURVEY , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(surveyId))

            while sqlite3_step(statement) == SQLITE_ROW{
                surveySubmit.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit.progressStatus = String(cString: progressStatus)
                }
                surveySubmit.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit.scheduleType = String(cString: scheduleType)
                }
                surveySubmit.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pageNavigationJson = dataArray
                                for pageNavigationData in surveySubmit.pageNavigationJson{
                                    let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                    surveySubmit.pageNavigationArray.append(pageNavigation)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                surveySubmit.surveyInstructionJson = dataArray
                                for surveyInstructionsData in surveySubmit.surveyInstructionJson{
                                    let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                    surveySubmit.surveyInstructionArray.append(surveyInstruction)
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit.name = String(cString: name)
                }
                surveySubmit.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pagesJson = dataArray
                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit.pagesArray.append(pages)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit.group = String(cString: group)
                }

            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_DECLINED_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySubmit
    }
    
    //MARK:- GET_UNSCHEDULED
    static func getUncheduledSurvey() -> [SurveySubmitModel]{
        var surveySubmitArray = [SurveySubmitModel]()

        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UNSCHEDULED , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySubmit = SurveySubmitModel()

                surveySubmit.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit.progressStatus = String(cString: progressStatus)
                }
                surveySubmit.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit.scheduleType = String(cString: scheduleType)
                }
                surveySubmit.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pageNavigationJson = dataArray
                                for pageNavigationData in surveySubmit.pageNavigationJson{
                                    let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                    surveySubmit.pageNavigationArray.append(pageNavigation)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                surveySubmit.surveyInstructionJson = dataArray
                                for surveyInstructionsData in surveySubmit.surveyInstructionJson{
                                    let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                    surveySubmit.surveyInstructionArray.append(surveyInstruction)
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit.name = String(cString: name)
                }
                surveySubmit.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pagesJson = dataArray
                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit.pagesArray.append(pages)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit.group = String(cString: group)
                }
                surveySubmitArray.append(surveySubmit)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_UNSCHEDULED   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySubmitArray
    }
    
    //MARK:- GET_UNSCHEDULED_OF_SURVEYID
    static func getUncheduledSurveyOfSurveyId(surveyId : Int) -> SurveySubmitModel?{
        var surveySubmit : SurveySubmitModel?
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UNSCHEDULED_OF_SURVEYID , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(surveyId))

            while sqlite3_step(statement) == SQLITE_ROW{
                surveySubmit = SurveySubmitModel()
                
                surveySubmit?.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit?.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit?.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit?.progressStatus = String(cString: progressStatus)
                }
                surveySubmit?.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit?.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit?.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit?.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit?.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit?.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit?.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit?.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit?.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit?.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit?.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit?.scheduleType = String(cString: scheduleType)
                }
                surveySubmit?.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit?.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit?.pageNavigationJson = dataArray
                                if let _ = surveySubmit?.pageNavigationJson {
                                    for pageNavigationData in (surveySubmit?.pageNavigationJson)!{
                                        let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                        surveySubmit?.pageNavigationArray.append(pageNavigation)
                                    }
                                }
                                
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit?.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit?.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit?.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                surveySubmit?.surveyInstructionJson = dataArray
                                if let _ = surveySubmit?.surveyInstructionJson {
                                    
                                    for surveyInstructionsData in (surveySubmit?.surveyInstructionJson)!{
                                        let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                        surveySubmit?.surveyInstructionArray.append(surveyInstruction)
                                    }
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit?.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit?.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit?.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit?.name = String(cString: name)
                }
                surveySubmit?.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit?.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit?.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit?.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit?.pagesJson = dataArray
                                if let _ = surveySubmit?.pagesJson {

                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit?.pagesArray.append(pages)
                                }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit?.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit?.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit?.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit?.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit?.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit?.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit?.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit?.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit?.group = String(cString: group)
                }

            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_UNSCHEDULED_OF_SURVEYID   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySubmit
    }
    
    
    
    //MARK:- GET_SURVEY_DATA of type
    static func getSurveyOfSession(surveySessionId :Int) -> SurveySubmitModel?{
        var survey : SurveySubmitModel?
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_SURVEY_DATA , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(surveySessionId))
            
            while sqlite3_step(statement) == SQLITE_ROW{
               let surveySubmit = SurveySubmitModel()
                surveySubmit.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit.progressStatus = String(cString: progressStatus)
                }
                surveySubmit.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit.scheduleType = String(cString: scheduleType)
                }
                surveySubmit.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pageNavigationJson = dataArray
                                for pageNavigationData in surveySubmit.pageNavigationJson{
                                    let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                    surveySubmit.pageNavigationArray.append(pageNavigation)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            surveySubmit.surveyInstructionJson = dataArray
                                for surveyInstructionsData in surveySubmit.surveyInstructionJson{
                                    let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                    surveySubmit.surveyInstructionArray.append(surveyInstruction)
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit.name = String(cString: name)
                }
                surveySubmit.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pagesJson = dataArray
                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit.pagesArray.append(pages)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit.group = String(cString: group)
                }
                survey = surveySubmit
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return survey
    }
    //MARK:- GET_UNSCHEDULED
    static func getUncheduledIncompleteSurvey(surveyId : Int) -> [SurveySubmitModel]{
        var surveySubmitArray = [SurveySubmitModel]()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_UNSCHEDULED_SURVEY_DATA , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(surveyId))

            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySubmit = SurveySubmitModel()
                
                surveySubmit.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit.progressStatus = String(cString: progressStatus)
                }
                surveySubmit.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit.scheduleType = String(cString: scheduleType)
                }
                surveySubmit.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pageNavigationJson = dataArray
                                for pageNavigationData in surveySubmit.pageNavigationJson{
                                    let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                    surveySubmit.pageNavigationArray.append(pageNavigation)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                surveySubmit.surveyInstructionJson = dataArray
                                for surveyInstructionsData in surveySubmit.surveyInstructionJson{
                                    let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                    surveySubmit.surveyInstructionArray.append(surveyInstruction)
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit.name = String(cString: name)
                }
                surveySubmit.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pagesJson = dataArray
                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit.pagesArray.append(pages)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit.group = String(cString: group)
                }
                surveySubmitArray.append(surveySubmit)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_DECLINED_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySubmitArray
    }
    
    //MARK:- GET_SURVEY_WHICH NOT UPLOADED of type
    static func getSurveyNotUploaded() -> [SurveySubmitModel]{
        var surveySubmitArray = [SurveySubmitModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_SURVEY_DATA_NOT_UPLOADED , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let surveySubmit = SurveySubmitModel()

                surveySubmit.surveySessionId = Int(sqlite3_column_int64(statement, 0))
                surveySubmit.programSurveyId = Int(sqlite3_column_int64(statement, 1))
                surveySubmit.programUserID = Int(sqlite3_column_int64(statement, 2))
                
                if  let progressStatus =  sqlite3_column_text(statement, 3) {
                    surveySubmit.progressStatus = String(cString: progressStatus)
                }
                surveySubmit.percentageComplete = sqlite3_column_double(statement, 4)
                surveySubmit.startTime = Int(sqlite3_column_int64(statement, 5))
                surveySubmit.endTime = Int(sqlite3_column_int64(statement, 6))
                surveySubmit.lastSubmissionTime = Int(sqlite3_column_int64(statement, 7))
                surveySubmit.timeSpent = sqlite3_column_double(statement, 8)
                surveySubmit.lastAnswerPageId = Int(sqlite3_column_int64(statement, 9))
                surveySubmit.declined = Int(sqlite3_column_int64(statement, 10))
                surveySubmit.surveyScheduleId = Int(sqlite3_column_int64(statement, 11))
                surveySubmit.scheduledDate = Int(sqlite3_column_int64(statement,12))
                surveySubmit.scheduledStartTime = Int(sqlite3_column_int64(statement,13))
                surveySubmit.scheduledEndTime = Int(sqlite3_column_int64(statement, 14))
                
                if  let scheduleType =  sqlite3_column_text(statement, 15) {
                    surveySubmit.scheduleType = String(cString: scheduleType)
                }
                surveySubmit.userScheduleAssignId = Int(sqlite3_column_int64(statement, 16))
                surveySubmit.unscheduled = Int(sqlite3_column_int64(statement, 17))
                
                if  let pageNavigation =  sqlite3_column_text(statement, 18) {
                    let pageNavigationString = String(cString: pageNavigation)
                    if let data = pageNavigationString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pageNavigationJson = dataArray
                                for pageNavigationData in surveySubmit.pageNavigationJson{
                                    let pageNavigation = PageNavigations(jsonObject: pageNavigationData)
                                    surveySubmit.pageNavigationArray.append(pageNavigation)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if let userAnswerLogs =  sqlite3_column_text(statement, 19)  {
                    let userAnswerLogsString = String(cString: userAnswerLogs)
                    if let data = userAnswerLogsString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                                surveySubmit.userAnswerLogsJson = dataArray
                                for userAnswerLogsData in dataArray{
                                    let userAnswerLogs = UserAnswerLogs(jsonObject: userAnswerLogsData)
                                    surveySubmit.userAnswerLogsArray.append(userAnswerLogs)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.surveyId = Int(sqlite3_column_int64(statement, 20))
                
                if  let surveyInstruction =  sqlite3_column_text(statement, 21) {
                    let surveyInstructionString = String(cString: surveyInstruction)
                    if let data = surveyInstructionString.data(using: .utf8) {
                        do {
                            
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                surveySubmit.surveyInstructionJson = dataArray
                                for surveyInstructionsData in surveySubmit.surveyInstructionJson{
                                    let surveyInstruction = InstructionModel(jsonObject: surveyInstructionsData)
                                    surveySubmit.surveyInstructionArray.append(surveyInstruction)
                                }
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                if  let surveyLanguage =  sqlite3_column_text(statement, 22) {
                    surveySubmit.surveyLanguage = String(cString: surveyLanguage)
                }
                if  let surveyIntroductionText =  sqlite3_column_text(statement, 23) {
                    surveySubmit.surveyIntroductionText = String(cString: surveyIntroductionText)
                }
                if  let surveyIntroductionUrl =  sqlite3_column_text(statement, 24) {
                    surveySubmit.surveyIntroductionUrl = String(cString: surveyIntroductionUrl)
                }
                if  let name =  sqlite3_column_text(statement, 25) {
                    surveySubmit.name = String(cString: name)
                }
                surveySubmit.programId = Int(sqlite3_column_int64(statement, 26))
                if  let organizationName =  sqlite3_column_text(statement, 27) {
                    surveySubmit.organizationName = String(cString: organizationName)
                }
                if  let programName =  sqlite3_column_text(statement, 28) {
                    surveySubmit.programName = String(cString: programName)
                }
                if  let logoURL =  sqlite3_column_text(statement, 29) {
                    surveySubmit.logoURL = String(cString: logoURL)
                }
                if  let pagesJsonData =  sqlite3_column_text(statement, 30)  {
                    let pagesJsonString = String(cString: pagesJsonData)
                    if let data = pagesJsonString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                surveySubmit.pagesJson = dataArray
                                for pagesData in dataArray{
                                    let pages = PagesModel(jsonObject: pagesData)
                                    surveySubmit.pagesArray.append(pages)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                surveySubmit.validity = Int(sqlite3_column_int64(statement, 31))
                surveySubmit.retakeAllowed = Int(sqlite3_column_int64(statement, 32))
                surveySubmit.important = Int(sqlite3_column_int64(statement, 33))
                surveySubmit.autoSave = Int(sqlite3_column_int64(statement, 34))
                surveySubmit.isUploaded = Int(sqlite3_column_int64(statement, 35))
                surveySubmit.userSurveySessionId = Int(sqlite3_column_int64(statement, 36))
                
                if  let type =  sqlite3_column_text(statement, 37) {
                    surveySubmit.type = String(cString: type)
                }
                if  let code =  sqlite3_column_text(statement, 38) {
                    surveySubmit.code = String(cString: code)
                }
                if  let group =  sqlite3_column_text(statement, 39) {
                    surveySubmit.group = String(cString: group)
                }
                surveySubmitArray.append(surveySubmit)

            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_SURVEY_DATA_NOT_UPLOADED   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return surveySubmitArray
    }
    
    //MARK:- GET_ALL_MEDIA
    static func getAllMedia() -> [MediaModel]{
        var mediaArray = [MediaModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_MEDIA , -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let media = MediaModel()
                if  let name =  sqlite3_column_text(statement, 0) {
                    media.name = String(cString: name)
                }
                media.sessionScheduleId = Int(sqlite3_column_int64(statement, 1))
                media.questionId = Int(sqlite3_column_int64(statement, 2))
                media.pageId = Int(sqlite3_column_int64(statement, 3))
                media.answer = Int(sqlite3_column_int64(statement, 4))
                media.isUploaded = Int(sqlite3_column_int64(statement, 5))
                media.endTime = Int(sqlite3_column_int64(statement, 6))

                mediaArray.append(media)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return mediaArray
    }
    
    
    //MARK:- GET_MEDIA
    static func getMedia(_ sessionScheduleId: Int , questionId: Int ) -> MediaModel?{
        
        var media : MediaModel?

        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_MEDIA , -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int64(statement, 1, sqlite3_int64(sessionScheduleId))
            
                sqlite3_bind_int64(statement, 2, sqlite3_int64(questionId))
            while sqlite3_step(statement) == SQLITE_ROW{
                 media = MediaModel()

                if  let name =  sqlite3_column_text(statement, 0) {
                    media?.name = String(cString: name)
                }
                media?.sessionScheduleId = Int(sqlite3_column_int64(statement, 1))
                media?.questionId = Int(sqlite3_column_int64(statement, 2))
                media?.pageId = Int(sqlite3_column_int64(statement, 3))
                media?.answer = Int(sqlite3_column_int64(statement, 4))
                media?.isUploaded = Int(sqlite3_column_int64(statement, 5))
                media?.endTime = Int(sqlite3_column_int64(statement, 6))

            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return media
    }
    
    
    //MARK:- GET_EXPIRE_MEDIA
    static func getExpireMedia(_ endTime: Int  ) -> [MediaModel]{
        
        var mediaArray = [MediaModel]()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_EXPIRE_MEDIA , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(endTime))
            
            while sqlite3_step(statement) == SQLITE_ROW{
                let media = MediaModel()

                if  let name =  sqlite3_column_text(statement, 0) {
                    media.name = String(cString: name)
                }
                media.sessionScheduleId = Int(sqlite3_column_int64(statement, 1))
                media.questionId = Int(sqlite3_column_int64(statement, 2))
                media.pageId = Int(sqlite3_column_int64(statement, 3))
                media.answer = Int(sqlite3_column_int64(statement, 4))
                media.isUploaded = Int(sqlite3_column_int64(statement, 5))
                media.endTime = Int(sqlite3_column_int64(statement, 6))
                mediaArray.append(media)
                
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_EXPIRE_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return mediaArray
    }
    
    //MARK:- GET_MEDIA_OF_SESSION
    static func getMediaOfSession(_ sessionScheduleId: Int ) -> [MediaModel]{
        var mediaArray = [MediaModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_MEDIA_OF_SESSION , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(sessionScheduleId))
            while sqlite3_step(statement) == SQLITE_ROW{
                let media = MediaModel()
                if  let name =  sqlite3_column_text(statement, 0) {
                    media.name = String(cString: name)
                }
                media.sessionScheduleId = Int(sqlite3_column_int64(statement, 1))
                media.questionId = Int(sqlite3_column_int64(statement, 2))
                media.pageId = Int(sqlite3_column_int64(statement, 3))
                media.answer = Int(sqlite3_column_int64(statement, 4))
                media.isUploaded = Int(sqlite3_column_int64(statement, 5))
                media.endTime = Int(sqlite3_column_int64(statement, 6))

                mediaArray.append(media)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_MEDIA_OF_SESSION   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return mediaArray
    }
    
    
    //MARK:- GET_ALL_TIMELINE
    static func getAllTimeline( ) -> [TimelineModel]{
        var timelineArray = [TimelineModel]()
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_TIMELINE , -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let timeline = TimelineModel()
              
                timeline.date = Int(sqlite3_column_int64(statement, 0))
                if  let eventArray =  sqlite3_column_text(statement, 1) {
                    let eventArrayString = String(cString: eventArray)
                    if let data = eventArrayString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                timeline.eventArrayJson = dataArray
                                for data in dataArray{
                                    let event = EventModel(jsonObject: data)
                                    timeline.eventArray.append(event)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }

                timelineArray.append(timeline)
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_TIMELINE   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return timelineArray
    }
    
    //MARK:- GET_ALL_TIMELINE
    static func getTimelineOfDate(date : Int ) -> TimelineModel?{
        var timeline : TimelineModel?
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, GET_ALL_TIMELINE , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(date))
            while sqlite3_step(statement) == SQLITE_ROW{
                timeline = TimelineModel()
                timeline?.date = Int(sqlite3_column_int64(statement, 0))
                if  let eventArray =  sqlite3_column_text(statement, 1) {
                    let eventArrayString = String(cString: eventArray)
                    if let data = eventArrayString.data(using: .utf8) {
                        do {
                            if let dataArray =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                timeline?.eventArrayJson = dataArray
                                for data in dataArray{
                                    let event = EventModel(jsonObject: data)
                                    timeline?.eventArray.append(event)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure GET_ALL_TIMELINE   \(errmsg)")
        }
        sqlite3_finalize(statement)
        return timeline
    }
    
    //MARK:- END GET ALL
  //MARK:-
    
    


    //MARK:-  DELETE

    //MARK:- DELETE ALL TABLE DATA

    static func deleteAllTableData(){
        deleteAllSurveySchedule()
        deleteAllViewDro()
        deleteAllMessage()
        deleteAllConfig()
        deleteAllLanguage()
        deleteAllDeclinedReason()
        deleteAllDeclinedSurvey()
        deleteAllSurvey()
        deleteAllSurveyData()
        deleteAllMedia()
        deleteAllTimeline()
        
    }
    
    //MARK:- DELETE_ALL_SURVEY_SCHEDLUE

    static func deleteAllSurveySchedule()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_SURVEY_SCHEDLUE, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_SURVEY_SCHEDLUE   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_SURVEY_SCHEDLUE   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
       // sqlite3_close(db)
        
    }
    //MARK:- DELETE_ALL_VIEW_DRO
    
    static func deleteAllViewDro()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_VIEW_DRO, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_VIEW_DRO   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_VIEW_DRO   \(errmsg)")        }
        sqlite3_finalize(insertStatement)
        
    }
    
    //MARK:- DELETE_ALL_MESSAGE
    
    static func deleteAllMessage()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_MESSAGE , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_MESSAGE   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_MESSAGE   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_MESSAGE
    
    static func deleteAllConfig()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_CONFIG , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("DELETE_ALL_CONFIG Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_CONFIG   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_CONFIG   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_LANGUAGE
    
    static func deleteAllLanguage()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_LANGUAGE , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_LANGUAGE   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_LANGUAGE   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_DECLINED_REASON
    
    static func deleteAllDeclinedReason()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_DECLINED_REASON , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("DELETE_ALL_DECLINED_REASON Successfully Done")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_DECLINED_REASON   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_DECLINED_REASON   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_DECLINED_SURVEY
    
    static func deleteDeclinedSurvey()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_DECLINED_SURVEY , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_DECLINED_SURVEY Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_DECLINED_SURVEY   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_DECLINED_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_DECLINED_SURVEY
    
    static func deleteAllDeclinedSurvey()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_DECLINED_SURVEY , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_ALL_DECLINED_SURVEY Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_DECLINED_SURVEY   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_DECLINED_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_SURVEY
    
    static func deleteSurvey(surveyId :Int)  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_SURVEY , -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int64(insertStatement, 1, sqlite3_int64(surveyId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_SURVEY Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_SURVEY   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }

    //MARK:- DELETE_ALL_SURVEY
    
    static func deleteAllSurvey()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_SURVEY , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_ALL_SURVEY Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_SURVEY   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    
    
    
    //MARK:- DELETE_SURVEY_DATA
    
    static func deleteSurveyOfSession(surveySessionId :Int)  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_SURVEY_DATA , -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int64(insertStatement, 1, sqlite3_int64(surveySessionId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_SURVEY_DATA Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_SURVEY_DATA   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_SURVEY_DATA
    
    static func deleteAllSurveyData()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_SURVEY_DATA , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_ALL_SURVEY_DATA Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_SURVEY_DATA   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_SURVEY_UPLOADED
    
    static func deleteAllUploadedSurvey(endTime :Int )  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_SURVEY_UPLOADED , -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int64(insertStatement, 1, sqlite3_int64(endTime))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_SURVEY_UPLOADED Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_SURVEY_UPLOADED   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_SURVEY_UPLOADED   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_ALL_MEDIA
    
    static func deleteAllMedia()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_MEDIA , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_ALL_MEDIA Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_MEDIA   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_MEDIA   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- DELETE_MEDIA_OF_SESSION
    
    static func deleteMediaOfSession(_ sessionScheduleId: Int , questionId: Int )  {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_MEDIA_OF_SESSION , -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_int64(statement, 1, sqlite3_int64(sessionScheduleId))
            sqlite3_bind_int64(statement, 2, sqlite3_int64(questionId))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                debugPrint(" DELETE_MEDIA_OF_SESSION Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_MEDIA_OF_SESSION   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_MEDIA_OF_SESSION   \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //MARK:- DELETE_ALL_TIMELINE
    
    static func deleteAllTimeline()  {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, DELETE_ALL_TIMELINE , -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint(" DELETE_ALL_TIMELINE Successfully ")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure DELETE_ALL_TIMELINE   \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure DELETE_ALL_TIMELINE   \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- END DELETE

    
    //MARK:- UPDATE
    //MARK:- UPDATE_SURVEY_SCHEDLUE
    

    static func updateSchedule(progressStatus : String , isDeclined :Int , surveySessionId :Int , actualEndTime :Int , percentageCompleted : Double ){
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, UPDATE_SURVEY_SCHEDLUE , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (progressStatus as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(statement, 2, sqlite3_int64(isDeclined))
            sqlite3_bind_double(statement, 3, percentageCompleted)
            sqlite3_bind_int64(statement, 4, sqlite3_int64(actualEndTime))
            sqlite3_bind_int64(statement, 5, sqlite3_int64(surveySessionId))
            
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Success UPDATE_SURVEY_SCHEDLUE")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure UPDATE_SURVEY_SCHEDLUE   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure UPDATE_SURVEY_SCHEDLUE   \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //MARK:- EXPIRE_OLD_SURVEY
    
    static func expireOldSuvey(endTime :Int ){
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, EXPIRE_OLD_SURVEY , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(endTime))         
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Success EXPIRE_OLD_SURVEY")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure EXPIRE_OLD_SURVEY   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure EXPIRE_OLD_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //MARK:- EXPIRE_OLD_UNSCHEDULED_SURVEY
    
    static func expireOldUnsheduledSuvey(endTime :Int ){
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, EXPIRE_OLD_UNSHEDULED_SURVEY , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(endTime))
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Success EXPIRE_OLD_UNSHEDULED_SURVEY")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure EXPIRE_OLD_UNSHEDULED_SURVEY   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure EXPIRE_OLD_UNSHEDULED_SURVEY \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //MARK:- ENABLE_SURVEY
    
    
    static func enableNewSuvey(startTime :Int ){
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, ENABLE_SURVEY , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, sqlite3_int64(startTime))
            
            
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Success ENABLE_SURVEY")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure ENABLE_SURVEY   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure ENABLE_SURVEY   \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    //MARK:- UPDATE_SURVEY_DATA

    static func updateSurveyData(progressStatus : String , isDeclined :Int , surveySessionId :Int ,  percentageCompleted : Double ){
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, UPDATE_SURVEY_DATA , -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (progressStatus as NSString).utf8String, -1, nil)
            
            sqlite3_bind_int64(statement, 2, sqlite3_int64(isDeclined))
            sqlite3_bind_double(statement, 3, percentageCompleted)

            sqlite3_bind_int64(statement, 4, sqlite3_int64(surveySessionId))
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Success UPDATE_SURVEY_DATA")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                debugPrint("failure UPDATE_SURVEY_DATA   \(errmsg)")
            }
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            debugPrint("failure UPDATE_SURVEY_DATA   \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //MARK:- End UPDATE




}



