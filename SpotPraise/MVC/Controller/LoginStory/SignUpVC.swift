//
//  SignUpVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ADCountryPicker

class SignUpVC: BaseViewController {

    //MARK: -Outlets
    
     @IBOutlet weak var lblCreateAcc: UILabel?
    
    @IBOutlet weak var tfUserName: AnimatableTextField!
    
    @IBOutlet weak var tfEmail: AnimatableTextField!
    
    @IBOutlet weak var tfPss: AnimatableTextField!
    
    @IBOutlet weak var lblCC: UILabel!
    
    @IBOutlet weak var lblAccDescr: UILabel!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfPhoneNo: AnimatableTextField!
    
    
    //MARK: -Parameters
    private let adpicker = ADCountryPicker()

    
     override func viewDidLoad() {
        super.viewDidLoad()
 adpicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
   
    @IBAction func btnActionBck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true )
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        Validation.Validate.delegate = self
        guard Validation.Validate.validateForEmpty(validatedObj: tfUserName, forInvalid: "Please enter correct user name."),
            Validation.Validate.validateForEmpty(validatedObj: tfEmail, forInvalid: "Please enter the correct email."),
            Validation.Validate.validateForEmail(tfEmail, forInvalid: "Please enter the correct email."),
            Validation.Validate.validateForEmpty(validatedObj: tfPss, forInvalid: "Please enter the password."),
            Validation.Validate.validatePasswordLength(tfPss, forInvalid: "Passwords must be minimum 6 characters long"),
        Validation.Validate.validateForEmpty(validatedObj: tfPhoneNo, forInvalid: "Please enter a valid phone number.") else {
            return
        }
        requestOtpForRegistration()
//        guard  let vc = self.getVC(withId: VC.OTPVerificationVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? OTPVerificationVC else {
//            return
//        }
//        self.pushVC(vc)
    }
     @IBAction func btnAddCodeClick(_ sender: Any) {
             self.view.endEditing(true)
            let pickerNavigationController = UINavigationController(rootViewController: adpicker)
                self.present(pickerNavigationController, animated: true, completion: nil)
    }
    @IBAction func btnAlreadyAccClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true )
    }
    

}


//MARK: -API Functions
extension SignUpVC{
    func requestOtpForRegistration()  {
        let p = RegistrationData.CodingKeys.self
        let params = [
                      p.email.rawValue:tfEmail!.text!,
                      p.phone.rawValue:tfPhoneNo!.text!,
                      p.countryCode.rawValue:lblCC.text!
                      ] as [String : Any]
        
      
        let paramsForSignUP = [p.username.rawValue:tfUserName!.text!,
                               p.name.rawValue:tfUserName.text!,
                               p.password.rawValue:tfPss.text!,
                    p.email.rawValue:tfEmail!.text!,
            p.phone.rawValue:tfPhoneNo!.text!,
            p.countryCode.rawValue:lblCC.text!,
            "devicetype":"ios",
            "devicetoken":deviceTokenString
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
                    Alert.shared.showAlertWithCompletion(buttons: ["Verify" ,"Cancel"], msg: message, success: {option in
                        
                        if option == "Verify"{
                            guard let vc = self.getVC(withId: VC.OTPVerificationVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? OTPVerificationVC else {
                                return
                            }
                            vc.signUpParameters = paramsForSignUP
                            vc.verifiedOTP = otpIs
                            self.pushVC(vc)
                        }
                        
                    })
                  //  Alert.shared.showSimpleAlert(messageStr: message)
                }else {
                    Alert.shared.showSimpleAlert(messageStr: MESSAGES.RESPONSE_ERROR.rawValue)
                }
               // print(cleanDict)
            })
        })
    }
    
    
}

extension SignUpVC:validationListner{
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        guard let txtField = validationCandidate as? UITextField else {
            return
        }
        
        Alert.shared.showAlertWithCompletion(buttons: ["ok"], msg: message, success: { _ in
            
            txtField.becomeFirstResponder()
            
            
        })
    }
    
    
}


//MARK:  -ADCountryPickerDelegate

extension SignUpVC:ADCountryPickerDelegate
{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        print(code)
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(dialCode)
        self.lblCC?.text = dialCode
        self.dismiss(animated: true, completion: nil)
        
    }
}
