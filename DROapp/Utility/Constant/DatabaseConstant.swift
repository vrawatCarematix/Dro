
//  Copyright © 2018 Carematix. All rights reserved.
// https://www.sqlite.org/rescode.html

import UIKit

    let UTC_TIMEZONE_IDENTIFIER = "UTC"
    
    let DATABASE_NAME = "dro_app_data.db"

//MARK:- DROAPP
//MARK:- DROAPP New Query

//MARK:- DROAPP SURVEY_SCHEDLUE Query
let CREATE_SURVEY_SCHEDLUE = "CREATE TABLE IF NOT EXISTS SURVEY_SCHEDLUE ( surveyDate INTEGER, sessionCount INTEGER , startTime INTEGER, endTime INTEGER, surveyID INTEGER  , isPriority INTEGER, surveyName TEXT, surveySessionId INTEGER , percentageCompleted INTEGER , progressStatus TEXT , timeSpent INTEGER , isDeclined INTEGER , programSurveyId INTEGER , surveyLanguage  TEXT , scheduleType  TEXT, actualEndTime INTEGER, PRIMARY KEY (surveyID, startTime))"

let INSERT_INTO_SURVEY_SCHEDLUE = "INSERT OR REPLACE INTO SURVEY_SCHEDLUE ( surveyDate , sessionCount  , startTime , endTime , surveyID , isPriority , surveyName , surveySessionId  , percentageCompleted  , progressStatus , timeSpent  , isDeclined , programSurveyId , surveyLanguage , scheduleType , actualEndTime ) values (?, ? , ? , ? , ? , ? , ?, ? , ? , ? , ? , ? , ? , ? , ? , ?) "

let GET_ALL_SURVEY_SCHEDLUE = "SELECT * FROM SURVEY_SCHEDLUE"

let GET_UPCOMING_WEEK_DRO = "SELECT * FROM SURVEY_SCHEDLUE WHERE (startTime BETWEEN ? AND ? )  AND  surveyLanguage = ?"


let GET_SURVEY_SCHEDLUE = "SELECT * FROM SURVEY_SCHEDLUE WHERE surveySessionId = ?"

let GET_TODAY_SURVEY_SCHEDLUE = "SELECT * FROM SURVEY_SCHEDLUE WHERE isDeclined == 0 AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED') "

let GET_COMPLETE_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE ( isDeclined == 0 OR isDeclined IS NULL ) AND progressStatus = 'COMPLETED' "
let GET_EXPIRED_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE ( isDeclined == 0 OR isDeclined IS NULL )  AND progressStatus = 'EXPIRED' "
let GET_DECLINED_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE  isDeclined == 1 "
let GET_ACTIVE_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE  ( isDeclined == 0 OR isDeclined IS NULL ) AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED' ) "
let GET_UNSCHEDULED_COUNT = "SELECT COUNT(*) FROM SURVEY WHERE unscheduled = 1 "


let GET_ASSIGN_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE progressStatus is NOT NULL "


let GET_ALL_SURVEY_SCHEDLUE_BETWEEN = "SELECT * FROM SURVEY_SCHEDLUE WHERE (startTime BETWEEN ? AND ? )  AND scheduleType = 'SCHEDULED' AND surveyLanguage = ? AND ( progressStatus != 'TERMINATED' OR progressStatus is null)"

let UPDATE_SURVEY_SCHEDLUE = "UPDATE SURVEY_SCHEDLUE SET progressStatus = ? , isDeclined = ? , percentageCompleted = ? , actualEndTime = ? WHERE surveySessionId = ? "

let EXPIRE_OLD_SURVEY = "UPDATE SURVEY_SCHEDLUE SET progressStatus = 'EXPIRED' WHERE endTime < ? AND   ( isDeclined == 0  OR isDeclined IS NULL )   AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED' OR progressStatus is null)"

let ENABLE_SURVEY = "UPDATE SURVEY_SCHEDLUE SET progressStatus = 'NOT_STARTED' WHERE startTime < ? AND  progressStatus is null"

