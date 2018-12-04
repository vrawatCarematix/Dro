


import UIKit
import Alamofire
class WebServiceMethods : ServiceManager {
    static let sharedInstance = WebServiceMethods.init()

    private override init(){
        super.init()
    }
    //MARK:- CONFIG DATA
    func getConfigData(_ completionHandler:@escaping (Bool, [String : Any], String)-> Void){
        debugPrint("Config Web Service")
        let data = [String:Any]()
        var url = AppURL.configData
        if let programId = kUserDefault.value(forKey: kprogramId) as? Int {
            url = url + "\(programId)" + "/config?ln=EN"
        }else{
            url = url + "2" + "/config?ln=EN"
        }
        performRequest(urlVal: url, name: .get, parametersVal: nil, headersVal: nil) { (resultVal , response) in
            debugPrint("Config Web Service Response")
            if let responseData = resultVal.value as? [String : Any] {
                if let _ = responseData["form"] as? [String : Any]  {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, data,message)
                    return
                }
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
    }

    //MARK:- CONFIG DATA
    func getCss(_ completionHandler:@escaping (Result<Any> , DataResponse<String>)-> Void){
        debugPrint("getCss Web Service")
        var request = URLRequest(url: URL(string: AppURL.getCss)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(request).responseString {
            response in
            switch response.result{
            case .success(let responseObject):
                kUserDefault.set(responseObject, forKey: pCDMCss)
                completionHandler(.success(responseObject) , response)
            default:
                completionHandler(.failure(response.error!) ,response)
            }
        }
    }
    
    //MARK:- LANGUAGE DATA
    func getLanguageData(_ completionHandler:@escaping (Bool, [[String : Any]], String)-> Void){
        debugPrint("Language Web Service")

        let data = [["data" : "data"]]
        var url = AppURL.languageData
        if let programId = kUserDefault.value(forKey: kprogramId) as? Int {
            url = url + "\(programId)" + "/languages"
        }else{
            url = url + "2" + "/languages"
        }
        performRequest(urlVal: url, name: .get, parametersVal: nil, headersVal: nil) { resultVal , response in
            debugPrint("Language Web Service Response")

            if let responseData = resultVal.value as? [[String : Any]] {
                    completionHandler(true, responseData,"success")
                    return
            }else {
                completionHandler(false, data, resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
    }
    
    //MARK:- LANGUAGE Json
    func getLanguageJson(_ languageCode: String , completionHandler:@escaping (Bool, [String : Any], String)-> Void){
        debugPrint("Language Json Web Service ")

        let data = ["data" : "data"]
        let url = AppURL.languageJson + languageCode + ".json"
        
        performRequest(urlVal: url, name: .get, parametersVal: nil, headersVal: nil) { resultVal , response in
            debugPrint("Language Json Web Service Response ")

            if let responseData = resultVal.value as? [String : Any] {
                completionHandler(true, responseData,"success")
                return
            }else {
                completionHandler(false, data, resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                return
            }
        }
    }
        
    //MARK:- login
    func login(_ params: [String : String], completionHandler:@escaping (Bool,[String : Any], String ,DataResponse<Any>)-> Void){
        debugPrint("Login Web Service  ")

        performRequest(urlVal: AppURL.signIn, name: .post, parametersVal: params, headersVal: nil) { resultVal , responseHeader in
            debugPrint("Login Web Service Response ")

            let data = [String : Any]()
            if let htttpResponse = responseHeader.response  {
                if  let responseData = resultVal.value as? [String : Any] {
                    if htttpResponse.statusCode == 200 {
                        completionHandler(true, responseData,"success"  , responseHeader )
                        return
                    }
                    else if let message = responseData["message"] as? String{
                        completionHandler(false, responseData,message ,responseHeader)
                        return
                    }else{
                        completionHandler(false, responseData ,"message" , responseHeader)
                    }

                }else{
                    completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , responseHeader)
                }
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , responseHeader)
            }
        }
    }
    
    
    //MARK:- reset password
    func resetPassword(_ emailID: String , completionHandler:@escaping (Bool,[String : Any], String ,DataResponse<Any>)-> Void){
        debugPrint("Reset Pssword Web Service ")

        performRequest(urlVal: AppURL.resetPassword, name: .post, parametersVal: ["data": emailID], headersVal: nil) { resultVal , response in
            debugPrint("Reset Pssword  Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success" , response)
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message , response)
                    return
                }
                completionHandler(false, responseData,"message" , response)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , response)
            }
        }
    }
    
