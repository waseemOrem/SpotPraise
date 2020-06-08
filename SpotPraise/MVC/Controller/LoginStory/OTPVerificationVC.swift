//
//  OTPVerificationVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseAuth

var userJustRegister = ""

class OTPVerificationVC: BaseViewController {
    
    //MARK: - Outlets
   
    @IBOutlet weak var tfOtp:AnimatableTextField?
      @IBOutlet weak var lblBehindResend:UILabel?
    @IBOutlet weak var lblResend:UILabel?
    
    
    //MARK: - Parametes
     let p = RegistrationData.CodingKeys.self
    var signUpParameters = [String:Any]()
   // var verifiedOTP = ""
    var verificationIDFromFireBase:String?// = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print(signUpParameters)
        //tfOtp?.text = verifiedOTP
        lblResend?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendOTP)))
        
      // loadCaptchaVerification()
        // Do any additional setup after loading the view.
    }
    
    func loadCaptchaVerification(){
        guard var phoneNumber = signUpParameters[p.phone.rawValue]! as? String else {
            return
            
        }
        
        guard let  cc = signUpParameters[p.countryCode.rawValue]! as? String else {
            return
            
        }
        
        phoneNumber = cc + phoneNumber
        print(phoneNumber)
        
        FireBaseMangerC.sharedManager.openCaptchaVerification(phoneNumberWithCountryCodeWithSign: phoneNumber, completion: { [weak self] uniqueID in
             self?.verificationIDFromFireBase  = uniqueID
            })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    @objc func resendOTP(){
       print("hi")
         loadCaptchaVerification()
        //self.requestOtpForRegistration()
    }
    @IBAction func verifyBtn(_ sender:UIButton){
        self.view.endEditing(true)
        if (self.tfOtp?.hasText)!{
            verifyOtp()
        }else {
            Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr: "Unable to verify!".localized)
        }
    }

    
}

//MARK:- webservices
extension OTPVerificationVC{
    
//    func requestOtpForRegistration()  {
//
//        let params = [
//            p.email.rawValue:signUpParameters[p.email.rawValue]!,
//            p.phone.rawValue:signUpParameters[p.phone.rawValue]!,
//            p.countryCode.rawValue:signUpParameters[p.countryCode.rawValue]!
//            ] as [String : Any]
//
//
//        APIManager.requestWebServerWithAlamo(to: .sentOtp, httpMethd: .post , params: params as [String : Any], completion: { response in
//            APIManager.getJsonDict(response: response, completion: {cleanDict in
//                var message = "Otp has been sent to your number.".localized
//                var otpIs = "0"
//                if let msg = cleanDict["msg"] as? String {
//                    message = msg
//                }
//
//                if let otp = cleanDict["otp"] as? String
//                {
//                    otpIs = otp
//                }
//
//                if let otp = cleanDict["otp"] as? Int {
//                    otpIs = String(otp)
//                }
//
//                if otpIs != "0" {
//                    self.tfOtp?.text = otpIs
//                    self.verifiedOTP = otpIs
//                   Alert.shared.showSimpleAlert(messageStr: message)
//                    //  Alert.shared.showSimpleAlert(messageStr: message)
//                }else {
//                    Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue)
//                }
//                // print(cleanDict)
//            })
//        })
//    }
    func verifyOtp(){
        guard let otpCode = self.tfOtp?.text else {
            return
        }
        guard let vID = verificationIDFromFireBase else {
            return
        }
        FireBaseMangerC.sharedManager.verifyCaptcha(veriFicationId: vID, otp: otpCode, completion: {[weak self] isVerified in
            self?.registerToServer()
        })
        
        
//         let p = RegistrationData.CodingKeys.self
//
//        let params = [p.email.rawValue:signUpParameters[p.email.rawValue]!,
//                      p.phone.rawValue:signUpParameters[p.phone.rawValue]!,
//                      p.countryCode.rawValue:signUpParameters[p.countryCode.rawValue]!,
//                               "otp":self.verifiedOTP] as [String : Any]
//
//
//
//        APIManager.requestWebServerWithAlamo(to: .verifyOtp, httpMethd: .post , params: params as [String : Any], completion: { [weak self] response in
//
//             self?.registerToServer()
//
////        APIManager.getJsonDict(response: response, completion: { [weak self] cleanDict in
////            print(cleanDict)
////        var message = "verified successfully.".localized
////
////        if let msg = cleanDict["msg"] as? String {
////        message = msg
////        }
////
////            Alert.shared.showAlertWithCompletion(buttons: ["Proceed to complete the registration?","Cancel"], msg: message, success: {option in
////                if option == "Proceed to complete the registration?"{
////
////                }
////            })
////        // print(cleanDict)
////        }
////            )
//        })
    }
    func registerToServer() {
        let p = RegistrationData.CodingKeys.self
         APIManager.requestWebServerWithAlamo(to: .register, httpMethd: .post , params: signUpParameters as [String : Any], completion: { [weak self] response in
            
//                                        APIManager.getJsonDict(response: response, completion: {cleanDict in
//
//                                      console(cleanDict)
//                                        })
            
           let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            //  let resData  = (try? JSONDecoder().decode(RegistrationRootClass.self, from: response.data! ))
            
            if response.response?.statusCode == 200{
                guard  resData?.data != nil else {
                     Alert.shared.showSimpleAlert(_title: "Alert".localized, messageStr: resData?.msg ?? "Some Error")
                    return}
               
                Alert.shared.showSimpleAlert(_title: "Message".localized, messageStr: resData?.msg ?? "User Registered successfully.")
                 userJustRegister = self?.signUpParameters[p.email.rawValue] as! String
                self?.navigationController?.popToRootViewController(animated: true)
              // AppManager.Manager.loginToApp(registrationData: resData)
            }
            else {
                Alert.shared.showSimpleAlert(_title: "Alert".localized, messageStr:MESSAGES.RESPONSE_ERROR.rawValue )
                
            }
        }
            , onError: { [weak self] (errIs) in
                if let er = errIs as? String {
                    Alert.shared.showSimpleAlert(_title: "Alert".localized, messageStr: MESSAGES.RESPONSE_ERROR.rawValue )
                    
                }
                
                
        })
        
        
        
        
    }
}