let GET_DUE_TODAY = "SELECT * FROM SURVEY_SCHEDLUE WHERE startTime <= ? AND (endTime BETWEEN ? AND ? )  AND surveyLanguage = ? AND ( isDeclined == 0 or isDeclined is null ) AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED')"

let GET_ALL_UPCOMING_COUNT = "SELECT COUNT(*) FROM SURVEY_SCHEDLUE WHERE startTime >= ?"

let GET_UPCOMING = "SELECT * FROM SURVEY_SCHEDLUE WHERE startTime <= ? AND endTime >= ? AND  ( isDeclined == 0 or isDeclined is null )  AND surveyLanguage = ? AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED') "

let GET_VIEW_DRO = "SELECT * FROM SURVEY_SCHEDLUE WHERE startTime < ?  AND surveyLanguage = ? AND "

let DELETE_ALL_SURVEY_SCHEDLUE = "DELETE FROM SURVEY_SCHEDLUE"


//MARK:- DROAPP VIEW_DRO Query

let CREATE_VIEW_DRO = "CREATE TABLE IF NOT EXISTS VIEW_DRO (declined INTEGER, timeSpent INTEGER , name TEXT, progressStatus TEXT, percentageCompleted INTEGER , scheduleType TEXT, endTime INTEGER)"


let INSERT_INTO_VIEW_DRO = "INSERT INTO VIEW_DRO( declined , timeSpent  , name , progressStatus , percentageCompleted , scheduleType , endTime ) SELECT ?, ? , ? , ? , ? , ? , ? WHERE NOT EXISTS(SELECT 1 FROM VIEW_DRO WHERE name = ? AND endTime = ?)"


let GET_ALL_VIEW_DRO = "SELECT * FROM VIEW_DRO"
let GET_ALL_VIEW_DRO_BETWEEN = "SELECT * FROM VIEW_DRO WHERE surveyDate BETWEEN ? AND ? "
let DELETE_ALL_VIEW_DRO = "DELETE FROM VIEW_DRO"

//MARK:- DROAPP MESSAGE Query
let CREATE_MESSAGE = "CREATE TABLE IF NOT EXISTS MESSAGE (createTime INTEGER, id INTEGER PRIMARY KEY NOT NULL , isStarred INTEGER, messageTile TEXT, readStatus TEXT , senderName TEXT, textMessage TEXT, userId INTEGER , isUploaded INTEGER )"

let UPDATE_MESSAGE = "UPDATE MESSAGE SET isStarred = ? , isUploaded = 0 WHERE id = ?"

let INSERT_INTO_MESSAGE = "INSERT OR REPLACE INTO MESSAGE( createTime , id , isStarred , messageTile , readStatus  , senderName , textMessage , userId , isUploaded) VALUES ( ?, ? , ? , ? , ? , ? , ? , ? , ? )"

let GET_ALL_MESSAGE = "SELECT * FROM MESSAGE WHERE"
let GET_ALL_MESSAGE_TO_UPLOAD = "SELECT * FROM MESSAGE WHERE ( isUploaded = 0 OR isUploaded is null)"
let GET_UNREAD_MESSAGE_COUNT = "SELECT COUNT(*) FROM MESSAGE WHERE readStatus = 'UNREAD' "
let MESSAGE_TO_UPLOAD_COUNT = "SELECT COUNT(*) FROM MESSAGE WHERE ( isUploaded = 0 OR isUploaded is null)"

//let GET_UNREAD_MESSAGE_COUNT = "SELECT COUNT(*) FROM MESSAGE WHERE isStarred = 1 "
let GET_ALL_MESSAGE_BETWEEN = "SELECT * FROM MESSAGE WHERE createTime BETWEEN ? AND ? "
let DELETE_ALL_MESSAGE = "DELETE FROM MESSAGE"


//MARK:- DROAPP CONFIG Query

let CREATE_CONFIG = "CREATE TABLE IF NOT EXISTS CONFIG (name TEXT, type TEXT , lastVisitedDate TEXT, fieldType TEXT, header TEXT , descriptions TEXT , masterBankId INTEGER , url TEXT , urlType TEXT , valuesArray TEXT , fieldId INTEGER PRIMARY KEY NOT NULL , text TEXT , componentType TEXT , placeHolder TEXT )"

