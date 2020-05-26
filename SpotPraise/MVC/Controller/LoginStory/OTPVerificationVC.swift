//
//  OTPVerificationVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class OTPVerificationVC: BaseViewController {
    
    //MARK: - Outlets
   
    @IBOutlet weak var tfOtp:AnimatableTextField?
      @IBOutlet weak var lblBehindResend:UILabel?
    @IBOutlet weak var lblResend:UILabel?
    
    
    //MARK: - Parametes
    
    var signUpParameters = [String:Any]()
    var verifiedOTP = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(signUpParameters)
        tfOtp?.text = verifiedOTP
        lblResend?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendOTP)))
        
       
        // Do any additional setup after loading the view.
    }
    
    @objc func resendOTP(){
       print("hi")
        requestOtpForRegistration()
    }
    @IBAction func verifyBtn(_ sender:UIButton){
        if (self.tfOtp?.hasText)!{
            verifyOtp()
        }else {
        Alert.shared.showSimpleAlert(messageStr: "Unable to verify!")
        }
    }

    
}

//MARK:- webservices
extension OTPVerificationVC{
    
    func requestOtpForRegistration()  {
        let p = RegistrationData.CodingKeys.self
        let params = [
            p.email.rawValue:signUpParameters[p.email.rawValue]!,
            p.phone.rawValue:signUpParameters[p.phone.rawValue]!,
            p.countryCode.rawValue:signUpParameters[p.countryCode.rawValue]!
            ] as [String : Any]
  
        
        APIManager.requestWebServerWithAlamo(to: .sentOtp, httpMethd: .post , params: params as [String : Any], completion: { response in
            APIManager.getJsonDict(response: response, completion: {cleanDict in
                var message = "Otp has been sent to your number.".localized
                var otpIs = "0"
                if let msg = cleanDict["msg"] as? String {
                    message = msg
                }
                
                if let otp = cleanDict["otp"] as? String
                {
                    otpIs = otp
                }
                
                if let otp = cleanDict["otp"] as? Int {
                    otpIs = String(otp)
                }
               
                if otpIs != "0" {
                    self.tfOtp?.text = otpIs
                    self.verifiedOTP = otpIs
                   Alert.shared.showSimpleAlert(messageStr: message)
                    //  Alert.shared.showSimpleAlert(messageStr: message)
                }else {
                    Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue)
                }
                // print(cleanDict)
            })
        })
    }
    func verifyOtp(){
        
         let p = RegistrationData.CodingKeys.self
        
        let params = [p.email.rawValue:signUpParameters[p.email.rawValue]!,
                      p.phone.rawValue:signUpParameters[p.phone.rawValue]!,
                      p.countryCode.rawValue:signUpParameters[p.countryCode.rawValue]!,
                               "otp":self.verifiedOTP] as [String : Any]
        
        
        
        APIManager.requestWebServerWithAlamo(to: .verifyOtp, httpMethd: .post , params: params as [String : Any], completion: { response in
        APIManager.getJsonDict(response: response, completion: {cleanDict in
            print(cleanDict)
        var message = "verified successfully.".localized
        
        if let msg = cleanDict["msg"] as? String {
        message = msg
        }
        
            Alert.shared.showAlertWithCompletion(buttons: ["Proceed to complete the registration?","Cancel"], msg: message, success: {option in
                if option == "Proceed to complete the registration?"{
                    self.registerToServer()
                }
            })
        // print(cleanDict)
        }
            )
        })
    }
    func registerToServer() {
         APIManager.requestWebServerWithAlamo(to: .register, httpMethd: .post , params: signUpParameters as [String : Any], completion: { response in
            
                                        APIManager.getJsonDict(response: response, completion: {cleanDict in
            
                                      console(cleanDict)
                                        })
            
            let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            //  let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            
            if response.response?.statusCode == 200{
                guard  resData?.data != nil else {
                    Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: resData?.msg ?? MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
                    return}
               AppManager.Manager.loginToApp(registrationData: resData)
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
