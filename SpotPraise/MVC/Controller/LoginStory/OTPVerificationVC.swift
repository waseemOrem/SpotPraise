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
   private var verificationIDFromFireBase:String?// = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(signUpParameters)
        //tfOtp?.text = verifiedOTP
        lblResend?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendOTP)))
        
       loadCaptchaVerification()
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
        
        PhoneAuthProvider.provider().verifyPhoneNumber( phoneNumber, uiDelegate: nil, completion: {(veriFicationId , error) in
            
            
            
            if error == nil {
                print(veriFicationId)
                self.verificationIDFromFireBase  = veriFicationId
                
                
            }else {
                Toast.show(message:error?.localizedDescription ?? "unable to get secret id from firebase" , controller: self)
                print("unable to get secret id from firebase",error?.localizedDescription)
            }
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
        Alert.shared.showSimpleAlert(messageStr: "Unable to verify!")
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
        let credentails = PhoneAuthProvider.provider().credential(withVerificationID: vID, verificationCode: otpCode)
        
        Auth.auth().signIn(with: credentails, completion: {(success , error) in
            if error == nil {
                self.registerToServer()
            }else {
                Alert.shared.showSimpleAlert("Error".localized, messageStr: "Unable to verify please try again after sometime.".localized)
            }
            
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
//                guard  resData?.data != nil else {
//                    Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: resData?.msg ?? MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
//                    return}
               // AppManager.Manager.saveLoggedData(registrationData: resData)
                Toast.show(message: resData?.msg ?? "User Registered successfully.", controller: self!)
                userJustRegister = self?.signUpParameters[p.email.rawValue] as! String
                self?.navigationController?.popToRootViewController(animated: true)
              // AppManager.Manager.loginToApp(registrationData: resData)
            }
            else {
                Alert.shared.showSimpleAlert(messageStr:MESSAGES.RESPONSE_ERROR.rawValue )
                
            }
        }
            , onError: { [weak self] (errIs) in
                if let er = errIs as? String {
                    Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue )
                    
                }
                
                
        })
        
        
        
        
    }
}