let INSERT_INTO_CONFIG = "INSERT OR REPLACE INTO CONFIG( name , type , lastVisitedDate , fieldType , header  , descriptions , masterBankId , url , urlType , valuesArray , fieldId , text  , componentType , placeHolder ) VALUES ( ?, ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? )"

let GET_ALL_CONFIG = "SELECT * FROM CONFIG WHERE type == ?"
let DELETE_ALL_CONFIG = "DELETE FROM CONFIG"



//MARK:- DROAPP LANGUAGE Query

let CREATE_LANGUAGE = "CREATE TABLE IF NOT EXISTS LANGUAGE (id INTEGER  , code TEXT PRIMARY KEY NOT NULL , desc TEXT , languageJson TEXT )"

let INSERT_INTO_LANGUAGE = "INSERT OR REPLACE INTO LANGUAGE( id , code , desc , languageJson ) VALUES ( ?, ? , ? , ? )"

let GET_ALL_LANGUAGE = "SELECT * FROM LANGUAGE "
let GET_ALL_LANGUAGE_FOR_ID = "SELECT * FROM LANGUAGE where ID = ?"
let GET_ALL_LANGUAGE_FOR_CODE = "SELECT * FROM LANGUAGE where CODE = ?"
let DELETE_ALL_LANGUAGE = "DELETE FROM LANGUAGE"



//MARK:- DROAPP Decline Reason Query

let CREATE_DECLINED_REASON = "CREATE TABLE IF NOT EXISTS DECLINED_REASON (declineReasonId INTEGER PRIMARY KEY NOT NULL , declineReason TEXT)"

let INSERT_INTO_DECLINED_REASON = "INSERT OR REPLACE INTO DECLINED_REASON( declineReasonId , declineReason  ) VALUES ( ?, ? )"

let GET_ALL_DECLINED_REASON = "SELECT * FROM DECLINED_REASON "
let DELETE_ALL_DECLINED_REASON = "DELETE FROM DECLINED_REASON"


//MARK:- DROAPP DECLINED SURVEY Query

let CREATE_DECLINED_SURVEY = "CREATE TABLE IF NOT EXISTS DECLINED_SURVEY (declineReasonId INTEGER , declineTime INTEGER , userSurveySessionId INTEGER PRIMARY KEY NOT NULL , isUploaded INTEGER )"

let INSERT_INTO_DECLINED_SURVEY = "INSERT OR REPLACE INTO DECLINED_SURVEY( declineReasonId , declineTime , userSurveySessionId , isUploaded) VALUES ( ?, ? , ? , ? )"

let GET_ALL_DECLINED_SURVEY = "SELECT * FROM DECLINED_SURVEY WHERE ( isUploaded = 0 OR isUploaded is null)"
let DECLINED_SURVEY_TO_UPLOAD_COUNT = "SELECT COUNT(*) FROM DECLINED_SURVEY WHERE ( isUploaded = 0 OR isUploaded is null)"

let DELETE_DECLINED_SURVEY = "DELETE FROM DECLINED_SURVEY WHERE ( isUploaded = 0 OR isUploaded is null)"

let DELETE_ALL_DECLINED_SURVEY = "DELETE FROM DECLINED_SURVEY"

//MARK:- DROAPP  SURVEY Query

let CREATE_SURVEY = "CREATE TABLE IF NOT EXISTS SURVEY (surveySessionId INTEGER , programSurveyId INTEGER , programUserID INTEGER ,progressStatus TEXT , percentageComplete INTEGER , startTime INTEGER ,endTime INTEGER , lastSubmissionTime INTEGER , timeSpent INTEGER ,lastAnswerPageId INTEGER , declined INTEGER , surveyScheduleId INTEGER ,scheduledDate INTEGER , scheduledStartTime INTEGER , scheduledEndTime INTEGER ,scheduleType TEXT , userScheduleAssignId INTEGER , unscheduled INTEGER ,pageNavigations TEXT , userAnswerLogs TEXT , surveyId INTEGER ,surveyInstructionArray TEXT , surveyLanguage TEXT , surveyIntroductionText TEXT ,surveyIntroductionUrl TEXT , name TEXT , programId INTEGER ,organizationName TEXT , programName TEXT , logoURL TEXT , pages TEXT , validity INTEGER , retakeAllowed INTEGER , important INTEGER , autoSave INTEGER , isUploaded INTEGER , userSurveySessionId INTEGER , type TEXT , code TEXT , groups TEXT , PRIMARY KEY (surveyId, surveyLanguage))"

