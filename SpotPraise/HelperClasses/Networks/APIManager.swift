//
//  ApiManager.swift
//  Firla
//
//  Created by admin on 28/02/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import  Alamofire


class APIManager :NSObject {
    //MARK: - Variables
    static var Auth_header = [ String:String]()
    //private var alamoSession =  Alamofire.SessionManager.default.session
    // var obj:Loader?
    private static var requestCancelled = false
    
    
    //MARK: - headerSetup
    private static func headerSetup(anySetup:Any = ""){
        
        Auth_header.removeAll()
        
        if LocalStorage.isUserLogin(){
             let accessToken = LocalStorage.getToken()
            
//            Client-Service:spot-client
//            Auth-Key:oremapi
//            Authorization:NHhYMmR3V2xjTUJHdURi
            guard let userData = ModelDataHolder.shared.loggedData else {
                return
            }
            let userID = userData.id
            let lang = "2"
            
            if accessToken != ""{
                
                Auth_header = ["Client-Service":"spot-client",
                               "Auth-Key":"oremapi",
                               "Authorization":accessToken,
                               "user-id":userID,
                               "lang":lang] as! [String : String]
            }
        }
        else {
          Auth_header =  ["Client-Service":"spot-client",
            "Auth-Key":"oremapi",
            "lang":"2"]
        }
    }
    static func owa(){
        print("ALA")
        stopTheDamnRequests()
        //Alamofire.SessionManager.default.session.invalidateAndCancel()
    }
    
    static func stopTheDamnRequests(){
        requestCancelled = true
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
    
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("ALA")
        // Alamofire.SessionManager.default.session.invalidateAndCancel()
    }
    
    //MARK: - Calling API with Alamo fire
    static func requestWebServerWithAlamo(to urlS:serverURLEndpoint,getUrlForOnlyLink:String = "",anyRequirement:Any = "" ,httpMethd:HTTPMethod,params:[String:Any]? = nil, completion:@escaping (_ jsonData:DataResponse<Any>)  -> Void , onError: ((AnyObject) -> Void)? = nil )
    {
        
        MonitorNetwork.networkConnection.networkMonitor(isConnected: { (isConnected, connection) in
            
            var logoutRequest = false
//            if  urlS == serverURLEndpoint.Logout{
//                logoutRequest = true
//            }
            if isConnected{
                var activeSpinner = true
                
                let holdSpinner = false
                let timeOut = 15
                
                headerSetup()
                guard let  urlString = MakeURL.genrateURL(endPoint: urlS)  else {return}
                if let someThing = anyRequirement as? [String:Any]{
                    if let requestForSearch = someThing[OptionalSettingsKeys.addHeader] as? Bool{
                        //activeSpinner = spinerStatus
                        print(requestForSearch)
                        headerSetup(anySetup: requestForSearch)
                    }
                    else if let requestForSpiner = someThing[OptionalSettingsKeys.willSpinnerSpin] as? Bool{
                        activeSpinner = requestForSpiner
                    }
                    
                }
               // NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didUserCancelTheTask, object: nil)
                console("******|||| API REQUEST WAS \(urlString) |||||******")
                console("******|||| API HEADER WAS \(Auth_header) |||||******")
                console("******|||| PARAMETERS WAS \(params) |||||******")
                if activeSpinner{
                    DispatchQueue.main.async {
                        Loader.shared.showLoader()
                        // Loader.shared.setd(obj: self)
                        //    Loader.shared.dismissButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(d)))
                        
                        //obj.shared.delegate   = self
                        // let obj = Loader()
                        //obj.delegate = self
                        
                    }
                }
                
                
                Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = TimeInterval(timeOut) // in seconds
                // }
                
                Alamofire.request(urlString, method: httpMethd, parameters: params, headers: Auth_header).responseJSON(completionHandler: { response  in
                    
                    //SVProgressHUD.dismiss()
                   // if  holdSpinner == false{
                        Loader.shared.hideLoader()
                    //}
                    
                    //print(Alamofire.header)
                  print("Response Code \(String(describing: response.response?.statusCode))")
                    if !barredResponseOnConsole{
                        print("Response IS \(String(describing: response))")
                    }
                    switch response.result
                    {
                        
                    case .success://Well mean Alamofire successfully execute the network task with code 200
                        //Now lets check the backend response code in status
//                        if checkAndRespondCode(responseCode:response.response?.statusCode ?? 0,response:response){
//                            completion(response)
//                        }
                        self.getJsonDict(response: response, completion: {dataDict in
                            var statusCode = 0
                            if  let status = dataDict["status"] as? String{
                                statusCode = Int(status) ?? 0
                            }
                            else  if  let status = dataDict["status"] as? Int{
                                statusCode = status
                            }

                            if checkAndRespondCode(responseCode:statusCode,response:response){
                                completion(response)
                            }

                        })
                       
                       
                    case .failure(let er):
                        Loader.shared.hideLoader()
                        Logs.printLog("\(er.localizedDescription) With response code \(String(describing: response.response?.statusCode))")
                        //  AppManager.printLog(er.localizedDescription)
                        showErrorMessage(messageStr: MESSAGES.RESPONSE_ERROR.rawValue)
                        // onError?("No Data" as AnyObject)
                        
                    }
                })
            }
            else
            {let err = NetWorkErro.NoNetwork.rawValue
                
                if !logoutRequest{
                    showErrorMessage(messageStr: err)
                }
                else if logoutRequest{
                    onError?("No Internet!!" as AnyObject)
                }
                
                
            }
            
        })
        
        //ANALYSE CODES
        
    }
    