    //MARK:- verifyOtp password
    func verifyOtp(_ emailID: String , otp: String , completionHandler:@escaping (Bool,[String : Any], String ,DataResponse<Any> )-> Void){
        debugPrint("Verify Otp  Web Service  ")

       let url = AppURL.verifyOtp +  "encodedNameTime=" + emailID + "&securityKey=" + otp
        
        performRequest(urlVal:url, name: .get, parametersVal: nil, headersVal: nil) { resultVal , response in
            debugPrint("Verify Otp   Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success" , response)
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message , response)
                    return
                }
                completionHandler(false, responseData,"message" , response)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , response)
            }
        }
    }
    
    //MARK:- reset
    func reset(_ email: String , otp: String , password: String , completionHandler:@escaping (Bool,[String : Any], String ,DataResponse<Any> )-> Void){
        
        debugPrint("Reset Web Service  ")

        let param : [String : Any] = [pusername : email, ppassword : password,
        "securityKey": otp ]
           
        
        performRequest(urlVal:AppURL.reset, name: .put, parametersVal: param, headersVal: nil) { resultVal , response in
            debugPrint("Reset Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success" , response)
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message , response)
                    return
                }
                completionHandler(false, responseData,"message" , response)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , response)
            }
        }
    }
    
    //MARK:- Change Password
    func changePassword(_ oldPassword: String , newPassword: String , completionHandler:@escaping (Bool,[String : Any], String )-> Void){
        
        debugPrint("Change Password Web Service ")

        var param : [String : Any] = [ "oldPassword": oldPassword,
                                      "newPassword": newPassword ]
        
        var header = [String : String]()
        let data = [String : Any]()
        if  let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = token
            param["authKey"] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later" )
        }
        
        performRequest(urlVal:AppURL.changePassword, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            debugPrint("Change Password Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success" )
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message )
                    return
                }else{
                    completionHandler(false, responseData,"message" )
                }
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" )
            }
        }
    }
    
    //MARK:- logout
    func logout(_  completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        debugPrint("logout Web Service  ")

        var param = [String :Any]()
        var header = [String : String]()
        let data = [String : String]()
        
        if let userid = kUserDefault.value(forKey: AppConstantString.kUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            param[kUserId] = userid
            param["token"] = token
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        performRequest(urlVal: AppURL.logout, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            
            debugPrint("logout Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message)
                    return
                }
                completionHandler(false, responseData,"message")
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
        
    }
    
    
    //MARK:- getDeclineReason
    func getDeclineReason(_  completionHandler:@escaping (Bool,[[String : Any]], String  ,DataResponse<Any>? )-> Void){
        
        debugPrint("getDeclineReason Web Service  ")

        var header = [String : String]()
        let data = [[String : Any]]()
        if  let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later" , nil)
        }
        performRequest(urlVal: AppURL.declineReason, name: .get, parametersVal: nil, headersVal: header) { resultVal , response in
            debugPrint("getDeclineReason Web Service Response ")

            if let responseData = resultVal.value as? [[String : Any]] {
                completionHandler(true, responseData,"success", response)
                
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                completionHandler(false, data,message , response)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" , response)
                
            }
        }
    }

    //MARK:- surveyDecline
    
    func surveyDecline(_ declinedArray:[DeclinedSurveyModel], completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        
        debugPrint("surveyDecline Web Service ")

        var header = [String : String]()
        let data1 = [String : Any]()
        var params = [[String : Any]]()
        for decline in declinedArray {
            var data = [String : Any]()
            if let declineReasonId = decline.declineReasonId {
                data["declineReasonId"] = declineReasonId
            }else{
                data["declineReasonId"] = 0
            }
            
            if let userSurveySessionId = decline.userSurveySessionId {
                data["scheduledSessionId"] = userSurveySessionId
            }else{
                data["scheduledSessionId"] = 0
            }
            
            if let declineTime = decline.declineTime {
                data["declineTime"] = declineTime
            }else{
                data["declineTime"] = 0
            }
            
            data["userSurveySessionId"] = 0

            if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int {
                data[kProgramUserId] = userid
            }
            
            params.append(data)
        }
        if  let savedtoken = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = savedtoken
        }else{
            completionHandler(false, data1, "Error occured while sending data. Please try again later" )
        }
        
        performRequest(urlVal: AppURL.surveyDecline, name: .post, parametersObject: params, headersVal: header) { (resultVal, response) in
            debugPrint("surveyDecline Web Service Response ")

            if  let responseData = resultVal.value as? [String : Any]{
                completionHandler(true, responseData,"success")
                
            }else  if let responseData = resultVal.value as? String{
                var dictonary : [String :Any]?
                if let data = responseData.data(using: String.Encoding.utf8) {
                    do {
                        dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String :Any]
                    } catch let error as NSError {
                        print(error)
                    }
                    if let dict = dictonary ,  let message = dict["message"] as? String , message.lowercased() == "success".lowercased(){
                        completionHandler(true, dict,"success")
                    }else{
                        completionHandler(false, data1,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                    }
                    
                }
            } else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                
                completionHandler(false, data1,message)
            }else{
                completionHandler(false, data1,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
        
    }
    
    
    //MARK:- getAllSurvey
    func getAllSurvey(_ completionHandler:@escaping (Bool,[[String : Any]], String)-> Void){
        
        debugPrint("getAllSurvey Web Service ")

        var param = [String :Any]()
        param["timezone"] = TimeZone.current.identifier
        param[planguage] = (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN")
        let data = [[String : String]]()
        if let programId = kUserDefault.value(forKey: kprogramId) as? Int {
            param["organizationProgramId"] = programId
        }else{
            param["organizationProgramId"] = 2
        }
        performRequest(urlVal: AppURL.getAllSurvey, name: .post, parametersVal: param, headersVal: nil) { resultVal , response in
            debugPrint("getAllSurvey Web Service Response ")
            if let responseData = resultVal.value as? [[String : Any]] {
                    completionHandler(true, responseData,"success")
                    return
            }else{
                if let responseData = resultVal.value as? [String : Any]  , let message = responseData["message"] as? String{
                    completionHandler(false, data , message)
                    return
                }else{
                    completionHandler(false, data, resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                }
                
            }
        }
    }
    
    
    //MARK:- getSurvey
    func getSurvey(_ userSurveySessionId: Int, completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        debugPrint("getSurvey Web Service  ")


        var param = [String :Any]()
        param["timezone"] = TimeZone.current.identifier
        param["userSurveySessionId"] = userSurveySessionId

        param[planguage] = (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN")
        var header = [String : String]()
        let data = [String : String]()

        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            param[kProgramUserId] = userid

            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        performRequest(urlVal: AppURL.getSurvey, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            
            debugPrint("getSurvey Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                if let _ = responseData["survey"]  {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message)
                    return
                }
                completionHandler(false, responseData,"message")
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")

            }
        }
    }
    
    //MARK:- Get SurveySession
    func surveySession(_ scheduledSessionId: Int, completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        debugPrint("surveySession Web Service ")

        
        var param : [ String : Any] = [ "timezone" : TimeZone.current.identifier , "scheduledSessionId" : scheduledSessionId , planguage :(kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN") ]
     
        var header = [String : String]()
        let data = [String : String]()
        
        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            param[kProgramUserId] = userid
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        performRequest(urlVal: AppURL.getUserSurveySession, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            debugPrint("surveySession Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                if let _ = responseData["id"]  {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message)
                    return
                }else{
                    completionHandler(false, responseData,"message")
                }
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                
            }
        }
    }
    
    //MARK:- Get updateSurveyResponse
    func submitSurveyResponse(_ survey: SurveySubmitModel, completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        debugPrint("submitSurveyResponse Web Service ")

        var surveySessionId = survey.surveySessionId ?? 0

        var param = [ String : Any]()
        param["programSurveyId"] = survey.programSurveyId
        param["id"] =  0
        if survey.unscheduled == 0 {
            param["unscheduled"] =  false
           // survey.scheduleType = "UNSCHEDULED"
        }else{
            param["unscheduled"] =  true
            surveySessionId = 0
            survey.scheduleType = "UNSCHEDULED"

        }

        param["pageNavigations"] =  survey.pageNavigationJson
        param["userAnswerLogs"] = survey.userAnswerLogsJson

        let userSurveySessionDetail : [String : Any] = [
            "id": 0,
            "progressStatus": (survey.progressStatus ?? ""),
            "percentageComplete": (survey.percentageComplete ?? 0),
            "startTime": (survey.startTime ?? 0 ),
            "endTime": (survey.endTime ?? 0),
            "lastSubmissionTime": (survey.lastSubmissionTime ?? 0),
            "timeSpent": (survey.timeSpent ?? 0),
            "lastAnswerPageId": (survey.lastAnswerPageId ?? 0),
            "declined": false
        ]
        param["userSurveySessionDetail"] = userSurveySessionDetail
        
        
        let schedule : [String : Any] =  [
            "id": surveySessionId,
            "scheduledDate": survey.scheduledDate ?? 0,
            "startTime": survey.scheduledStartTime ?? 0,
            "endTime": survey.scheduledEndTime ?? 0,
            "scheduleType": survey.scheduleType ?? "",
            "userScheduleAssignId": 0
        ]
         param["scheduledSession"] = schedule
        
        var header = [String : String]()
        let data = [String : String]()
        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            param["programUserID"] = userid
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        performRequest(urlVal: AppURL.updateSurveyResponse, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            debugPrint("submitSurveyResponse Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                if let message = responseData["message"] as? String , message.lowercased() == "Success".lowercased() {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message)
                    return
                }else{
                    completionHandler(false, responseData,"message")
                }
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
    }
    
    //MARK:- VIEW DRO

    func getViewDro(_ startDate: Int,endDate :Int , completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        
        debugPrint("VIEW DRO Web Service ")

        var param = [String :Any]()
        param["timezone"] = TimeZone.current.identifier
        param[planguage] = (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN")
        param["startTime"] = startDate
        param["endTime"] = endDate
        param["status"] = ""

        var header = [String : String]()
        let data = [String : String]()
        
        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            param[kProgramUserId] = userid
            
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        performRequest(urlVal: AppURL.viewDro, name: .post, parametersVal: param, headersVal: header) { resultVal , response in
            debugPrint("VIEW DRO Web Service Response ")

            let data = [String : Any]()
            if let responseData = resultVal.value as? [String : Any] {
                if let _ = responseData["droInfoList"]  {
                    completionHandler(true, responseData,"success")
                    return
                }
                else if let message = responseData["message"] as? String{
                    completionHandler(false, responseData,message)
                    return
                }
                completionHandler(false, responseData,"message")
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                
            }
        }
    }

    
    func downloadMultimedia  (_ params: [String : String]?, url: String , completionHandler:@escaping (Bool, String)-> Void){
        debugPrint("downloadMultimedia Service ")

        downloadData(url: url, ProgressHandler: { (progress) in
            
        }) { (success, message) in
            debugPrint("downloadMultimediaWeb Service Response ")

            completionHandler(success, message)

        }
    }
    
    
    func downloadMultimediaFile(_ params: [String : String]?, url: String , completionHandler:@escaping (Bool, String)-> Void){
        debugPrint("downloadMultimediaFile Service  ")

        
        downloadFile(url: url, ProgressHandler: { (progress) in
            
        }) { (success, message) in
            debugPrint("downloadMultimediaFile Service Response ")
            completionHandler(success, message)
        }
    }

    
    
    //MARK:- TIMELINE

    func getTimeline(_ from : Int , toRow : Int ,  completionHandler:@escaping (Bool,[[String : Any]], String)-> Void){
        
        debugPrint("TIMELINE Service")

        var programUserId = 0
        var header = [String : String]()
        let data = [[String : Any]]()

        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            programUserId = userid
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        let pram : [String :Any] = [
            "fromRow": from,
            "toRow": toRow,
            planguage: (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN"),
            kProgramUserId: programUserId,
            "timezone": TimeZone.current.identifier ]
        
        performRequest(urlVal: AppURL.getTimeline, name: .post, parametersVal: pram, headersVal: header) { resultVal , response in
            debugPrint("TIMELINE Web Service Response ")

            if let responseData = resultVal.value as? [[String : Any]] {
                completionHandler(true, responseData,"success")
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                completionHandler(false, data,message)
            }else{
                completionHandler(false, data, resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                
            }
        }
        
    }
    //MARK:- MESSAGE
    func getMessage(_  completionHandler:@escaping (Bool,[[String : Any]], String)-> Void){
        debugPrint("MESSAGE Web Service  ")

        var url = AppURL.getMessage
        var header = [String : String]()
        let data = [[String : Any]]()

        if let userid = kUserDefault.value(forKey: AppConstantString.kUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            url = url + "\(userid)"
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }

        performRequest(urlVal: url, name: .get, parametersVal: nil, headersVal: header) { resultVal , response in
            debugPrint("MESSAGE Web Service Response ")

            if let responseData = resultVal.value as? [[String : Any]] {
                completionHandler(true, responseData,"success")

            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                 completionHandler(false, data,message)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
    }

    //MARK:- update Message
    func updateMessage(_ message:MessageModel , completionHandler:@escaping (Bool,[String : Any], String ,DataResponse<Any>?)-> Void){
        debugPrint("updateMessage Web Service  ")

        var header = [String : String]()
        let data = [String : Any]()
        var stared = false
        if let starred = message.isStarred , starred == 1 {
             stared = true
        }
        let param : [String :Any] = [
            "id": message.id ?? 0,
            kUserId: message.userId ?? 0,
            "textMessage": message.textMessage ?? "",
            "readStatus": message.readStatus ?? "",
            "senderName": message.senderName ?? "",
            "messageTile": message.messageTile ?? "",
            "createTime": message.createTime ?? "",
            "isStarred": stared
        ]
        if  let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later" , nil)
        }
        
        performRequest(urlVal: AppURL.updateMessage, name: .put, parametersVal: param, headersVal: header) { resultVal , response in
            debugPrint("updateMessage Web Service  Response")

            if let responseData = resultVal.value as? [String : Any] {
                completionHandler(true, responseData,"success" , response)
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                completionHandler(false, data,message ,  response)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later" ,  response)
            }
        }
        
    }
    
    
    //MARK:- Schedule Calender
    func getScheduleCalender(_ fromDate: Int , toDate :Int , completionHandler:@escaping (Bool,[[String : Any]], String)-> Void){
        
        debugPrint("Schedule Calender Web Service ")

        var header = [String : String]()
        let data = [[String : Any]]()
        
        var programUserId = 0

        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            programUserId = userid
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        let pram : [String :Any] = [
            "endTime": toDate,
            "startTime": fromDate,
            planguage: (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN"),
            kProgramUserId: programUserId,
            "timezone": TimeZone.current.identifier ]
        
        performRequest(urlVal: AppURL.calendarSchedulesNew, name: .post, parametersVal: pram, headersVal: header) { resultVal , response in
            debugPrint("Schedule Calender Web Service  Response")

            if let responseData = resultVal.value as? [[String : Any]] {
            
                completionHandler(true, responseData,"success")
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                completionHandler(false, data,message)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
        
    }
    
    
    //MARK:- DashBoard Data
    func getDashBoardData(_  completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        
        debugPrint("DashBoard Data Web Service")

        var header = [String : String]()
        let data = [String : Any]()
        var programUserId = 0

        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            programUserId = userid
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        let pram : [String :Any] = [
            planguage: (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN"),
            kProgramUserId: programUserId,
            "timezone": TimeZone.current.identifier ]
        
        performRequest(urlVal: AppURL.dashboardData, name: .post, parametersVal: pram, headersVal: header) { resultVal , response in
            
            debugPrint("DashBoard Data Web Service  Response")

            if let responseData = resultVal.value as? [String : Any] {
                completionHandler(true, responseData,"success")
                
                
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                
                completionHandler(false, data,message)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
            }
        }
        
    }

    //MARK:- Profile Data

    func getProfileData(_  completionHandler:@escaping (Bool,[[String : Any]], String)-> Void){
        
        debugPrint("getProfileData Data Web Service ")

        var header = [String : String]()
        let data = [[String : Any]]()
        
        if  let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false, data, "Error occured while sending data. Please try again later")
        }
        
        performRequest(urlVal: AppURL.profileData, name: .get, parametersVal: nil, headersVal: header) { resultVal , response in
            
            debugPrint("getProfileData Data Web Service Response")

            if let responseData = resultVal.value as? [[String : Any]] {
                completionHandler(true, responseData,"success")
            }else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                completionHandler(false, data,message)
            }else{
                completionHandler(false, data,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                
            }
        }
    }
    
    //MARK:- Save Profile Data

    func saveProfileData(_ profileArray : [ProfileModel] ,  completionHandler:@escaping (Bool,[String : Any], String)-> Void){
        
        debugPrint("Save Profile Data Data Web Service")

        var header = [String : String]()
        let data1 = [String : Any]()
        var params = [[String : Any]]()
        for profile in profileArray {
            var data = [String : Any]()
            if let fieldId = profile.fieldId {
                data["fieldId"] = fieldId
            }else{
                data["fieldId"] = ""
            }
            if let organizationFormFieldValueId = profile.organizationFormFieldValueId {
                data["organizationFormFieldValueId"] = organizationFormFieldValueId
            }else{
                data["organizationFormFieldValueId"] = ""
            }
            if let fieldType = profile.fieldType {
                data["fieldType"] = fieldType
            }else{
                data["fieldType"] = ""
            }
            if let value = profile.value {
                data["value"] = value
            }else{
                data["value"] = ""
            }
           params.append(data)
        }
        
        if  let savedtoken = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = savedtoken
        }else{
            completionHandler(false, data1, "Error occured while sending data. Please try again later")
        }
        performRequest(urlVal: AppURL.saveProfileData, name: .put, parametersObject: params, headersVal: header) { (resultVal, response) in
            
            debugPrint("Save Profile Data Data Web Service Response")

            if  let responseData = resultVal.value as? [String : Any]{
                completionHandler(true, responseData,"success")

            }else  if let responseData = resultVal.value as? String{
                var dictonary : [String :Any]?
                if let data = responseData.data(using: String.Encoding.utf8) {
                    do {
                        dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String :Any]
                    } catch let error as NSError {
                        print(error)
                    }
                    if let dict = dictonary ,  let message = dict["message"] as? String , message == "success"{
                        var  jsonData = Data()
                        do {
                            jsonData = try JSONSerialization.data(withJSONObject: params
                                , options: .prettyPrinted) as Data
                            kUserDefault.set(jsonData, forKey: kProfileData)
                        } catch {
                            print(error.localizedDescription)
                        }
                        completionHandler(true, dict,"success")
                    }else{
                         completionHandler(false, data1,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                    }
                    
                }
            } else if let messageData = resultVal.value as? [String : Any] , let message = messageData["message"] as? String {
                
                completionHandler(false, data1,message)
            }else{
                completionHandler(false, data1,resultVal.error?.localizedDescription ?? "Error occured while sending data. Please try again later")
                
            }
        }

    
    }
    
    
    //MARK:- Upload File
    func upload( data :Data , fileName : String,  completionHandler:@escaping (Bool,Int, String)-> Void) {
        

        var header = [String : String]()
        if  let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String {
            header[pX_DRO_TOKEN] = token
        }else{
            return
        }
        
        header["X-DRO-SOURCE"] = kIOS

        var mimeType = ""

        if fileName.contains(".mov") {
             mimeType = "video/quicktime"
        }else if fileName.contains(".m4a"){
             mimeType = "audio/x-m4a"
        }else{
             mimeType = "image/jpg"
        }
        
        debugPrint("Upload File of " + mimeType + " Web Service")
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "uploadedFile",fileName: fileName, mimeType: mimeType)
            
        }, to: AppURL.uploadFile, method: HTTPMethod.post, headers: header)
        { (result) in
            
            debugPrint("Upload File of " + mimeType + " Web Service")

            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    if let id = response.result.value as? Int{
                        completionHandler(true, id ,"success")
                      //  print(response.result.value)
                    }else{
                        completionHandler(false, 0 ,"failure")

                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(false, 0 ,"failure")

            }
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

}



extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}



