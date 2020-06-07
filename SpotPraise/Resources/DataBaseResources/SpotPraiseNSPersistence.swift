import UIKit

class LocalStorage: NSObject {
    static let defaultK = UserDefaults.standard
    // let preKey = Constant.DeviceCredentials.AppName
    
    
    
    private static var vNil = "nil"
    enum DBActions {
        case Insert , Fetch ,Delete
    }
    
    enum AccessKeys:String{
        case AccesskeyUid = "AccesskeyUid"
        case NoAccessKey = "X"
        case AccessKeyClean = "AccessKeyClean"
        case AccesskeyEmail = "kEmail"
        case AccesskeyPassword = "Password"
        case AccesskeyAuthToken = "kAuthtkn"
        case AccessKeyLoggedData = "kAuthLoggedData"
        case AccessKeyIsRemember = "AccessKeyIsRemember"
        case AccessKeyCordinatesSave = "AccessKeyCordinatesSave"
        case AccessKeyWasNotificationEnble = "AccessKeyWasNotificationEnble"
    }
    //onError: ((String) -> Void)? = nil )
    static func callLocalDBTo(secretData:[AccessKeys:Any] = [:],
                              dbActions:DBActions,
                              accessKey:AccessKeys ,
                              processComplete: ((Any?) -> Void)? = nil ){
        // processComplete: nsUserDefaultResult:((String)  -> Void)? = nil){
        switch dbActions {
        case .Insert:
            var runCounter = 0
            let dataKeys = Array(secretData.keys)// as Array
            while runCounter < dataKeys.count{
                defaultK.set(secretData[dataKeys[runCounter]], forKey:dataKeys[runCounter].rawValue )
                runCounter += 1
            }
            
            
            
        case .Fetch:
            //            guard let dataFromMemory =   defaultK.value(forKey: accessKey.rawValue) as? String else {
            //                return
            //            }
            let dataFromMemory =   defaultK.value(forKey: accessKey.rawValue)
            processComplete?(dataFromMemory)
            
            
        case .Delete:
            if accessKey == AccessKeys.AccessKeyLoggedData  ||  accessKey == AccessKeys.AccessKeyCordinatesSave || accessKey == AccessKeys.AccessKeyWasNotificationEnble {
                defaultK.removeObject(forKey:accessKey.rawValue)
                if accessKey == .AccessKeyLoggedData{
                     defaultK.removeObject(forKey:AccessKeys.AccesskeyAuthToken.rawValue)
                }
                processComplete?("Done")
            }
            else {
                Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr: "INVALID DATA DELETE KEY!!")
            }
            
            // defaultK.removeObject(forKey: AccessKeys.AccesskeyUid.rawValue)
            
            
        }
        defaultK.synchronize()
    }
    
    static func isUserLogin()->Bool{
        
        if defaultK.value(forKey: AccessKeys.AccesskeyAuthToken.rawValue) != nil
        {return  true}
        else{return false}
    }
    static func saveAccessToken(accessToken tkn:String?){
        defaultK.set(tkn, forKey: AccessKeys.AccesskeyAuthToken.rawValue)
    }
    static func getToken()->String?{
        if let fetchAuthD = defaultK.value(forKey: AccessKeys.AccesskeyAuthToken.rawValue) as? String
        {return  fetchAuthD}
        else{return ""}
        
    }
    static func saveLoggedData(authData aData:RegistrationData?){
        defaultK.set(aData?.email, forKey: AccessKeys.AccesskeyEmail.rawValue)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(aData) {
            defaultK.set(encoded, forKey:  AccessKeys.AccessKeyLoggedData.rawValue)
        }
        defaultK.synchronize()
    }
    
    
  
    
}
