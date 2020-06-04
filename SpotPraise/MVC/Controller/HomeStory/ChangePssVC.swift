//
//  ChangePssVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ChangePssVC: BaseViewController,validationListner {
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        guard  let f = validationCandidate as? UITextField else {
            return
        }
        f.becomeFirstResponder()
        Alert.shared.showSimpleAlert(messageStr: message)
    }
    

    @IBOutlet weak var tfCurrentPass:AnimatableTextField?
    
    @IBOutlet weak var tfNewPass:AnimatableTextField?
    
    @IBOutlet weak var tfConfirmPass:AnimatableTextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
   
    @IBAction func btnDoneClick(){
        self.view.endEditing(true)
        let vali = Validation.Validate
        vali.delegate = self
        guard Validation.Validate.validateForEmpty(validatedObj: tfCurrentPass, forInvalid: "Please enter current Password"),
vali.validateForEmpty(validatedObj: tfNewPass, forInvalid: "Please enter new Password"),
        vali.validateForEmpty(validatedObj: tfConfirmPass, forInvalid: "Please enter confirm Password")
        else {
            return
        }
        
        if tfNewPass?.text != tfConfirmPass?.text{
            Alert.shared.showSimpleAlert(messageStr: "New password and confirm password doesn't match.")
        }
        
        else {
            reguestToChangePss()
        }
    }

    
    func reguestToChangePss(){
        let params = ["oldPass":tfCurrentPass!.text!,
                      "newPass":tfConfirmPass!.text!] as [String : Any]
        
         APIManager.requestWebServerWithAlamo(to: .changePassword, httpMethd: .post , params: params as [String : Any], completion: { response in
            APIManager.getJsonDict(response: response, completion: {cleanDict in
                print(cleanDict)
                var message = "changed successfully.".localized
                
                if let msg = cleanDict["msg"] as? String {
                    message = msg
                }
               
                
                guard let responV = cleanDict["response"] as? String else {
                    Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue)
                    return
                }
                 Toast.show(message: message, controller: self)
                if responV == "1"{
                    
                    AppManager.Manager.logoutFromApp(fromVc: self, priorityOfLogout: .High)
                }
              
            }
            )
        })
    }

}


