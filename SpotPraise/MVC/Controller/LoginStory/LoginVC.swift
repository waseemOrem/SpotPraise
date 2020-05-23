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

        // Do any additional setup after loading the view.
    }
    //MARK: -Actions
    @IBAction func btnActionConti(){
         AppManager.Manager.initStoryBoard(type: .Home)
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
   
}


//MARK: -Outlets


//MARK: -Parameters


//MARK: -Actions

//MARK: -CustomFunctions
//MARK: -Delegates
//MARK: -APIS

