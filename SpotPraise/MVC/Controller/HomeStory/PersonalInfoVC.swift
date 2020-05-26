//
//  PersonalInfoVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PersonalInfoVC: BaseViewController {

    //MARK: -OUtlets
    @IBOutlet weak var imgUser:UIImageView?
    @IBOutlet weak var tfFullName:UITextField?
    @IBOutlet weak var tfEmail:UITextField?
    @IBOutlet weak var tfPhoneNumber:UITextField?
    
    //MARK: -ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail?.isUserInteractionEnabled = false
        tfPhoneNumber?.isUserInteractionEnabled = false
updateData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Custom func
    func updateData(){
        let p = RegistrationData.CodingKeys.self

        let paramsForSignUP = [
            p.name.rawValue:tfFullName!.text!,
                               "devicetype":"ios",
                               "devicetoken":deviceTokenString
            ] as [String : Any]
        
    }
    func uploadData(){
        
        guard let userData = ModelDataHolder.shared.loggedData else {
            return
        }
        self.tfFullName?.text = userData.name
        self.tfEmail?.text = userData.email
        self.tfPhoneNumber?.text =  userData.countryCode! + " " +  userData.phone!
    }
    
    //MARK: -Actions
    @IBAction func btnUpdateProfile(_ sender:UIButton){
     updateData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
