//
//  SignUpVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ADCountryPicker
import FirebaseAuth


class SignUpVC: BaseViewController {

    //MARK: -Outlets
    
     @IBOutlet weak var lblCreateAcc: UILabel?
    
    @IBOutlet weak var tfUserName: AnimatableTextField!
    @IBOutlet weak var tfCompanyName: AnimatableTextField?
    @IBOutlet weak var tfEmail: AnimatableTextField!
    
    @IBOutlet weak var tfPss: AnimatableTextField!
    
    @IBOutlet weak var lblCC: UILabel!
    
    @IBOutlet weak var lblAccDescr: UILabel!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfPhoneNo: AnimatableTextField!
    
    
    //MARK: -Parameters
    private let adpicker = ADCountryPicker()
 let dropDown : DropDown = DropDown()
    private var companyData:[CompanyListData]?
    var companyID = "0"
    
     override func viewDidLoad() {
        super.viewDidLoad()
 adpicker.delegate = self
        //tfPhoneNo.delegate = self
        tfCompanyName?.addRightImage(img : #imageLiteral(resourceName: "ic_dropdown") , imgFrame : CGRect(x: 0, y: 0, width: 32, height: 18))
        
          self.getCompanies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    //MARK: -Actions
    @IBAction func btnActionDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        self.setupDropDownMenu(for: self.dropDown, on: self.tfCompanyName, with:companyData, textField: self.tfCompanyName)
    }
    
    
    func setupDropDownMenu(for dropDown : DropDown?, on anchor : AnchorView?, with dataSource : [Any]?, textField : UITextField? ) {
        guard let dropDown = dropDown else { return }
        dropDown.anchorView = anchor
        guard let dataS = dataSource as? [CompanyListData] else {
            return
        }
        dropDown.dataSource = ((dataS.map { return $0.name } ) as? [String])!
        dropDown.width = /textField?.bounds.width
        dropDown.bottomOffset.y = /anchor?.plainView.bounds.maxY
        dropDown.direction = .bottom
        dropDown.backgroundColor = .white
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.2156862745, green: 0.5843137255, blue: 0.8431372549, alpha: 0.1586312072)
        dropDown.selectionAction = { [weak self] (index, item) in
            
            self?.companyID = dataS[index].id!
            textField?.text = item
        }
        dropDown.show()
    }
    
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
        Validation.Validate.validateForEmpty(validatedObj: tfPhoneNo, forInvalid: "Please enter a valid phone number.") ,
        Validation.Validate.validateForPhoneNumber(tfPhoneNo, forInvalid: "Please enter a valid phone number.")
        else {
            return
        }
        if companyID != "0"{
            
            verifyCredentialsFromServer()
 
        }
        else {
            Alert.shared.showSimpleAlert(_title: "Error".localized, messageStr: "Please choose company".localized)
        }
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
    
    func getCompanies(){
        
        APIManager.requestWebServerWithAlamo(to: .companylist, httpMethd: .get, completion: { [weak self] postResponse in

            APIManager.getJsonDict(response: postResponse, completion: {celn in
                
                print(celn)
            })
                        let resData  = (try? JSONDecoder().decode(CompanyListRootClass.self, from: postResponse.data! ))
            if postResponse.response?.statusCode == 200{
                guard  resData?.data != nil else {
                    //                    Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
                    return}
                
                self?.companyData = resData?.data
              
                
            }
        
        })
    }
    
    
    func verifyCredentialsFromServer()  {
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
            p.companyId.rawValue:self.companyID,
            "devicetype":"ios",
            "devicetoken":deviceTokenString
            ] as [String : Any]
        
        

         APIManager.requestWebServerWithAlamo(to: .sentOtp, httpMethd: .post , params: params as [String : Any], completion: { response in
           if  response.response?.statusCode == 200 {
            
                        let  phoneNumber = self.lblCC.text! + self.tfPhoneNo.text!
                        FireBaseMangerC.sharedManager.openCaptchaVerification(phoneNumberWithCountryCodeWithSign: phoneNumber, completion: { [weak self] uniqueID in
            
                            guard let vc = self?.getVC(withId: VC.OTPVerificationVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? OTPVerificationVC else {
                                return
                            }
                            vc.signUpParameters = paramsForSignUP
                            vc.verificationIDFromFireBase = uniqueID
                            self?.pushVC(vc)
            
                        })
            }
            
        })
    }
    
    
}

extension SignUpVC:validationListner{
    func unableToValidate(validationCandidate: AnyObject?, message: String) {
        guard let txtField = validationCandidate as? UITextField else {
            return
        }
        
        Alert.shared.showAlertWithCompletion(buttons: ["ok"], msg: message, success: {   _ in
            
            txtField.becomeFirstResponder()
            
            
        })
    }
    
    
}


//MARK:  -ADCountryPickerDelegate

extension SignUpVC:ADCountryPickerDelegate,UITextFieldDelegate
{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        print(code)
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(dialCode)
        self.lblCC?.text = dialCode
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
}



