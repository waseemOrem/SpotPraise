import Foundation

import UIKit

typealias AlertBlock = (_ success: AlertTag, _ txt : String?, _ model : [Any]?) -> ()
typealias AlertTextBlock = (_ success: AlertTag , _ txt : String?, _ model : [Any]? ) -> ()

//MARK:- ENUM
enum AlertTag {
    case yes
    case no
}

class Alert: NSObject  {
    
    var responseBack : AlertBlock?
    var responseTxtBack : AlertTextBlock?
    
    static let shared = Alert()
    enum NumberOfButtons {
        case one
        case two
    }
    
    
    override init() {
        super.init()
        //        alertView = getVC(withId: VC.PopUpViewController.rawValue, storyBoardName: Storyboards.Login.rawValue) as? PopUpViewController
    }
    
    func topMostController() -> UIViewController? {
        var from = UIApplication.shared.keyWindow?.rootViewController
        while (from != nil) {
            if let to = (from as? UITabBarController)?.selectedViewController {
                from = to
            } else if let to = (from as? UINavigationController)?.visibleViewController {
                from = to
            } else if let to = from?.presentedViewController {
                from = to
            } else {
                break
            }
        }
        return from
    }
    func showAlertWithCompletion(  buttons : [String],title:String? = "Message" ,msg:String?, success : @escaping (String) -> ()) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        controller.view.tintColor = #colorLiteral(red: 0.2156862745, green: 0.5843137255, blue: 0.8431372549, alpha: 1)
        for button in buttons{
            let action = UIAlertAction(title: button.localized , style: .default, handler: { (action) -> Void in
                success(button)
            })
            controller.addAction(action)
        }
        
        if let topController = UIApplication.topViewController() {
            // DispatchQueue.main.async {
            topController.present(controller, animated: true, completion: { () -> Void in
            })
            // }
            
        }
        
    }
    
    
    func showSimpleAlert( _title:String? , messageStr:String) -> Void {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: _title, message:  messageStr, preferredStyle: UIAlertController.Style.alert);
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
    
    //MARK:- Actions sheet
    func showActionSheetWithStringButtons(  buttons : [String] , success : @escaping (String) -> ()) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        controller.view.tintColor = #colorLiteral(red: 0.2156862745, green: 0.5843137255, blue: 0.8431372549, alpha: 1)
        for button in buttons{
            let action = UIAlertAction(title: button.localized , style: .default, handler: { (action) -> Void in
                success(button)
            })
            controller.addAction(action)
        }
        if let topController = UIApplication.topViewController() {
            topController.present(controller, animated: true, completion: { () -> Void in
            })
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized , style: UIAlertAction.Style.cancel) { (button) -> Void in}
        //        guard let label = (cancel.value(forKey: "__representer") as? AnyObject)?.value(forKey: "label") as? UILabel else { return }
        //            label.font = R.font.avenirLTStdBook(size: 14)
        
        controller.addAction(cancel)
        
        if let topController = UIApplication.topViewController() {
            topController.present(controller, animated: true, completion: { () -> Void in
            })
        }
        
    }
    
    
    
    
    
    //MARK:- DELEGATE FUNCTION
    func btnPopUpPressed(clickedButtonIndex index: Int, buttonTitle title: String?, isTextField : Bool?, model : [Any]? , textFieldText : String?) {
        switch index {
        case 0: responseBack?(.yes, /textFieldText, model)
        case 1: responseBack?(.no, /textFieldText , [])
        default: return
        }
    }
}
