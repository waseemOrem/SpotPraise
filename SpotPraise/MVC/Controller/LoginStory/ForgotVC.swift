//
//  ForgotVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController ,validationListner{
   
    

    @IBOutlet weak var tfEmail: AnimatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClickBck(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnClickDone(_ sender: Any) {
        Validation.Validate.delegate = self
       guard  Validation.Validate.validateForEmpty(validatedObj: tfEmail, forInvalid: "Please enter correct email"),
        Validation.Validate.validateForEmail(tfEmail, forInvalid: "Please enter correct email") else {
            return
        }
        requestForget()
        
    }
    
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr: message)
    }
   
    func requestForget()  {
        let p = RegistrationData.CodingKeys.self
        let params = [
            p.email.rawValue:tfEmail!.text!
            ] as [String : Any]
        
        APIManager.requestWebServerWithAlamo(to: .forgetPassword, httpMethd: .post , params: params as [String : Any], completion: { [weak self]  response in
            APIManager.getJsonDict(response: response, completion: {cleanDict in
                var message = "success.".localized
                 if let msg = cleanDict["msg"] as? String {
                    message = msg
                }
                Alert.shared.showSimpleAlert(_title: "Message".localized, messageStr: message)
               // Alert.shared.showSimpleAlert(messageStr: message)
                 
                // print(cleanDict)
            })
        })
    }

}
