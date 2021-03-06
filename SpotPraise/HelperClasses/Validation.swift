//
//  Validation.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import  UIKit

protocol validationListner:AnyObject {
    func unableToValidate(validationCandidate:AnyObject?,message:String)
}
class Validation {
    static let Validate = Validation()
    private init(){}
    weak var delegate:validationListner?
    
    func validateForEmpty(validatedObj:AnyObject?, forInvalid msg:String?)->Bool{
        //print(validatedObj)
        if let field = validatedObj as? UITextField
        {
            if (field.text!.trimmingCharacters(in: .whitespaces).isEmpty)
            {
                delegate?.unableToValidate(validationCandidate: validatedObj, message: (msg)!)
                return false
            }
        } else if let field = validatedObj as? UITextView{
            
            if (field.text!.trimmingCharacters(in: .whitespaces).isEmpty)
            {
                delegate?.unableToValidate(validationCandidate: validatedObj, message: (msg)!)
                return false
            }
             
            
        }
        
         
        return true 
    }
    
    func validatePasswordLength(_ validateObj:UITextField, forInvalid msg:String) ->Bool{
       
        
        if (validateObj.text?.count)! < 6 {
            return false
        }
        
        return true
    }
    func validateURL(_ validateObj:UITextField, forInvalid msg:String) -> Bool {
        
        
//            if (validateObj.text!.trimmingCharacters(in: .whitespaces).isEmpty)
//            {
//                delegate?.unableToValidate(validationCandidate: validateObj, message: (msg))
//                return false
//            }
        
        var returnType = false
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w#\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
       returnType = urlTest.evaluate(with: validateObj.text)
        if !returnType{
            delegate?.unableToValidate(validationCandidate: validateObj, message: (msg))
        }
        return returnType
    }
    
    func validateForEmail(_ emailField:UITextField, forInvalid msg:String?) -> Bool {
        
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        if !emailTest.evaluate(with: emailField.text){
            delegate?.unableToValidate(validationCandidate: emailField, message: (msg)!)
            return false
        }
        return emailTest.evaluate(with: emailField.text)
    }
    
    func validateForPhoneNumber(_ phoneField:UITextField, forInvalid msg:String?) -> Bool {
        
        var returnType = false
        if (phoneField.text?.count)! < 10 {
            delegate?.unableToValidate(validationCandidate: phoneField, message: msg ?? "Invalid phone number".localized)
            return returnType
        }
            
        let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
        let characterSet = CharacterSet(charactersIn: phoneField.text!)
       returnType =  allowedCharacters.isSuperset(of: characterSet)
        
        if !returnType{
            delegate?.unableToValidate(validationCandidate: phoneField, message: msg ?? "Invalid phone number".localized)
        }
        
        return true
    }
}