    //ANALYSE CODE
    
   static func checkAndRespondCode(responseCode:Int = 0,response:DataResponse<Any>?)->Bool{
    
    switch responseCode {
    case 200 , 0:
        
        return true
        
    default:
        guard let res = response else {
            return false
        }
        self.getJsonDict(response: res, completion: {dataDict in
            guard let msgw = dataDict["msg"] as? String else {
                
                return
            }
           // Logs.printLog("Error with response code \(responseCode)")
            if msgw.count == 0 {
                 showErrorMessage(messageStr: MESSAGES.RESPONSE_ERROR.rawValue  )
            }else {
                 showErrorMessage(messageStr: msgw  )
            }
           
        })
        return false
    }
    }
    
    
    static func requestWebServerWithAlamoToUploadImage(to urlS:serverURLEndpoint ,photoKey:String,extKey:String,_mimeType:String,imageInData:[Data]? = nil,parameters:[String:AnyObject]? = nil ,anyRequirement:Any = "",completion:@escaping (_ jsonData:DataResponse<Any>) -> Void )
    {
        
        MonitorNetwork.networkConnection.networkMonitor(isConnected: { (isConnected, connection) in
            
            if isConnected{
                var wereTwoDifferentImage = false
                
                DispatchQueue.main.async {
                    Loader.shared.showLoader()
                }
                headerSetup()
                guard let  urlString = MakeURL.genrateURL(endPoint: urlS)  else {return}
                //let url =   URL(string: serverURLEndpoint.baseURL.rawValue+urlS.rawValue)
                console("******|||| API REQUEST WAS \(urlString) |||||******")
                console("******|||| API HEADER WAS \(Auth_header) |||||******")
                console("******|||| PARAMETERS WAS \(parameters) |||||******")
                
                if let someThing = anyRequirement as? NSDictionary{
                    if let requestForTwoDifferParamImages = someThing[OptionalSettingsKeys.multiParmImage] as? Bool{
                        //activeSpinner = spinerStatus
                        wereTwoDifferentImage = requestForTwoDifferParamImages
                        // print(requestForSearch)
                        // headerSetup(anySetup: requestForSearch)
                    }
                }
                
                Alamofire.upload(multipartFormData:{ multipartFormData in
                    if imageInData?.count != 0 {
                        for byte in imageInData!{
                            multipartFormData.append(byte, withName: photoKey, fileName: extKey, mimeType: _mimeType)
                        }
                        // multipartFormData.append(imageInData!, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
                    }
                    
                    if wereTwoDifferentImage {
                        if let dataDict = anyRequirement as? NSDictionary{
                            guard let ImageData = dataDict[OptionalSettingsKeys.imgData] as? Data
                                else {
                                    return
                            }
                            
                            guard let _photoKey = dataDict[OptionalSettingsKeys.photoKey] as? String
                                else {
                                    return
                            }
                            guard let _extKey = dataDict[OptionalSettingsKeys.extKey] as? String
                                else {
                                    return
                            }
                            print(_photoKey)
                            print(_extKey)
                            print(_mimeType)
                            
                            multipartFormData.append(ImageData, withName: _photoKey, fileName: _extKey, mimeType: _mimeType)
                        }
                        
                        
                    }
                    
                    // let r = String(data: try! JSONSerialization.data(withJSONObject: parameters!, options: .sortedKeys), encoding: .utf8 )!
                    /// let rr = r.replacingOccurrences(of: "\\", with: "")
                    
                    for (key, value) in parameters! {
                        // multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
                        // multipartFormData.append(value.data(using: Int.encode(32)), withName: key)
                        
                    }
                },
                                 usingThreshold:UInt64.init(),
                                 to:urlString,
                                 method:.post,
                                 headers:Auth_header,
                                 encodingCompletion: { encodingResult in
                                    switch encodingResult {
                                    case .success(let upload, _, _):
                                        
                                        upload.uploadProgress(closure: { (progress) in
                                            
                                            print("Upload Progress: \(progress.fractionCompleted)")
                                            if progress.isFinished
                                            {   Loader.shared.hideLoader()
                                                // progressHudString = ""
                                                //  SVProgressHUD.dismiss()
                                            }
                                        })
                                        
                                        
                                        //console("json \(JSON)")
                                        upload.responseJSON { response in
                                            
                                            
                                            if !barredResponseOnConsole{
                                                print("Response IS \(String(describing: response))")
                                            }
                                            switch response.result
                                            {
                                                
                                            case .success:
                                                self.getJsonDict(response: response, completion: {dataDict in
                                                    var statusCode = 0
                                                    if  let status = dataDict["status"] as? String{
                                                        statusCode = Int(status) ?? 0
                                                    }
                                                    else  if  let status = dataDict["status"] as? Int{
                                                        statusCode = status
                                                    }
                                                    
                                                    if checkAndRespondCode(responseCode:statusCode,response:response){
                                                        completion(response)
                                                    }
                                                    
                                                })
                                                
                                            case .failure(let er):
                                                Loader.shared.hideLoader()
                                                //print("IN failure\(er.localizedDescription)")
                                                showErrorMessage(messageStr:MESSAGES.RESPONSE_ERROR.rawValue)
                                                Logs.printLog("\(er.localizedDescription)")
                                                //showErrorMessage(messageStr: "\(er.localizedDescription)")
                                            }
                                            
                                            //
                                            
                                        }
                                        
                                        
                                    case .failure(let encodingError):
                                        print(encodingError)
                                    }
                })
            }
                
            else
            {
                let err = NetWorkErro.NoNetwork.rawValue
                showErrorMessage(messageStr: err)
            }
            
        })
    }
    