let INSERT_INTO_SURVEY = "INSERT OR REPLACE INTO SURVEY( surveySessionId  , programSurveyId  , programUserID ,progressStatus  , percentageComplete  , startTime ,endTime  , lastSubmissionTime  , timeSpent ,lastAnswerPageId  , declined  , surveyScheduleId ,scheduledDate  , scheduledStartTime  , scheduledEndTime  , scheduleType  , userScheduleAssignId  , unscheduled ,pageNavigations  , userAnswerLogs  , surveyId ,surveyInstructionArray  , surveyLanguage  , surveyIntroductionText ,surveyIntroductionUrl  , name  , programId ,organizationName  , programName  , logoURL  , pages , validity  , retakeAllowed , important  , autoSave , isUploaded , userSurveySessionId , type , code , groups  ) VALUES ( ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ? , ? , ? , ? , ? , ? , ? , ? , ? , ?)"

let GET_SURVEY = "SELECT * FROM SURVEY WHERE surveyId = ? "
let GET_UNSCHEDULED = "SELECT * FROM SURVEY WHERE unscheduled = 1 "
let GET_UNSCHEDULED_OF_SURVEYID = "SELECT * FROM SURVEY WHERE unscheduled = 1 AND surveyId = ? "

let DELETE_SURVEY = "DELETE FROM SURVEY WHERE surveyId = ?"
let DELETE_ALL_SURVEY = "DELETE FROM SURVEY"

//MARK:- DROAPP SURVEY_DATA Query

let CREATE_SURVEY_DATA = "CREATE TABLE IF NOT EXISTS SURVEY_DATA (surveySessionId INTEGER PRIMARY KEY NOT NULL , programSurveyId INTEGER , programUserID INTEGER ,progressStatus TEXT , percentageComplete INTEGER , startTime INTEGER ,endTime INTEGER , lastSubmissionTime INTEGER , timeSpent INTEGER ,lastAnswerPageId INTEGER , declined INTEGER , surveyScheduleId INTEGER ,scheduledDate INTEGER , scheduledStartTime INTEGER , scheduledEndTime INTEGER ,scheduleType TEXT , userScheduleAssignId INTEGER , unscheduled INTEGER ,pageNavigations TEXT , userAnswerLogs TEXT , surveyId INTEGER ,surveyInstructionArray TEXT , surveyLanguage TEXT , surveyIntroductionText TEXT ,surveyIntroductionUrl TEXT , name TEXT , programId INTEGER ,organizationName TEXT , programName TEXT , logoURL TEXT , pages TEXT , validity INTEGER , retakeAllowed INTEGER , important INTEGER , autoSave INTEGER , isUploaded INTEGER , userSurveySessionId INTEGER , type TEXT, code TEXT, groups TEXT )"

let INSERT_INTO_SURVEY_DATA = "INSERT OR REPLACE INTO SURVEY_DATA( surveySessionId  , programSurveyId  , programUserID  , progressStatus  , percentageComplete  , startTime ,endTime  , lastSubmissionTime  , timeSpent  , lastAnswerPageId  , declined  , surveyScheduleId ,scheduledDate  , scheduledStartTime  , scheduledEndTime  , scheduleType  , userScheduleAssignId  , unscheduled ,pageNavigations  , userAnswerLogs  , surveyId  , surveyInstructionArray  , surveyLanguage  , surveyIntroductionText  , surveyIntroductionUrl , name , programId , organizationName  , programName  , logoURL  , pages , validity  , retakeAllowed , important  , autoSave , isUploaded , userSurveySessionId , type , code , groups ) VALUES ( ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ?, ? , ? ,  ? , ? , ? , ? , ? , ? , ? , ? , ? , ? )"

