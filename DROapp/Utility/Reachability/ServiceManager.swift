
import Foundation
import Alamofire
import UIKit
//public enum Result<Value> {
//
//    case success(Value)
//    case failure(Value)
//
//    /// Returns the associated value if the result is a success, `nil` otherwise.
//    public var value: Value? {
//        switch self {
//        case .success(let value):
//            return value
//        case .failure:
//            return nil
//        }
//    }
//
//    /// Returns the associated error value if the result is a failure, `nil` otherwise.
//    public var error: String? {
//        switch self {
//        case .success:
//            return nil
//        case .failure(let error):
//            return error
//        }
//    }
//}


class ServiceManager {
    
    public typealias progressHandler = (_ progress: Double) -> ()
    
    func performRequest(urlVal: String, name: HTTPMethod, parametersVal: [String:Any]?,headersVal:[String: String]?,completionHandler:@escaping (Result<Any> , DataResponse<Any>) ->Void){
        var header = [String: String]()
        if let head = headersVal{
         header = head
       }
        header["X-DRO-SOURCE"] = kIOS
        Alamofire.request(urlVal, method: name, parameters: parametersVal, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            if let htttpResponse = response.response , htttpResponse.statusCode == 401 {
                DispatchQueue.main.async {
                    CustomActivityIndicator.stopAnimating()
                    DatabaseHandler.deleteAllTableData()
                    kUserDefault.set(kYes, forKey: kLoggedIn)
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                    let loginViewController = MainStoryboard.instantiateViewController(withIdentifier: AppController.WelcomeScreen) as! WelcomeScreen
                    let navigationController  = UINavigationController(rootViewController: loginViewController)
                    UIApplication.shared.keyWindow?.rootViewController = navigationController
                    loginViewController.showErrorAlert(titleString: "Session Expired", message: "Your session expired, please login again. ")
                }
            }else{
                
                switch response.result{
                case .success(let responseObject):
                    completionHandler(.success(responseObject) , response)
                default:
                    completionHandler(.failure(response.error!) ,response)
                }
            }
        }
    }
    
    func performRequest(urlVal: String, name: HTTPMethod, parametersObject: Any, headersVal:[String: String]?,completionHandler:@escaping (Result<Any> , DataResponse<String>) ->Void){
        var header = headersVal
        if var  _ = headersVal {
            header!["X-DRO-SOURCE"] = kIOS
        }
        var request = URLRequest(url: URL(string: urlVal)!)
        
        request.httpMethod = name.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerDict = header {
            for key in headerDict.keys{
                request.setValue(headerDict[key], forHTTPHeaderField: key)
            }
        }
        var  jsonData = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parametersObject , options: .prettyPrinted) as Data
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = jsonData
        Alamofire.request(request).responseString {
            response in
            switch response.result{
            case .success(let responseObject):
                completionHandler(.success(responseObject) , response)
            default:
                completionHandler(.failure(response.error!) ,response)
            }
        }
    }
    
    func downloadData(url:String, ProgressHandler:@escaping progressHandler,completionHandler:@escaping (Bool, String)-> Void){
        guard let destUrl = URL(string: url ) else { return }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(destUrl.lastPathComponent)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 200
        configuration.timeoutIntervalForResource = 200
        
        Alamofire.download(url, to: destination).response { response in
            if let statusCode =  response.response?.statusCode , statusCode == 200 {
                if let url = response.destinationURL?.lastPathComponent{
                    completionHandler(true ,url)
                }else{
                    completionHandler(false , "Fail")
                }
            }else{
                completionHandler(false , "Fail")
            }
        }
    }
    
    func downloadFile(url:String, ProgressHandler:@escaping progressHandler,completionHandler:@escaping (Bool, String)-> Void){
        guard let destUrl = URL(string: url ) else { return }
    
        let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = URL(fileURLWithPath: "")

            if let headers = response.allHeaderFields as? [String :String], let fileName = headers["X_DRO_FILE_NAME"]{
                fileURL = documentsURL.appendingPathComponent(fileName)

            }else{
                 fileURL = documentsURL.appendingPathComponent(destUrl.lastPathComponent)
            }
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        var header = [String : String]()
        header["X-DRO-SOURCE"] = kIOS
        if let userid = kUserDefault.value(forKey: AppConstantString.kProgramUserId) as? Int , let token = kUserDefault.value(forKey: AppConstantString.kToken) as? String{
            header[kProgramUserId] = "\(userid)"
            header[pX_DRO_TOKEN] = token
        }else{
            completionHandler(false , "Fail")
        }
        
        Alamofire.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header, to: destination).response { response in
            //  print(response)
            if let statusCode =  response.response?.statusCode , statusCode == 200 {
                if let url = response.destinationURL?.lastPathComponent{
                    completionHandler(true ,url)
                    
                }else{
                    completionHandler(false , "Fail")
                }
            }else{
                completionHandler(false , "Fail")
            }
        }
    }
}
