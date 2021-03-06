import UIKit
import CoreLocation

@objc protocol AppMangerEventListener:AnyObject {
    @objc optional func checkPopListStatus(PopUplistType:String)
}


class AppManager: NSObject {
    private override init() {
    }
    static let Manager = AppManager()
    var window: UIWindow?
      var customStackTree = [VC]();
    weak var delegate:AppMangerEventListener?
    
    private let locationManager = CLLocationManager()
    func initStoryBoard(type:Storyboards){
        window = UIWindow(frame: UIScreen.main.bounds)
        
        switch type {
        case .Login:
            let storyboard:UIStoryboard = UIStoryboard(name: Storyboards.Login.rawValue, bundle: nil)
            guard let loginController = storyboard.instantiateViewController(withIdentifier:VC.LoginVC.rawValue) as? LoginVC else {
                return
            }
            let navigationController = UINavigationController(rootViewController: loginController)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            customStackTree.append(.LoginVC)
            
            
        case .Home:
            let storyboard:UIStoryboard = UIStoryboard(name: Storyboards.Home.rawValue, bundle: nil)
            guard let loginController = storyboard.instantiateViewController(withIdentifier:VC.HomeVC.rawValue) as? HomeVC else {
                return
            }
            let navigationController = UINavigationController(rootViewController: loginController)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = navigationController
           // let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //   statusBar.sty = UIColor.white
           // statusBar.col = .white
            self.window?.makeKeyAndVisible()
        case .Business:
            break;
        }
    }
    
    
    private func logout(fromVc:UIViewController?){
       // APIManager.requestWebServerWithAlamo(to: .Logout,  httpMethd: .post, completion: {onSuccess in
            
            self.deleteData(fromVc: fromVc)
//        }, onError: {onError in
//            self.deleteData(fromVc: fromVc)
//        //})
    }
    
    private func deleteData(fromVc:UIViewController?){
        LocalStorage.callLocalDBTo( dbActions: .Delete, accessKey: .AccessKeyLoggedData, processComplete: {pc in
            let LoginVC =  fromVc?.getVC(withId: VC.LoginVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? LoginVC
            
            if let LoginVC = LoginVC  {
                
                 DispatchQueue.main.async {
                    // Update UI
                    let nvc: UINavigationController = UINavigationController(rootViewController: LoginVC)
                    nvc.setNavigationBarHidden(true, animated: false)
                    self.window?.rootViewController = nvc
                }
                
            }
            else {
                //let LoginVC =  getVC(withId: VC.LoginVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? LoginVC
                 DispatchQueue.main.async {
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.logout(window: self.window)
                }
                
            }
            
            
        })
        
    }
    func saveLoggedData(registrationData:RegistrationRootClass?){
        ModelDataHolder.shared.loggedData  = registrationData?.data
        LocalStorage.saveLoggedData(authData: registrationData?.data)
        LocalStorage.saveAccessToken(accessToken: registrationData?.data?.token)
    }
    func loginToApp(registrationData:RegistrationRootClass?)  {
        //Save
        saveLoggedData(registrationData: registrationData)
        AppManager.Manager.initStoryBoard(type: .Home)
        
    }
    enum LogOutPriority:String {
        case High = "High"
        case Medium = "Medium"
        case low = "low"
    }
    func logoutFromApp(fromVc:UIViewController?,   priorityOfLogout:LogOutPriority = .Medium ){
        
        switch priorityOfLogout {
        case .High: logout(fromVc: fromVc)
        case .low:break
        case .Medium:
            Alert.shared.showAlertWithCompletion(buttons: ["YES","NO"], title: "Logout", msg: "Do you want to logout?", success: {someType in
                if someType == "YES"{
                    self.logout(fromVc: fromVc)
                }
                //  console(someType)
            })
        
        }
       
    }
 
}




class Logs{
    static  func printLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        // #if DEVELOPMENT
        let className = file.components(separatedBy: "/").last
        print(" ❌ Error at  ----> File: \(className ?? ""), Function: \(function), Line: \(line), Message: \(message)")
        //  #endif
    }}
