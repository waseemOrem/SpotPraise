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
        guard let field = validatedObj as? UITextField else {
            return false
            
        }
        if (field.text!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            delegate?.unableToValidate(validationCandidate: validatedObj, message: (msg)!)
            return false
        }
         
        return true 
    }
}
