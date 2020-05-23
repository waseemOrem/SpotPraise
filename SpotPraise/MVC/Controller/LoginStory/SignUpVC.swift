//
//  SignUpVC.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

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
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
   
    @IBAction func btnActionBck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true )
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        guard  let vc = self.getVC(withId: VC.OTPVerificationVC.rawValue, storyBoardName: Storyboards.Login.rawValue) as? OTPVerificationVC else {
            return
        }
        self.pushVC(vc)
    }
    
    @IBAction func btnAlreadyAccClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true )
    }
    

}

//MARK: -CustomFunctions
//MARK: -Delegates
//MARK: -APIS
