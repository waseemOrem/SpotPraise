//
//  LoginVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //MARK: -Outlets
    @IBOutlet weak var tFUserName:AnimatableTextField?
    @IBOutlet weak var tFUserPassword:AnimatableTextField?
    @IBOutlet weak var btnContinue:UIButton?
     @IBOutlet weak var btnForgetPss:UIButton?
     @IBOutlet weak var btnCreateAcc:UIButton?
    
    //MARK: -Parameters
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
tFUserPassword?.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocalStorage.callLocalDBTo( dbActions: .Fetch, accessKey: .AccesskeyEmail, processComplete: {maildata in
            
            guard let mail = maildata as? String else {return}
            self.tFUserName?.text = mail
            
        })
        
    }
    //MARK: -Actions
    @IBAction func btnActionConti(){
        let validM = Validation.Validate
        validM.delegate = self
        
        if  validM.validateForEmpty(validatedObj: tFUserName, forInvalid: "Please enter username") &&  validM.validateForEmpty(validatedObj: tFUserPassword, forInvalid: "Please enter password"){
           // AppManager.Manager.initStoryBoard(type: .Home)
            loginToServer()
        }
        
    }
    @IBAction func btnActionForget(){
        guard let vc = getVC(withId: VC.ForgotVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? ForgotVC else {
            return
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnActionCreateNewAcc(){
        guard let vc = getVC(withId: VC.SignUpVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? SignUpVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }
 }

extension LoginVC{
    func loginToServer(){
        let p = RegistrationData.CodingKeys.self
        let param = [p.email.rawValue:tFUserName!.text!,
                     p.password.rawValue:tFUserPassword!.text!]
            APIManager.requestWebServerWithAlamo(to: .login, httpMethd: .post , params: param as [String : Any], completion: { response in
                
                APIManager.getJsonDict(response: response, completion: {cleanDict in
                    
                    console(cleanDict)
                })
                
                let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
                //  let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
                
                if response.response?.statusCode == 200{
                    guard  resData?.data != nil else {
                        Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
                        return}
                     AppManager.Manager.loginToApp(registrationData: resData)
//                   //Save
//                    ModelDataHolder.shared.loggedData  = resData?.data
//                    LocalStorage.saveLoggedData(authData: resData?.data)
//                    LocalStorage.saveAccessToken(accessToken: resData?.data?.token)
//                    AppManager.Manager.initStoryBoard(type: .Home)
//
                    
                }
                else {
                    Alert.shared.showSimpleAlert(messageStr:resData?.msg ?? MESSAGES.RESPONSE_ERROR.rawValue )
                    
                }
            }
                , onError: { (errIs) in
                    if let er = errIs as? String {
                        Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue )
                        
                    }
                    
                    
            })
            
            
            
            
        }
   
}


//MARK: -Outlets


//MARK: -Parameters


//MARK: -Actions

//MARK: -CustomFunctions
//MARK: -Delegates
//MARK: -APIS

extension LoginVC : validationListner{
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        Alert.shared.showAlertWithCompletion(buttons: ["ok"], msg: message, success: { [weak self]
            ok in
        
            if let f = validationCandidate as? UITextField {
                f.becomeFirstResponder()
            }
            
        })
    }
    
    
}
