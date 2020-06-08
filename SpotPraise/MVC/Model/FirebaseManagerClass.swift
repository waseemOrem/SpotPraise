//
//  FirebaseManagerClass.swift
//  SpotPraise
//
//  Created by admin on 07/06/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import FirebaseAuth


class FireBaseMangerC{
    
    private init(){}
    
    class var sharedManager: FireBaseMangerC {
        struct Singleton {
            static let instance = FireBaseMangerC()
        }
        return Singleton.instance
    }
  //  completion:@escaping (_ jsonData:DataResponse<Any>) -> Void )
    func  openCaptchaVerification(phoneNumberWithCountryCodeWithSign:String?,  completion:@escaping (_ verificationID:String?) -> Void) {
        guard let phoneNumber = phoneNumberWithCountryCodeWithSign else {
            return
            
        }
        print(phoneNumber)
        
        PhoneAuthProvider.provider().verifyPhoneNumber( phoneNumber, uiDelegate: nil, completion: {(veriFicationId , error) in
            
             if error == nil {
                print(veriFicationId)
                completion(veriFicationId)
               // self.verificationIDFromFireBase  = veriFicationId
                
                
            }else {
                 Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr:error?.localizedDescription ?? "unable to get secret id from firebase".localized)
                //Toast.show(message:error?.localizedDescription ?? "unable to get secret id from firebase" , controller: nil)
                print("unable to get secret id from firebase",error?.localizedDescription)
            }
        })
    }
    
    func verifyCaptcha(veriFicationId:String? , otp:String? , completion:@escaping (_ isVerified:Bool?) -> Void) {
        
        guard let otpCode = otp else {
            return
        }
        guard let vID = veriFicationId else {
            return
        }
        
        let credentails = PhoneAuthProvider.provider().credential(withVerificationID: vID, verificationCode: otpCode)
         Loader.shared.showLoader()
        Auth.auth().signIn(with: credentails, completion: {(success , error) in
            Loader.shared.hideLoader()
            if error == nil {
                Loader.shared.hideLoader()
                completion(true)
            }else {
                Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr:error?.localizedDescription ?? "Unable to verify please try again after sometime.".localized)
                 print("unable to get secret id from firebase",error?.localizedDescription)
            }
            
        })
    }
}