let GET_SURVEY_DATA = "SELECT * FROM SURVEY_DATA WHERE surveySessionId = ?"
let GET_SURVEY_DATA_NOT_UPLOADED = "SELECT * FROM SURVEY_DATA WHERE ( isUploaded = 0 OR isUploaded  is null)  AND ( progressStatus = 'STARTED' OR progressStatus = 'COMPLETED') AND ( declined = 0 OR declined is null) "

let SURVEY_DATA_TO_UPLOAD_COUNT = "SELECT COUNT(*) FROM SURVEY_DATA WHERE ( isUploaded = 0 OR isUploaded  is null)  AND ( progressStatus = 'STARTED' OR progressStatus = 'COMPLETED') AND ( declined = 0 OR declined is null)"


let UPDATE_SURVEY_DATA = "UPDATE SURVEY_DATA SET progressStatus = ? , declined = ? , percentageComplete = ?   WHERE surveySessionId = ? "

let EXPIRE_OLD_UNSHEDULED_SURVEY = "DELETE FROM SURVEY_DATA WHERE scheduledEndTime < ? AND ( declined == 0  OR declined IS NULL) AND (progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED' OR progressStatus is null) "

let EXPIRE_OLD_SURVEY_DATA = "UPDATE SURVEY_SCHEDLUE SET progressStatus = 'EXPIRED' WHERE endTime < ? AND   ( isDeclined == 0  OR isDeclined IS NULL ) AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED' OR progressStatus is null)"

let DELETE_SURVEY_DATA = "DELETE FROM SURVEY_DATA WHERE surveySessionId = ?"
let DELETE_SURVEY_UPLOADED = "DELETE FROM SURVEY_DATA WHERE  isUploaded = 1 AND (scheduledEndTime < ? OR progressStatus = 'COMPLETED')"
let DELETE_ALL_SURVEY_DATA = "DELETE FROM SURVEY_DATA"
let GET_UNSCHEDULED_SURVEY_DATA = "SELECT * FROM SURVEY_DATA WHERE surveyId = ? AND unscheduled = 1 AND ( progressStatus = 'STARTED' OR progressStatus = 'NOT_STARTED')"

//MARK:- MEDIA

let CREATE_MEDIA = "CREATE TABLE IF NOT EXISTS MEDIA (name TEXT , sessionScheduleId INTEGER , questionId INTEGER , pageId INTEGER , answer INTEGER , isUploaded INTEGER , endTime INTEGER, PRIMARY KEY (sessionScheduleId, questionId))"

let INSERT_INTO_MEDIA = "INSERT OR REPLACE INTO MEDIA(name , sessionScheduleId  , questionId  , pageId  , answer  , isUploaded , endTime) VALUES ( ?, ? , ?, ? , ?, ? , ? )"

let GET_ALL_MEDIA = "SELECT * FROM MEDIA where isUploaded = 0"
let GET_MEDIA = "SELECT * FROM MEDIA where sessionScheduleId = ? AND questionId = ?"
let GET_MEDIA_OF_SESSION = "SELECT * FROM MEDIA where sessionScheduleId = ? AND ( isUploaded = 0 OR isUploaded  is null)"

let GET_EXPIRE_MEDIA = "SELECT * FROM MEDIA where endTime < ? "

let DELETE_MEDIA_OF_SESSION = "DELETE FROM MEDIA where sessionScheduleId = ? AND questionId = ?"

let DELETE_ALL_MEDIA = "DELETE FROM MEDIA"

//MARK:- DROAPP TimeLine
let CREATE_TIMELINE = "CREATE TABLE IF NOT EXISTS TIMELINE ( DATE INTEGER PRIMARY KEY NOT NULL , eventArray TEXT)"

let INSERT_INTO_TIMELINE = "INSERT OR REPLACE INTO TIMELINE( DATE ,eventArray  ) VALUES ( ?, ? )"

let GET_ALL_TIMELINE = "SELECT * FROM TIMELINE ORDER BY DATE DESC limit 30"

let GET_TIMELINE_OF_DATE = "SELECT * FROM TIMELINE WHERE DATE = ?"
let DELETE_ALL_TIMELINE = "DELETE FROM TIMELINE "