    static private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    //Create a method to download the image (start the task)
    
    static func downloadImage(from url: URL,completion: @escaping (UIImage?)->()) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
                //  self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    static func getJsonDict(response:DataResponse<Any>,completion:@escaping (_ jsonData:[String:Any]) -> Void )
    {
        
        do {
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                else
            {
                // AppHandler.AlertManager.showAlertMessage(titleStr: .Error, messageStr: .UnableToProcessRequest)
                return
            }
            // print("Clean DATA \(jsonDictionary)")
            ConvertCSVTOJSON(contentData: response.data!)// only for test
            completion(jsonDictionary)
            
        } catch {
            // Handle error
            
            print(error)
        }
        
    }
    
    //////****** USE ONLY IN TEST *********
    static func ConvertCSVTOJSON(contentData:Data)
    {
        let contents =  String(data: contentData, encoding: .utf8)
        let content = self.csv(data: contents!)
        if !barredCSVJSON{
            print("CSVJSON String \(content.replacingOccurrences(of: "\\", with: ""))")
        }
        
    }
    private static func csv(data: String) -> String {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\r\n").map({ $0.components(separatedBy: ";") })  ///.components(separatedBy: "\n\")
        //rows = data.components(separatedBy: "\")
        for row in rows {
            result.append(row)
        }
        return result.debugDescription
    }
    
    static func showErrorMessage( messageStr:String) -> Void {
        if requestCancelled  == false {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message:  messageStr, preferredStyle: UIAlertController.Style.alert);
                let okButton = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(okButton)
                
                guard let vc = Alert.shared.topMostController()  else {
                    let application = UIApplication.shared.delegate as! AppDelegate
                    // application.window?.rootViewController?.view.addSubview(self)
                    let v =    application.window?.rootViewController
                    v?.present(alert, animated: true, completion: nil)
                    return
                }
                vc.present(alert, animated: true, completion: nil)
            }
        }
        requestCancelled = false
    }
}


enum NetWorkErro:String {
    case NoNetwork = "Please check your internet connection!"
}






enum serverURLEndpoint:String {
    case sentOtp = "sentOtp"
    case verifyOtp = "verifyOtp"
    case register  = "register"
    
    case forgetPassword = "forgetPassword"
    case changePassword = "changePassword"
    case  editProfile = "editProfile"
    case login = "login"
    
}
struct MakeURL {
    private static let   baseURL = "http://122.160.233.58/lalit/spot/api/apis/"
    static func genrateURL(endPoint:serverURLEndpoint)->URL?{
        guard var  urlis = URL(string: self.baseURL) else {return nil}
        urlis.appendPathComponent(endPoint.rawValue)
        return urlis
    }
}


struct OptionalSettingsKeys {
    static let willSpinnerSpin = "willSpinnerSpin"
    static let decreaseTime = "decreaseTime"
    static let addHeader = "addHeader"
    
    static let isForSearch = "isForSearch"
    static let holdSpiner = "holdSpiner"
    static let requestToLogout = "requestToLogout"
    
    //WARNING
    static let multiParmImage = "multiParmImage"
    static let photoKey = "photoKey"
    static let extKey = "extKey"
    static let imgData = "imgData"
}
